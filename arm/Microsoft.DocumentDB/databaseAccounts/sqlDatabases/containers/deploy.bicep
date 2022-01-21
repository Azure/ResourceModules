@description('Required. Name of the Database Account')
param databaseAccountName string

@description('Required. Name of the SQL Database ')
param sqlDatabaseName string

@description('Required. Name of the container.')
param name string

@description('Optional. Request Units per second')
param throughput int = 400

@description('Optional. Tags of the SQL Database resource.')
param tags object = {}

@description('Optional. List of paths using which data within the container can be partitioned')
param paths array = []

@description('Optional. Indicates the kind of algorithm used for partitioning')
@allowed([
  'Hash'
  'MultiHash'
  'Range'
])
param kind string = 'Hash'

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' existing = {
  name: databaseAccountName

  resource sqlDatabase 'sqlDatabases@2021-07-01-preview' existing = {
    name: sqlDatabaseName
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-07-01-preview' = {
  name: name
  parent: databaseAccount::sqlDatabase
  tags: tags
  properties: {
    resource: {
      id: name
      partitionKey: {
        paths: paths
        kind: kind
      }
    }
    options: {
      throughput: throughput
    }
  }
}

@description('The name of the container.')
output name string = container.name

@description('The resource ID of the container.')
output resourceId string = container.id

@description('The name of the resource group the container was created in.')
output resourceGroupName string = resourceGroup().name
