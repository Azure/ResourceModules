@description('Required. Private DNS zone name..')
param privateDnsZoneName string

@description('Required. The name of the A record.')
param name string

@description('Optional. The metadata attached to the record set.')
param metadata object = {}

@description('Optional. The list of PTR records in the record set.')
param ptrRecords array = []

@description('Optional. The TTL (time-to-live) of the records in the record set.')
param ttl int = 3600

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource ptr 'Microsoft.Network/privateDnsZones/PTR@2020-06-01' = {
  name: name
  parent: privateDnsZone
  properties: {
    metadata: metadata
    ptrRecords: ptrRecords
    ttl: ttl
  }
}

@description('The name of the deployed PTR record')
output name string = ptr.name

@description('The resource ID of the deployed PTR record')
output resourceId string = ptr.id

@description('The resource group of the deployed PTR record')
output resourceGroupName string = resourceGroup().name
