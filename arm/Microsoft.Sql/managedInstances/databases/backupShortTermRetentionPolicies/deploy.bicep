@description('Required. The name of the Short Term Retention backup policy. For example "default".')
param name string

@description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

resource backupShortTermRetentionPolicy 'Microsoft.Sql/managedInstances/backupShortTermRetentionPolicies@2017-03-01-preview' = {
  name: name
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
