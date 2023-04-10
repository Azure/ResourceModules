@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the SQL database .')
param name string

@description('Optional. Array of containers to deploy in the SQL database.')
param containers array = []

@description('Optional. Request units per second.')
param throughput int = 400

@description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. If value is set to 0, then the property will be set to null.')
param autoscaleSettingsMaxThroughput int = 0

@description('Optional. Tags of the SQL database resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: databaseAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  name: name
  parent: databaseAccount
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' }) ? null : {
      throughput: throughput
      autoscaleSettings: autoscaleSettingsMaxThroughput != 0 ? {
        maxThroughput: autoscaleSettingsMaxThroughput
      } : null
    }
  }
}

module container 'containers/deploy.bicep' = [for container in containers: {
  name: '${uniqueString(deployment().name, sqlDatabase.name)}-sqldb-${container.name}'
  params: {
    databaseAccountName: databaseAccountName
    sqlDatabaseName: name
    name: container.name
    analyticalStorageTtl: contains(container, 'analyticalStorageTtl') ? container.analyticalStorageTtl : 0
    autoscaleSettingsMaxThroughput: contains(container, 'autoscaleSettingsMaxThroughput') ? container.autoscaleSettingsMaxThroughput : 0
    conflictResolutionPolicy: contains(container, 'conflictResolutionPolicy') ? container.conflictResolutionPolicy : {}
    defaultTtl: contains(container, 'defaultTtl') ? container.defaultTtl : -1
    indexingPolicy: contains(container, 'indexingPolicy') ? container.indexingPolicy : {}
    kind: contains(container, 'kind') ? container.kind : 'Hash'
    paths: contains(container, 'paths') ? container.paths : []
    throughput: contains(container, 'throughput') ? container.throughput : 400
    uniqueKeyPolicyKeys: contains(container, 'uniqueKeyPolicyKeys') ? container.uniqueKeyPolicyKeys : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the SQL database.')
output name string = sqlDatabase.name

@description('The resource ID of the SQL database.')
output resourceId string = sqlDatabase.id

@description('The name of the resource group the SQL database was created in.')
output resourceGroupName string = resourceGroup().name
