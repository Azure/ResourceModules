@description('Required. The name of the Short Term Retention backup policy. For example "default".')
param name string

@description('Conditional. The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment.')
param databaseName string

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' existing = {
  name: managedInstanceName

  resource managedInstaceDatabase 'databases@2020-02-02-preview' existing = {
    name: databaseName
  }
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies@2017-03-01-preview' = {
  name: name
  parent: managedInstance::managedInstaceDatabase
  properties: {
    retentionDays: retentionDays
  }
}

@description('The name of the deployed database backup short-term retention policy.')
output name string = backupShortTermRetentionPolicy.name

@description('The resource ID of the deployed database backup short-term retention policy.')
output resourceId string = backupShortTermRetentionPolicy.id

@description('The resource group of the deployed database backup short-term retention policy.')
output resourceGroupName string = resourceGroup().name
