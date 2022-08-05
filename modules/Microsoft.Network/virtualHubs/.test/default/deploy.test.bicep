targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name prefix to inject into all resource names')
param namePrefix string = '<<namePrefix>>'

@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = '${serviceShort}-ms.network-virtualHub-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vhpar'

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
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}-001'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}-001'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-virtualHub-${serviceShort}'
  params: {
    name: '${namePrefix}-${serviceShort}-001'
    lock: 'CanNotDelete'
    addressPrefix: '10.1.0.0/16'
    virtualWanId: resourceGroupResources.outputs.virtualWWANResourceId
    hubRouteTables: [
      {
        name: 'routeTable1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkId: resourceGroupResources.outputs.virtualNetworkResourceId
        routingConfiguration: {
          associatedRouteTable: {
            id: '${resourceGroup.id}/providers/Microsoft.Network/virtualHubs/${namePrefix}-${serviceShort}-001/hubRouteTables/routeTable1'
          }
          propagatedRouteTables: {
            ids: [
              {
                id: '${resourceGroup.id}/providers/Microsoft.Network/virtualHubs/${namePrefix}-${serviceShort}-001/hubRouteTables/routeTable1'
              }
            ]
            labels: [
              'none'
            ]
          }
        }
      }
    ]
  }
}
