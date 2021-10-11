@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Required. Product Name.')
param productName string

@description('Optional. Product API\'s name list.')
param productApis array

resource apiManagementServiceName_productName_productApis 'Microsoft.ApiManagement/service/products/apis@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${productName}/${productApis[copyIndex()]}'
  properties: {}
}