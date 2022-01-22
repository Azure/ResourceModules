@description('Required. ID of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the SQL database ')
param name string

@description('Optional. Array of containers to deploy in the SQL database.')
param containers array = []

@description('Optional. Request units per second')
param throughput int = 400

@description('Optional. Tags of the SQL database resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' existing = {
  name: databaseAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  name: name
  parent: databaseAccount
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

module container 'containers/deploy.bicep' = [for container in containers: {
  name: '${uniqueString(deployment().name, sqlDatabase.name)}-sqldb-${container.name}'
  params: {
    databaseAccountName: databaseAccountName
    sqlDatabaseName: name
    name: container.name
    paths: container.paths
    kind: container.kind
  }
}]

@description('The name of the SQL database.')
output name string = sqlDatabase.name

@description('The resource ID of the SQL database.')
output resourceId string = sqlDatabase.id

@description('The name of the resource group the SQL database was created in.')
output resourceGroupName string = resourceGroup().name
