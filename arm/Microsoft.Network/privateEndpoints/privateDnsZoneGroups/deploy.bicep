@description('Required. The name of the private endpoint')
param privateEndpointName string

@description('Required. List of private DNS Ids')
param privateDNSIds array

@description('The name of the private DNS Zone Group')
param privateDnsZoneGroupName string = 'default'

var privateDnsZoneConfigs = [for privateDNSId in privateDNSIds: {
  name: privateEndpointName
  properties: {
    privateDnsZoneId: privateDNSId
  }
}]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-03-01' existing = {
  name: privateEndpointName
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = {
  name: privateDnsZoneGroupName
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: privateDnsZoneConfigs
  }
}

@description('The name of the private endpoint DNS zone group')
output privateDnsZoneGroupName string = privateDnsZoneGroup.name

@description('The resource ID of the private endpoint DNS zone group')
output privateDnsZoneGroupResourceId string = privateDnsZoneGroup.id

@description('The resource group the private endpoint DNS zone group was deployed into')
output privateDnsZoneGroupResourceGroup string = resourceGroup().name
