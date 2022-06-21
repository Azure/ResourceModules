@description('Required. Name of the Gremlin database.')
param name string

@description('Optional. Tags of the Gremlin database resource.')
param tags object = {}

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Conditional. The name of the parent Gremlin database. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Array of graphs to deploy in the SQL database.')
param graphs array = []

@description('Optional. Represents maximum throughput, the resource can scale up to.')
param maxThroughput int = 0

@description('Optional. Request Units per second. For example, "throughput": 10000.')
param throughput int = 0

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = false

var enableReferencedModulesTelemetry = false

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-02-15-preview' existing = {
  name: databaseAccountName
}

resource gremlinDatabase 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases@2022-02-15-preview' = {
  name: name
  tags: tags
  parent: databaseAccount
  identity: identity
  properties: {
    options: {
      autoscaleSettings: {
        maxThroughput: maxThroughput == 0 ? null : maxThroughput
      }
      throughput: throughput == 0 ? null : throughput
    }
    resource: {
      id: name
    }
  }
}

module gremlinGraphs 'graphs/deploy.bicep' = [for graph in graphs: {
  name: '${uniqueString(deployment().name, gremlinDatabase.name)}-sqldb-${graph.name}'
  params: {
    name: graph.name
    gremlinDatabaseName: name
    databaseAccountName: databaseAccountName
    kind: !empty(graph.kind) ? graph.kind : null
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    automaticIndexing: !empty(graph.automaticIndexing) ? graph.automaticIndexing : null
    indexingMode: !empty(graph.indexingMode) ? graph.indexingMode : null
    indexingPaths: !empty(graph.indexingPaths) ? graph.indexingPaths : null
    partitionKeyPaths: !empty(graph.partitionKeyPaths) ? graph.partitionKeyPaths : null
    maxThroughput: !empty(graph.maxThroughput) ? graph.maxThroughput : null
    throughput: !empty(graph.throughput) ? graph.throughput : null
    uniqueKeyPaths: !empty(graph.uniqueKeyPaths) ? graph.uniqueKeyPaths : null
  }
}]

@description('The name of the Gremlin database.')
output name string = gremlinDatabase.name

@description('The resource ID of the Gremlin database.')
output resourceId string = gremlinDatabase.id

@description('The name of the resource group the Gremlin database was created in.')
output resourceGroupName string = resourceGroup().name
