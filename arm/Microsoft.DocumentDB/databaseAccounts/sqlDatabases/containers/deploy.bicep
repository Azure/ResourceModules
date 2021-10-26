@description('Required. Name of the SQL Database ')
param sqlDatabaseName string

@description('Required. Name of the container.')
param containerName string

@description('Optional. Request Units per second')
param throughput int = 400

@description('Optional. Tags of the SQL Database resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-07-01-preview' = {
  name: '${sqlDatabaseName}/${containerName}'
  tags: tags
  properties: {
    resource: {
      id: containerName
    }
    options: {
      throughput: throughput
    }
  }
}

@description('The name of the container.')
output containerName string = container.name

@description('The Resource Id of the container.')
output containerResourceId string = container.id

@description('The name of the Resource Group the container was created in.')
output containerResourceGroup string = resourceGroup().name
