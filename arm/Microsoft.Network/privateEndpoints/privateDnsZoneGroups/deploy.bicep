@description('Required. The name of the private endpoint')
param privateEndpointName string

@description('Required. List of private DNS resource IDs')
param privateDNSResourceIds array

@description('Optional. The name of the private DNS Zone Group')
param name string = 'default'

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

var privateDnsZoneConfigs = [for privateDNSResourceId in privateDNSResourceIds: {
  name: privateEndpointName
  properties: {
    privateDnsZoneId: privateDNSResourceId
  }
}]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' existing = {
  name: privateEndpointName
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: name
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: privateDnsZoneConfigs
  }
}

@description('The name of the private endpoint DNS zone group')
output name string = privateDnsZoneGroup.name

@description('The resource ID of the private endpoint DNS zone group')
output resourceId string = privateDnsZoneGroup.id

@description('The resource group the private endpoint DNS zone group was deployed into')
output resourceGroupName string = resourceGroup().name
