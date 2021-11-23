@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Required. The name of the of the Product.')
param productName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Name of the product api.')
param name string

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource api 'Microsoft.ApiManagement/service/products/apis@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${productName}/${name}'
}

@description('The resourceId of the product api')
output apiResourceId string = api.id

@description('The name of the product api')
output apiName string = api.name

@description('The resource group the product api was deployed into')
output apiResourceGroup string = resourceGroup().name
