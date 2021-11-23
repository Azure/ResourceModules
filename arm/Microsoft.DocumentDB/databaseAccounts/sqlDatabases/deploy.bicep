@description('Required. ID of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the SQL Database ')
param name string

@description('Optional. Array of containers to deploy in the SQL database.')
param containers array = []

@description('Optional. Request Units per second')
param throughput int = 400

@description('Optional. Tags of the SQL Database resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
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

@description('The name of the sql database.')
output sqlDatabaseName string = sqlDatabase.name

@description('The Resource ID of the sql database.')
output sqlDatabaseResourceId string = sqlDatabase.id

@description('The name of the Resource Group the sql database was created in.')
output sqlDatabaseResourceGroup string = resourceGroup().name
