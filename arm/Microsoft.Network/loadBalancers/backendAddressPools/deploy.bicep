@description('Required. The name of the parent load balancer')
param loadBalancerName string

@description('Required. The name of the backend address pool')
param name string

@description('Optional. An array of backend addresses.')
param loadBalancerBackendAddresses array = []

@description('Optional. An array of gateway load balancer tunnel interfaces.')
param tunnelInterfaces array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-05-01' existing = {
  name: loadBalancerName
}

resource backendAddressPool 'Microsoft.Network/loadBalancers/backendAddressPools@2021-05-01' = {
  name: name
  properties: {
    loadBalancerBackendAddresses: loadBalancerBackendAddresses
    tunnelInterfaces: tunnelInterfaces
  }
  parent: loadBalancer
}

@description('The name of the backend address pool')
output name string = backendAddressPool.name

@description('The resource ID of the backend address pool')
output resourceId string = backendAddressPool.id

@description('The resource group the backend address pool was deployed into')
output resourceGroupName string = resourceGroup().name
