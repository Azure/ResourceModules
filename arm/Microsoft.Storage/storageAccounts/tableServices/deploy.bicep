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

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties: {}
}

module tableService_tables 'tables/deploy.bicep' = [for (tableName, index) in tables: {
  name: '${deployment().name}-Storage-Table-${index}'
  params: {
    storageAccountName: storageAccountName
    name: tableName
  }
  dependsOn: [
    tableService
  ]
}]


output tableServiceName string = tableService.name


output tableServiceResourceId string = tableService.id

output tableServiceResourceGroup string = resourceGroup().name
