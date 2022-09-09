targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.virtualnetworks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvncom'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    routeTableName: 'dep-<<namePrefix>>-rt-${serviceShort}'
    networkSecurityGroupName: 'dep-<<namePrefix>>-nsg-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    dnsServers: [
      '10.0.1.4'
      '10.0.1.5'
    ]
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    subnets: [
      {
        addressPrefix: '10.0.255.0/24'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '10.0.0.0/24'
        name: '<<namePrefix>>-az-subnet-x-001'
        networkSecurityGroupId: resourceGroupResources.outputs.networkSecurityGroupResourceId
        roleAssignments: [
          {
            principalIds: [
              resourceGroupResources.outputs.managedIdentityPrincipalId
            ]
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        routeTableId: resourceGroupResources.outputs.routeTableResourceId
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
      }
      {
        addressPrefix: '10.0.3.0/24'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
        name: '<<namePrefix>>-az-subnet-x-002'
      }
      {
        addressPrefix: '10.0.6.0/24'
        name: '<<namePrefix>>-az-subnet-x-003'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
  }
}
