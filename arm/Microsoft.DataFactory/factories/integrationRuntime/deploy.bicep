@description('Required. The name of the Azure Data Factory')
param dataFactoryName string

@description('Required. The name of the Integration Runtime')
param name string

@allowed([
  'Managed'
  'SelfHosted'
])
@description('Required. The type of Integration Runtime')
param type string

@description('Optional. The name of the Managed Virtual Network if using type "Managed" ')
param managedVirtualNetworkName string = ''

@description('Required. Integration Runtime type properties.')
param typeProperties object

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

var managedVirtualNetwork_var = {
  referenceName: type == 'Managed' ? managedVirtualNetworkName : null
  type: type == 'Managed' ? 'ManagedVirtualNetworkReference' : null
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource integrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: name
  parent: dataFactory
  properties: {
    type: type
    managedVirtualNetwork: type == 'Managed' ? managedVirtualNetwork_var : null
    typeProperties: typeProperties
  }
}

@description('The name of the Resource Group the Integration Runtime was created in.')
output integrationRuntimeResourceGroup string = resourceGroup().name

@description('The name of the Integration Runtime.')
output integrationRuntimeName string = integrationRuntime.name

@description('The resource ID of the Integration Runtime.')
output integrationRuntimeResourceId string = integrationRuntime.id
