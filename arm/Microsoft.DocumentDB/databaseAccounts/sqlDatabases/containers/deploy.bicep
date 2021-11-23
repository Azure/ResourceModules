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

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-07-01-preview' = {
  name: '${databaseAccountName}/${sqlDatabaseName}/${name}'
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
output containerName string = container.name

@description('The Resource ID of the container.')
output containerResourceId string = container.id

@description('The name of the Resource Group the container was created in.')
output containerResourceGroup string = resourceGroup().name
