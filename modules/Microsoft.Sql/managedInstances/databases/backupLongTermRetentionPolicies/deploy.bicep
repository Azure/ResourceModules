@description('Required. The name of the Long Term Retention backup policy. For example "default".')
param name string

@description('Conditional. The name of the parent managed instance database. Required if the template is used in a standalone deployment.')
param databaseName string

@description('Conditional. The name of the parent managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. The week of year to take the yearly backup in an ISO 8601 format.')
param weekOfYear int = 5

@description('Optional. The weekly retention policy for an LTR backup in an ISO 8601 format.')
param weeklyRetention string = 'P1M'

@description('Optional. The monthly retention policy for an LTR backup in an ISO 8601 format.')
param monthlyRetention string = 'P1Y'

@description('Optional. The yearly retention policy for an LTR backup in an ISO 8601 format.')
param yearlyRetention string = 'P5Y'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource managedInstance 'Microsoft.Sql/managedInstances@2022-02-01-preview' existing = {
  name: managedInstanceName

  resource managedInstaceDatabase 'databases@2020-02-02-preview' existing = {
    name: databaseName
  }
}

resource backupLongTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies@2022-02-01-preview' = {
  name: name
  parent: managedInstance::managedInstaceDatabase
  properties: {
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

@description('The name of the deployed database backup long-term retention policy.')
output name string = backupLongTermRetentionPolicy.name

@description('The resource ID of the deployed database backup long-term retention policy.')
output resourceId string = backupLongTermRetentionPolicy.id

@description('The resource group of the deployed database backup long-term retention policy.')
output resourceGroupName string = resourceGroup().name
