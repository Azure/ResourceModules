var databaseAccountName = 'cosmosDb01'
var gremlinDatabaseName = 'db01'

module minimalGremlinDatabaseDeployment '../deploy.bicep' = {
  name: 'minimalGremlinDatabaseDeployment'
  params: {
    name: 'graph03'
    databaseAccountName: databaseAccountName
    gremlinDatabaseName: gremlinDatabaseName
  }
}
