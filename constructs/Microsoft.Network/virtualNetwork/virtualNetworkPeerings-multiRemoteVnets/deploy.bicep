@description('Required. The Name of the Virtual Network to add the peering to.')
param localVnetName string

@description('Optional. Optional. The list of remote networks to peering peer with, including the configuration.')
param peeringConfigurations array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

module virtualNetworkPeering '../../../../arm/Microsoft.Network/virtualNetworksResources/virtualNetworkPeerings/deploy.bicep' = [for peeringConfiguration in peeringConfigurations: {
  name: 'virtualNetworkPeering-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'
  params: {
    peeringName: contains(peeringConfiguration, 'peeringName') ? '${peeringConfiguration.peeringName}' : '${localVnetName}-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'
    localVnetName: localVnetName
    remoteVirtualNetworkId: peeringConfiguration.remoteVirtualNetworkId
    allowForwardedTraffic: contains(peeringConfiguration, 'allowForwardedTraffic') ? peeringConfiguration.allowForwardedTraffic : true
    allowGatewayTransit: contains(peeringConfiguration, 'allowGatewayTransit') ? peeringConfiguration.allowGatewayTransit : false
    allowVirtualNetworkAccess: contains(peeringConfiguration, 'allowVirtualNetworkAccess') ? peeringConfiguration.allowVirtualNetworkAccess : true
    doNotVerifyRemoteGateways: contains(peeringConfiguration, 'doNotVerifyRemoteGateways') ? peeringConfiguration.doNotVerifyRemoteGateways : true
    useRemoteGateways: contains(peeringConfiguration, 'useRemoteGateways') ? peeringConfiguration.useRemoteGateways : false
  }
}]

output virtualNetworkPeeringResourceGroup string = resourceGroup().name
output virtualNetworkPeeringNames array = [for i in range(0, length(peeringConfigurations)): virtualNetworkPeering[i].name]
output localVirtualNetworkPeeringResourceIds array = [for peeringConfiguration in peeringConfigurations: resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', localVnetName, (contains(peeringConfiguration, 'peeringName') ? peeringConfiguration.peeringName : '${localVnetName}-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'))]
