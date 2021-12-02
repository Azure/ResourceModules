@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Required. The name of the of the Product.')
param productName string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Name of the product API.')
param name string

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource service 'Microsoft.ApiManagement/service@2021-04-01-preview' existing = {
  name: apiManagementServiceName

  resource product 'products@2021-04-01-preview' existing = {
    name: productName
  }
}

resource api 'Microsoft.ApiManagement/service/products/apis@2020-06-01-preview' = {
  name: name
  parent: service::product
}

@description('The resource ID of the product API')
output apiResourceId string = api.id

@description('The name of the product API')
output apiName string = api.name

@description('The resource group the product API was deployed into')
output apiResourceGroup string = resourceGroup().name
