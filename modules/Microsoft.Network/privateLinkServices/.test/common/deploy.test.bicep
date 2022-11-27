targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.privatelinkservices-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nplscom'

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
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    loadBalancerName: 'dep-<<namePrefix>>-lb-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
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
    lock: 'CanNotDelete'
    ipConfigurations: [
      {
        name: '${serviceShort}01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceGroupResources.outputs.subnetResourceId
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: resourceGroupResources.outputs.loadBalancerFrontendIpConfigurationResourceId
      }
    ]
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    visibility: {
      subscriptions: [
        subscription().subscriptionId
      ]
    }
    enableProxyProtocol: true
    fqdns: [
      '${serviceShort}.plsfqdn01.azure.privatelinkservice'
      '${serviceShort}.plsfqdn02.azure.privatelinkservice'
    ]
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
  }
}
