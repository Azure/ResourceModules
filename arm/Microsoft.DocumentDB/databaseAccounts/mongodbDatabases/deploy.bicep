@description('Required. Name of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the mongodb database')
param mongodbDatabaseName string

@description('Optional. Location for the resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The type of identity used for the mongodb database. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' (default) will remove any identities from the mongodb database.')
@allowed([
  'None'
  'SystemAssigned'
  'SystemAssigned, UserAssigned'
  'UserAssigned'
])
param managedServiceIdentity string = 'None'

@description('Optional. Mandatory if \'managedServiceIdentity\' contains UserAssigned. The list of user identities associated with the mongodb database.')
param userAssignedIdentities object = {}

var identity = {
  type: managedServiceIdentity
  userAssignedIdentities: (empty(userAssignedIdentities) ? json('null') : userAssignedIdentities)
}

resource mongodbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-07-01-preview' = {
  name: '${databaseAccountName}/${mongodbDatabaseName}'
  tags: tags
  location: location
  identity: identity
  properties: {
    resource: {
      id: mongodbDatabaseName
    }
  }
}

@description('The name of the mongodb database.')
output mongodbDatabaseName string = mongodbDatabase.name

@description('The Resource Id of the mongodb database.')
output mongodbDatabaseResourceId string = mongodbDatabase.id

@description('The name of the Resource Group the mongodb database was created in.')
output mongodbDatabaseResourceGroup string = resourceGroup().name
