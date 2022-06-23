var databaseAccountName = 'cosmosDb01'
var gremlinDatabaseName = 'db01'

module fullGremlinDatabaseDeployment '../deploy.bicep' = {
  name: 'fullGremlinDatabaseDeployment'
  params: {
    name: 'graph03'
    databaseAccountName: databaseAccountName
    gremlinDatabaseName: gremlinDatabaseName
    automaticIndexing: true
    maxThroughput: 1000
    partitionKeyPaths: [
      '/name'
    ]
    tags: {
      purpose: 'test'
    }
    throughput: 1000
    enableDefaultTelemetry: false
  }
}
