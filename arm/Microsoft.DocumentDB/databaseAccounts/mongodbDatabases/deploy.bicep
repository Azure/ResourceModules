@description('Required. Name of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the mongodb database')
param name string

@description('Optional. Name of the mongodb database')
param throughput int = 400

@description('Optional. Collections in the mongodb database')
param collections array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource mongodbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-07-01-preview' = {
  name: '${databaseAccountName}/${name}'
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: {
      throughput: throughput
    }
  }
}

module mongodbDatabase_collections './collections/deploy.bicep' = [for collection in collections: {
  name: '${uniqueString(deployment().name, mongodbDatabase.name)}-collection-${collection.name}'
  params: {
    databaseAccountName: databaseAccountName
    mongodbDatabaseName: name
    name: collection.name
    indexes: collection.indexes
    shardKey: collection.shardKey
  }
}]

@description('The name of the mongodb database.')
output mongodbDatabaseName string = mongodbDatabase.name

@description('The Resource Id of the mongodb database.')
output mongodbDatabaseResourceId string = mongodbDatabase.id

@description('The name of the Resource Group the mongodb database was created in.')
output mongodbDatabaseResourceGroup string = resourceGroup().name
