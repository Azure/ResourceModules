@description('Required. The name of the Long Term Retention backup policy. For example "default".')
param name string

@description('Name of the resource.')
param managedInstanceName string

@description('Optional. The week of year to take the yearly backup in an ISO 8601 format.')
param weekOfYear int = 5

@description('Optional. The weekly retention policy for an LTR backup in an ISO 8601 format.')
param weeklyRetention string = 'P1M'

@description('Optional. The monthly retention policy for an LTR backup in an ISO 8601 format.')
param monthlyRetention string = 'P1Y'

@description('Optional. The yearly retention policy for an LTR backup in an ISO 8601 format.')
param yearlyRetention string = 'P5Y'

resource backupLongTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies@2021-02-01-preview' = {
  name: '${managedInstanceName}/${name}'
  properties: {
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

@description('The name of the deployed database backup long-term retention policy')
output backupLongTermRetentionPolicyName string = backupLongTermRetentionPolicy.name

@description('The resourceId of the deployed database backup long-term retention policy')
output backupLongTermRetentionPolicyResourceId string = backupLongTermRetentionPolicy.id

@description('The resource group of the deployed database backup long-term retention policy')
output backupLongTermRetentionPolicyResourceGroup string = resourceGroup().name
