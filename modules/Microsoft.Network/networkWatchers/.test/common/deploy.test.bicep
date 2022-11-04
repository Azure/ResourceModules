targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes')
@maxLength(90)
//param resourceGroupName string = 'ms.network.networkwatchers-${serviceShort}-rg'
param resourceGroupName string = 'NetworkWatcherRG'

@description('Optional. The location to deploy resources to')
param location string = 'WestEurope'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'nnwcom'

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
    networkSecurityGroupName: 'dep-<<namePrefix>>-nsg-${serviceShort}'
    virtualMachineName: 'dep-<<namePrefix>>-vm-${serviceShort}'
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    location: location
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
    name: 'NetworkWatcher_${location}'
    connectionMonitors: [
      {
        name: 'adp-<<namePrefix>>-conmon-${serviceShort}-x-001'
        endpoints: [
          {
            name: '<<namePrefix>>-subnet-x-001(${resourceGroup.name})'
            resourceId: resourceGroupResources.outputs.virtualMachineResourceId
            type: 'AzureVM'
          }
          {
            address: 'www.office.com'
            name: 'Office Portal'
            type: 'ExternalAddress'
          }
        ]
        testConfigurations: [
          {
            httpConfiguration: {
              method: 'Get'
              port: 80
              preferHTTPS: false
              requestHeaders: []
              validStatusCodeRanges: [
                '200'
              ]
            }
            name: 'HTTP Test'
            protocol: 'Http'
            successThreshold: {
              checksFailedPercent: 5
              roundTripTimeMs: 100
            }
            testFrequencySec: 30
          }
        ]
        testGroups: [
          {
            destinations: [
              'Office Portal'
            ]
            disable: false
            name: 'TestHTTPBing'
            sources: [
              '<<namePrefix>>-subnet-x-001(${resourceGroup.name})'
            ]
            testConfigurations: [
              'HTTP Test'
            ]
          }
        ]
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
    flowLogs: [
      // {
      //   enabled: false
      //   storageId: diagnosticDependencies.outputs.storageAccountResourceId
      //   targetResourceId: resourceGroupResources.outputs.networkSecurityGroupResourceId
      // }
      {
        formatVersion: 1
        name: 'adp-<<namePrefix>>-nsg-x-apgw-flowlog'
        retentionInDays: 8
        storageId: diagnosticDependencies.outputs.storageAccountResourceId
        targetResourceId: resourceGroupResources.outputs.networkSecurityGroupResourceId
        trafficAnalyticsInterval: 10
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
  }
}
