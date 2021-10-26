@description('Required. Name of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the mongodb database')
param mongodbDatabaseName string

@description('Optional. Location for the resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

resource mongodbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-07-01-preview' = {
  name: '${databaseAccountName}/${mongodbDatabaseName}'
  tags: tags
  location: location
  properties: {
    resource: {
      id: mongodbDatabaseName
    }
  }

  resource mongodbDatabase_throughputSettings 'throughputSettings@2021-07-01-preview' = {
    name: 'default'
    location: location
    properties: {
      resource: {
        autoscaleSettings: {
          maxThroughput: 4000
        }
        throughput: 400
      }
    }
  }
}

@description('The name of the mongodb database.')
output mongodbDatabaseName string = mongodbDatabase.name

@description('The Resource Id of the mongodb database.')
output mongodbDatabaseResourceId string = mongodbDatabase.id

@description('The name of the Resource Group the mongodb database was created in.')
output mongodbDatabaseResourceGroup string = resourceGroup().name
