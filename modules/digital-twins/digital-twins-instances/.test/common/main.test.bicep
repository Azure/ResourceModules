targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.digitaltwins.digitaltwinsinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dtdticom'

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
    eventHubName: 'dt-${uniqueString(serviceShort)}-evh-01'
    eventHubNamespaceName: 'dt-${uniqueString(serviceShort)}-evhns-01'
    serviceBusName: 'dt-${uniqueString(serviceShort)}-sb-01'
    eventGridDomainName: 'dt-${uniqueString(serviceShort)}-evg-01'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${uniqueString(serviceShort)}-evh-01'
    eventHubNamespaceName: 'dep-${uniqueString(serviceShort)}-evh-01'
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
    eventHubEndpoint: {
      authenticationType: 'IdentityBased'
      endpointUri: 'sb://${nestedDependencies.outputs.eventhubNamespaceName}.servicebus.windows.net/'
      entityPath: nestedDependencies.outputs.eventhubName
      userAssignedIdentity: nestedDependencies.outputs.managedIdentityResourceId
    }
    serviceBusEndpoint: {
      authenticationType: 'IdentityBased'
      endpointUri: 'sb://${nestedDependencies.outputs.serviceBusName}.servicebus.windows.net/'
      entityPath: nestedDependencies.outputs.serviceBusTopicName
      userAssignedIdentity: nestedDependencies.outputs.managedIdentityResourceId
    }
    eventGridEndpoint: {
      eventGridDomainId: nestedDependencies.outputs.eventGridDomainResourceId
      topicEndpoint: nestedDependencies.outputs.eventGridEndpoint
    }
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    lock: 'CanNotDelete'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            nestedDependencies.outputs.privateDNSResourceId
          ]
        }
        service: 'API'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalResourceId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
