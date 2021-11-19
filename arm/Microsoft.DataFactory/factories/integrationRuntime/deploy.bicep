@description('Required. The name of the Azure Factory')
param dataFactoryName string

@description('Required. The name of the Integration Runtime')
param name string

@description('Required. The name of the Managed Virtual Network')
param managedVirtualNetworkName string

@description('Required. Managed integration runtime type properties.')
param typeProperties object

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource integrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: '${dataFactoryName}/${name}'
  properties: {
    type: 'Managed'
    managedVirtualNetwork: {
      referenceName: managedVirtualNetworkName
      type: 'ManagedVirtualNetworkReference'
    }
    typeProperties: typeProperties
  }
}

@description('The name of the Resource Group the Integration Runtime was created in.')
output integrationRuntimeResourceGroup string = resourceGroup().name

@description('The name of the Resource Group the Integration Runtime was created in.')
output integrationRuntimeName string = integrationRuntime.name

@description('The name of the Resource Group the Integration Runtime was created in.')
output integrationRuntimeId string = integrationRuntime.id
