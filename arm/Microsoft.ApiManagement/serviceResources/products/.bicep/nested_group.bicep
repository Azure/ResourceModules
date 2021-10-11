@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Required. Product Name.')
param productName string

@description('Optional. Product\'s Group name list.')
param productGroups array

resource group 'Microsoft.ApiManagement/service/products/groups@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${productName}/${productGroups[copyIndex()]}'
  properties: {}
}
