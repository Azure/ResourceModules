@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Required. The name of the AAAA record.')
param name string

@description('Optional. The list of AAAA records in the record set.')
param aaaaRecords array = []

@description('Optional. The metadata attached to the record set.')
param metadata object = {}

@description('Optional. The TTL (time-to-live) of the records in the record set.')
param ttl int = 3600

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
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

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource AAAA 'Microsoft.Network/privateDnsZones/AAAA@2020-06-01' = {
  name: name
  parent: privateDnsZone
  properties: {
    aaaaRecords: aaaaRecords
    metadata: metadata
    ttl: ttl
  }
}

@description('The name of the deployed AAAA record')
output name string = AAAA.name

@description('The resource ID of the deployed AAAA record')
output resourceId string = AAAA.id

@description('The resource group of the deployed AAAA record')
output resourceGroupName string = resourceGroup().name
