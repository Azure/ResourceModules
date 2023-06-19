targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.servicebus.namespaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sbncom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    lock: 'CanNotDelete'
    skuName: 'Premium'
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    networkRuleSets: {
      defaultAction: 'Deny'
      trustedServiceAccessEnabled: true
      virtualNetworkRules: [
        {
          subnet: {
            ignoreMissingVnetServiceEndpoint: true
            id: nestedDependencies.outputs.subnetResourceId
          }
        }
      ]
      ipRules: [
        {
          ipMask: '10.0.1.0/32'
          action: 'Allow'
        }
        {
          ipMask: '10.0.2.0/32'
          action: 'Allow'
        }
      ]
    }
    authorizationRules: [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'AnotherKey'
        rights: [
          'Listen'
          'Send'
        ]
      }
    ]
    queues: [
      {
        name: '${namePrefix}${serviceShort}q001'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              nestedDependencies.outputs.managedIdentityPrincipalId
            ]
            principalType: 'ServicePrincipal'
          }
        ]
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
      }
    ]
    topics: [
      {
        name: '${namePrefix}${serviceShort}t001'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              nestedDependencies.outputs.managedIdentityPrincipalId
            ]
            principalType: 'ServicePrincipal'
          }
        ]
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    privateEndpoints: [
      {
        service: 'namespace'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            nestedDependencies.outputs.privateDNSZoneResourceId
          ]
        }
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
  }
}
