@description('Required. Name of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the mongodb database')
param mongodbDatabaseName string

@description('Required. Name of the collection')
param collectionName string

@description('Optional. Name of the mongodb database')
param throughput int = 400

@description('Optional. Name of the mongodb database')
param analyticalStorageTtl int = 0

@description('Required. Indexes for the collection')
param indexes array

@description('Required. ShardKey for the collection')
param shardKey object

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2021-07-01-preview' = {
  name: '${databaseAccountName}/${mongodbDatabaseName}/${collectionName}'
  properties: {
    options: {
      throughput: throughput
    }
    resource: {
      analyticalStorageTtl: (analyticalStorageTtl != 0) ? analyticalStorageTtl : json('null')
      id: collectionName
      indexes: indexes
      shardKey: shardKey
    }
  }
}

@description('The name of the mongodb database.')
output collectionName string = collection.name

@description('The Resource Id of the mongodb database.')
output collectionResourceId string = collection.id

@description('The name of the Resource Group the mongodb database was created in.')
output collectionResourceGroup string = resourceGroup().name
