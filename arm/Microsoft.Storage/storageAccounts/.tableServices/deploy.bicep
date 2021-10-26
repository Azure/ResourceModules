@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Sets the CORS rules. You can include up to five CorsRule elements in the request.')
param cors object = {}

@description('Optional. tables to create.')
param tables array = []

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties: {
    cors: cors
  }
}

module tableService_tables '.tables/deploy.bicep' = [for (table, index) in tables: {
  name: '${uniqueString(deployment().name)}-Storage-Table-${index}'
  params: {
    storageAccountName: storageAccountName
    name: table.name
  }
}]

@description('The name of the deployed table service')
output tableServiceName string = tableService.name

@description('The id of the deployed table service')
output tableServiceResourceId string = tableService.id

@description('The resource group of the deployed table service')
output tableServiceResourceGroup string = resourceGroup().name
