@description('Optional. Required if not using remoteVirtualNetworksProperties. The Name of the virtual network peering resource.')
param peeringName string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The Name of the Virtual Network to add the peering to.')
param localVnetName string

@description('Optional. Required if not using remoteVirtualNetworksProperties. The Resource Id of the remote virtual network. The remove virtual network can be in the same or different region.')
param remoteVirtualNetworkId string = ''

@description('Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space.')
param allowVirtualNetworkAccess bool = true

@description('Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network.')
param allowForwardedTraffic bool = true

@description('Optional. If gateway links can be used in remote virtual networking to link to this virtual network.')
param allowGatewayTransit bool = false

@description('Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway.')
param useRemoteGateways bool = true

@description('Optional. Required when not using remoteVirtualNetworkId (i.e. Single Peering deployment). Array containing multiple objects for different VNETs to peer with. Format: Object of remoteVirtualNetwork:Id (string-required), allowVirtualNetworkAccess (bool-optional-default-true), allowForwardedTraffic (bool-optional-default-true), allowGatewayTransit (bool-optional-default-false), useRemoteGateways (bool-optional-default-true).')
param remoteVirtualNetworksProperties array = []

var localToRemotePeeringName_var = '${localVnetName}/${(empty(peeringName) ? 'tempValue' : peeringName)}'
var peeringResourceIdsOutput = [for item in remoteVirtualNetworksProperties: [
  resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', localVnetName, '${localVnetName}-${last(split(item.remoteVirtualNetwork.Id, '/'))}')
]]

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource localToRemotePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = if (!empty(remoteVirtualNetworkId)) {
  name: localToRemotePeeringName_var
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVirtualNetworkId
    }
  }
}

resource remoteToLocalPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = [for item in remoteVirtualNetworksProperties: if (!empty(remoteVirtualNetworksProperties)) {
  name: '${localVnetName}/${localVnetName}-${last(split(item.remoteVirtualNetwork.id, '/'))}'
  properties: item
}]

output virtualNetworkPeeringResourceGroup string = resourceGroup().name
output virtualNetworkPeeringName string = peeringName
output virtualNetworkPeeringResourceId string = resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', localVnetName, peeringName)
output virtualNetworkPeeringResourceIds array = peeringResourceIdsOutput
