@description('Required. The name of the Azure Data Factory')
param dataFactoryName string

@description('Required. The name of the Managed Virtual Network')
param name string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
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
output resourceGroupName string = resourceGroup().name

@description('The name of the Managed Virtual Network.')
output name string = managedVirtualNetwork.name

@description('The resource ID of the Managed Virtual Network.')
output resourceId string = managedVirtualNetwork.id
