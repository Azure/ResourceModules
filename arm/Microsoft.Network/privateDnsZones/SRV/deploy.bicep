@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Required. The name of the SRV record.')
param name string

@description('Optional. The metadata attached to the record set.')
param metadata object = {}

@description('Optional. The list of SRV records in the record set.')
param srvRecords array = []

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

resource SRV 'Microsoft.Network/privateDnsZones/SRV@2020-06-01' = {
  name: name
  parent: privateDnsZone
  properties: {
    metadata: metadata
    srvRecords: srvRecords
    ttl: ttl
  }
}

@description('The name of the deployed SRV record')
output name string = SRV.name

@description('The resource ID of the deployed SRV record')
output resourceId string = SRV.id

@description('The resource group of the deployed SRV record')
output resourceGroupName string = resourceGroup().name
