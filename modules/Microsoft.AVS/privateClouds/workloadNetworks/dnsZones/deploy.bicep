// ============== //
//   Parameters   //
// ============== //

@description('Required. NSX DNS Zone identifier. Generally the same as the DNS Zone\'s display name')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Display name of the DNS Zone.')
param displayName string = ''

@description('Optional. DNS Server IP array of the DNS Zone.')
param dnsServerIps array = []

@description('Optional. Number of DNS Services using the DNS zone.')
param dnsServices int = 

@description('Optional. Domain names of the DNS Zone.')
param domain array = []

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. NSX revision number.')
param revision int = 

@description('Optional. Source IP of the DNS Zone.')
param sourceIp string = ''

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

resource dnsZone 'Microsoft.AVS/privateClouds/workloadNetworks/dnsZones@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    displayName: displayName
    dnsServerIps: dnsServerIps
    dnsServices: dnsServices
    domain: domain
    revision: revision
    sourceIp: sourceIp
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dnsZone.')
output name string = dnsZone.name

@description('The resource ID of the dnsZone.')
output resourceId string = dnsZone.id

@description('The name of the resource group the dnsZone was created in.')
output resourceGroupName string = resourceGroup().name
