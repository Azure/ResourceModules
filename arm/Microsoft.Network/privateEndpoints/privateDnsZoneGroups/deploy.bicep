@description('Required. The name of the private endpoint')
param privateEndpointName string

@description('Required. List of private DNS Ids')
param privateDNSIds array

var privateDnsZoneConfigs = [for privateDNSId in privateDNSIds: {
  name: privateEndpointName
  properties: {
    privateDnsZoneId: privateDNSId
  }
}]

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = {
  name: '${privateEndpointName}/default'
  properties: {
    privateDnsZoneConfigs: privateDnsZoneConfigs
  }
}

@description('The name of the private endpoint DNS zone group')
output privateDnsZoneGroupName string = privateDnsZoneGroup.name

@description('The resourceId of the private endpoint DNS zone group')
output privateDnsZoneGroupResourceId string = privateDnsZoneGroup.id

@description('The resource group the private endpoint DNS zone group was deployed into')
output privateDnsZoneGroupResourceGroup string = resourceGroup().name
