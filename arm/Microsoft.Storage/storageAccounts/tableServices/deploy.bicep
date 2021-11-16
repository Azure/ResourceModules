@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. tables to create.')
param tables array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource tableService 'tableServices@2021-04-01' = {
    name: 'default'
    properties: {}
  }
}

module tableService_tables 'tables/deploy.bicep' = [for (tableName, index) in tables: {
  name: '${deployment().name}-Storage-Table-${index}'
  params: {
    storageAccountName: storageAccountName
    name: tableName
  }
  dependsOn: [
    storageAccount::tableService
  ]
}]

@description('The name of the deployed table service')
output tableServiceName string = storageAccount::tableService.name

@description('The id of the deployed table service')
output tableServiceResourceId string = storageAccount::tableService.id

@description('The resource group of the deployed table service')
output tableServiceResourceGroup string = resourceGroup().name
