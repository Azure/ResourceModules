@description('Required. Name of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the mongodb database')
param mongodbDatabaseName string

@description('Required. Name of the collection')
param name string

@description('Optional. Name of the mongodb database')
param throughput int = 400

@description('Required. Indexes for the collection')
param indexes array

@description('Required. ShardKey for the collection')
param shardKey object

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' existing = {
  name: databaseAccountName

  resource mongodbDatabase 'mongodbDatabases@2021-07-01-preview' existing = {
    name: mongodbDatabaseName
  }
}

resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2021-07-01-preview' = {
  name: name
  parent: databaseAccount::mongodbDatabase
  properties: {
    options: {
      throughput: throughput
    }
    resource: {
      id: name
      indexes: indexes
      shardKey: shardKey
    }
  }
}

@description('The name of the mongodb database.')
output name string = collection.name

@description('The resource ID of the mongodb database.')
output resourceId string = collection.id

@description('The name of the resource group the mongodb database was created in.')
output resourceGroupName string = resourceGroup().name
