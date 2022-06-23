var databaseAccountName = 'cosmosDb01'

module minimalGremlinDatabaseDeployment '../deploy.bicep' = {
  name: 'minimalGremlinDatabaseDeployment'
  params: {
    name: 'db01'
    databaseAccountName: databaseAccountName
  }
}
