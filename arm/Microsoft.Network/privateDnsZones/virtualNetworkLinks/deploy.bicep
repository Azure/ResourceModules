@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Optional. The name of the virtual network link.')
param name string = last(split(virtualNetworkResourceId, '/'))

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?')
param registrationEnabled bool = false

@description('Required. Link to another virtual network resource ID.')
param virtualNetworkResourceId string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' existing = {
  name: privateDnsZoneName
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: name
  parent: privateDnsZone
  location: location
  tags: tags
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: virtualNetworkResourceId
    }
  }
}

@description('The name of the deployed virtual network link')
output virtualNetworkLinkName string = virtualNetworkLink.name

@description('The resource ID of the deployed virtual network link')
output virtualNetworkLinkResourceId string = virtualNetworkLink.id

@description('The resource group of the deployed virtual network link')
output virtualNetworkLinkResourceGroup string = resourceGroup().name
