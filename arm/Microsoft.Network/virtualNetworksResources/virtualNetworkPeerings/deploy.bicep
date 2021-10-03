@description('Required. The Name of the Virtual Network to add the peering to.')
param localVnetName string

@description('Optional. Optional. The list of remote networks to peering peer with, including the configuration.')
param peeringConfigurations array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = [for peeringConfiguration in peeringConfigurations: {
  name: contains(peeringConfiguration, 'peeringName') ? '${localVnetName}/${peeringConfiguration.peeringName}' : '${localVnetName}/${localVnetName}-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'
  properties: {
    allowVirtualNetworkAccess: contains(peeringConfiguration, 'allowVirtualNetworkAccess') ? peeringConfiguration.allowVirtualNetworkAccess : true
    allowForwardedTraffic: contains(peeringConfiguration, 'allowForwardedTraffic') ? peeringConfiguration.allowForwardedTraffic : true
    allowGatewayTransit: contains(peeringConfiguration, 'allowGatewayTransit') ? peeringConfiguration.allowGatewayTransit : false
    useRemoteGateways: contains(peeringConfiguration, 'useRemoteGateways') ? peeringConfiguration.useRemoteGateways : true
    remoteVirtualNetwork: {
      id: peeringConfiguration.remoteVirtualNetworkId
    }
  }
}]

output virtualNetworkPeeringResourceGroup string = resourceGroup().name
output virtualNetworkPeeringNames array = [for i in range(0, length(peeringConfigurations)): virtualNetworkPeering[i].name]
output localVirtualNetworkPeeringResourceIds array = [for peeringConfiguration in peeringConfigurations: resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', localVnetName, (contains(peeringConfiguration, 'peeringName') ? peeringConfiguration.peeringName : '${localVnetName}-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}')) ]
output remoteVirtualNetworkPeeringResourceIds array = [for item in peeringConfigurations: resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', localVnetName, '${localVnetName}-${last(split(item.remoteVirtualNetworkId, '/'))}')]
