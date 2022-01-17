@description('Required. The name of the Azure Data Factory')
param dataFactoryName string

@description('Required. The name of the Managed Virtual Network')
param name string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource managedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: name
  parent: dataFactory
  properties: {}
}

@description('The name of the Resource Group the Managed Virtual Network was created in.')
output managedVirtualNetworkResourceGroup string = resourceGroup().name

@description('The name of the Managed Virtual Network.')
output managedVirtualNetworkName string = managedVirtualNetwork.name

@description('The resource ID of the Managed Virtual Network.')
output managedVirtualNetworkResourceId string = managedVirtualNetwork.id
