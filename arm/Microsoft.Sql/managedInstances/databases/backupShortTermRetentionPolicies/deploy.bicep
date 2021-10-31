@description('Required. The name of the Short Term Retention backup policy. For example "default".')
param name string

@description('Required. The name of the SQL managed instance database')
param databaseName string

@description('Required. Name of the SQL managed instance.')
param managedInstanceName string

@description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

resource backupShortTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies@2017-03-01-preview' = {
  name: '${managedInstanceName}/${databaseName}/${name}'
  properties: {
    retentionDays: retentionDays
  }
}

@description('The name of the deployed database backup short-term retention policy')
output backupShortTermRetentionPolicyName string = backupShortTermRetentionPolicy.name

@description('The resourceId of the deployed database backup short-term retention policy')
output backupShortTermRetentionPolicyResourceId string = backupShortTermRetentionPolicy.id

@description('The resource group of the deployed database backup short-term retention policy')
output backupShortTermRetentionPolicyResourceGroup string = resourceGroup().name
