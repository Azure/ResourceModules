@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Required. The name of the MX record.')
param name string

@description('Optional. The metadata attached to the record set.')
param metadata object = {}

@description('Optional. The list of MX records in the record set.')
param mxRecords array = []

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

resource MX 'Microsoft.Network/privateDnsZones/MX@2020-06-01' = {
  name: name
  parent: privateDnsZone
  properties: {
    metadata: metadata
    mxRecords: mxRecords
    ttl: ttl
  }
}

@description('The name of the deployed MX record')
output name string = MX.name

@description('The resource ID of the deployed MX record')
output resourceId string = MX.id

@description('The resource group of the deployed MX record')
output resourceGroupName string = resourceGroup().name
