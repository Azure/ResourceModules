@description('Required. The Name of the Virtual Network to add the peering to.')
param localVnetName string

@description('Optional. Optional. The list of remote networks to peering peer with, including the configuration.')
param peeringConfigurations array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module virtualNetworkPeering '../../../../modules/network/virtual-network/virtual-network-peering/main.bicep' = [for peeringConfiguration in peeringConfigurations: {
  name: 'virtualNetworkPeering-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'
  params: {
    name: contains(peeringConfiguration, 'peeringName') ? '${peeringConfiguration.peeringName}' : '${localVnetName}-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'
    localVnetName: localVnetName
    remoteVirtualNetworkId: peeringConfiguration.remoteVirtualNetworkId
    allowForwardedTraffic: contains(peeringConfiguration, 'allowForwardedTraffic') ? peeringConfiguration.allowForwardedTraffic : true
    allowGatewayTransit: contains(peeringConfiguration, 'allowGatewayTransit') ? peeringConfiguration.allowGatewayTransit : false
    allowVirtualNetworkAccess: contains(peeringConfiguration, 'allowVirtualNetworkAccess') ? peeringConfiguration.allowVirtualNetworkAccess : true
    doNotVerifyRemoteGateways: contains(peeringConfiguration, 'doNotVerifyRemoteGateways') ? peeringConfiguration.doNotVerifyRemoteGateways : true
    useRemoteGateways: contains(peeringConfiguration, 'useRemoteGateways') ? peeringConfiguration.useRemoteGateways : false
  }
}]

@description('The names of the deployed virtual network peerings.')
output virtualNetworkPeeringNames array = [for i in range(0, length(peeringConfigurations)): virtualNetworkPeering[i].name]
@description('The resource IDs of the deployed virtual network peerings.')
output localVirtualNetworkPeeringResourceIds array = [for peeringConfiguration in peeringConfigurations: resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', localVnetName, (contains(peeringConfiguration, 'peeringName') ? peeringConfiguration.peeringName : '${localVnetName}-${last(split(peeringConfiguration.remoteVirtualNetworkId, '/'))}'))]
@description('The resource group of the deployed virtual network peerings.')
output virtualNetworkPeeringResourceGroup string = resourceGroup().name
