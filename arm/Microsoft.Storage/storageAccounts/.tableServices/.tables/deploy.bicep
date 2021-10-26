@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Required. Name of the table.')
param name string

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2019-06-01' = {
  name: '${storageAccountName}/default/${name}'
}

@description('The name of the deployed file share service')
output tableServiceName string = table.name

@description('The id of the deployed file share service')
output tableServiceResourceId string = table.id

@description('The resource group of the deployed file share service')
output tableServiceResourceGroup string = resourceGroup().name
