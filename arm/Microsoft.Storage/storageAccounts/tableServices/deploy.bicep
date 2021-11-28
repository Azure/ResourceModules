@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the table service')
param name string = 'default'

@description('Optional. tables to create.')
param tables array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource tableServices 'tableServices@2021-04-01' = {
    name: name
    properties: {}
  }
}

module tableServices_tables 'tables/deploy.bicep' = [for (tableName, index) in tables: {
  name: '${deployment().name}-Storage-Table-${index}'
  params: {
    storageAccountName: storageAccount.name
    tableServicesName: storageAccount::tableServices.name
    name: tableName
  }
}]

@description('The name of the deployed table service')
output tableServicesName string = storageAccount::tableServices.name

@description('The resource ID of the deployed table service')
output tableServicesResourceId string = storageAccount::tableServices.id

@description('The resource group of the deployed table service')
output tableServicesResourceGroup string = resourceGroup().name
