var databaseAccountName = 'cosmosDb01'

module fullGremlinDatabaseDeployment '../deploy.bicep' = {
  name: 'fullGremlinDatabaseDeployment'
  params: {
    name: 'db01'
    databaseAccountName: databaseAccountName
    graphs: [
      {
        name: 'graph01'
        automaticIndexing: true
        partitionKeyPaths: [
          '/address'
        ]
      }
      {
        name: 'graph02'
        automaticIndexing: true
        partitionKeyPaths: [
          '/name'
        ]
      }
    ]
    maxThroughput: 1000
    systemAssignedIdentity: true
    tags: {
      purpose: 'test'
    }
    throughput: 1000
    enableDefaultTelemetry: false
  }
}
