@description('Required. Name of the SQL Database ')
param sqlDatabaseName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the SQL Database resource.')
param tags object = {}

@description('Required. Id of the Cosmos DB database account.')
param accountId object = {}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  name: sqlDatabaseName
  location: location
  tags: tags
  properties: {
    resource: {
      id: sqlDatabaseName
    }
  }
}
