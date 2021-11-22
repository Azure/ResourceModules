@description('Required. The name of the Azure Data Factory')
param dataFactoryName string

@description('Required. The name of the Managed Virtual Network')
param name string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: '${dataFactoryName}/${name}'
  properties: {}
}

@description('The name of the Resource Group the Managed Virtual Network was created in.')
output managedVirtualNetworkResourceGroup string = resourceGroup().name

@description('The name of the Managed Virtual Network.')
output managedVirtualNetworkName string = managedVirtualNetwork.name

@description('The id of the Managed Virtual Network.')
output managedVirtualNetworkId string = managedVirtualNetwork.id
