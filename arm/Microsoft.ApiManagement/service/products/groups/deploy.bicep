@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Required. The name of the of the Product.')
param productName string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Name of the product group.')
param name string

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource product 'products@2021-04-01-preview' existing = {
    name: productName
  }
}

resource group 'Microsoft.ApiManagement/service/products/groups@2021-08-01' = {
  name: name
  parent: service::product
}

@description('The resource ID of the product group')
output resourceId string = group.id

@description('The name of the product group')
output name string = group.name

@description('The resource group the product group was deployed into')
output resourceGroupName string = resourceGroup().name
