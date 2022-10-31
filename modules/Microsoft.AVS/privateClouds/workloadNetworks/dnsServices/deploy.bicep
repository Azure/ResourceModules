// ============== //
//   Parameters   //
// ============== //

@description('Required. NSX DNS Service identifier. Generally the same as the DNS Service\'s display name')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Default DNS zone of the DNS Service.')
param defaultDnsZone string = ''

@description('Optional. Display name of the DNS Service.')
param displayName string = ''

@description('Optional. DNS service IP of the DNS Service.')
param dnsServiceIp string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. FQDN zones of the DNS Service.')
param fqdnZones array = []

@description('Optional. DNS Service log level.')
@allowed([
  'DEBUG'
  'INFO'
  'WARNING'
  'ERROR'
  'FATAL'
])
param logLevel string = ''

@description('Optional. NSX revision number.')
param revision int = 

@description('Optional. The name of the parent workloadNetworks. Required if the template is used in a standalone deployment.')
param workloadNetworkName string = 'default'

// =============== //
//   Deployments   //
// =============== //

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

resource privateCloud 'Microsoft.AVS/privateClouds@2022-05-01' existing = {
  name: privateCloudName

    resource workloadNetwork 'workloadNetworks@2022-05-01' existing = {
      name: workloadNetworkName
    }
}

resource dnsService 'Microsoft.AVS/privateClouds/workloadNetworks/dnsServices@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    defaultDnsZone: defaultDnsZone
    displayName: displayName
    dnsServiceIp: dnsServiceIp
    fqdnZones: fqdnZones
    logLevel: logLevel
    revision: revision
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dnsService.')
output name string = dnsService.name

@description('The resource ID of the dnsService.')
output resourceId string = dnsService.id

@description('The name of the resource group the dnsService was created in.')
output resourceGroupName string = resourceGroup().name
