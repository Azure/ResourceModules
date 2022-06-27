@description('Conditional. The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent mongodb database. Required if the template is used in a standalone deployment.')
param mongodbDatabaseName string

@description('Required. Name of the collection.')
param name string

@description('Optional. Name of the mongodb database.')
param throughput int = 400

@description('Required. Indexes for the collection.')
param indexes array

@description('Required. ShardKey for the collection.')
param shardKey object

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
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
      throughput: contains(databaseAccount.properties.capabilities, 'EnableServerless') ? null : throughput
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
