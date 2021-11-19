@description('Required. The name of the Azure Factory')
param dataFactoryName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: '${dataFactoryName}/default'
  properties: {}
}

@description('The name of the Resource Group the Managed Virtual Network was created in.')
output managedVirtualNetworkResourceGroup string = resourceGroup().name
