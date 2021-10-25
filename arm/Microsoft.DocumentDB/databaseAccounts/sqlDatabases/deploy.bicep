@description('Required. Name of the SQL Database ')
param sqlDatabaseName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the SQL Database resource.')
param tags object = {}

@description('Required. Id of the Cosmos DB database account.')
param databaseAccountName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  name: '${databaseAccountName}/${sqlDatabaseName}'
  location: location
  tags: tags
  properties: {
    resource: {
      id: sqlDatabaseName
    }
  }
}

@description('The name of the sql database.')
output sqlDatabaseName string = sqlDatabase.name

@description('The Resource Id of the sql database.')
output sqlDatabaseResourceId string = sqlDatabase.id

@description('The name of the Resource Group the sql database was created in.')
output sqlDatabaseResourceGroup string = resourceGroup().name
