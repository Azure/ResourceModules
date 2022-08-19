targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = 'ms.network.connections-${serviceShort}-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment .Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'ncvtv'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
    primaryPublicIPName: 'dep-<<namePrefix>>-pip-${serviceShort}-1'
    primaryVirtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}-1'
    primaryVirtualNetworkGateway: 'dep-<<namePrefix>>-vpn-gw-${serviceShort}-1'
    secondaryPublicIPName: 'dep-<<namePrefix>>-pip-${serviceShort}-2'
    secondaryVirtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}-2'
    secondaryVirtualNetworkGateway: 'dep-<<namePrefix>>-vpn-gw-${serviceShort}-2'
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
    virtualNetworkGateway1: {
      id: resourceGroupResources.outputs.primaryVNETGatewayResourceID
    }
    enableBgp: false
    lock: 'CanNotDelete'
    virtualNetworkGateway2: {
      id: resourceGroupResources.outputs.secondaryVNETGatewayResourceID
    }
    virtualNetworkGatewayConnectionType: 'Vnet2Vnet'
    vpnSharedKey: password
  }
}
