@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. The name of the parent database.')
param databaseName string

@description('Optional. Differential backup interval in hours.')
param diffBackupIntervalInHours int = 24

@description('Optional. Poin-in-time retention in days.')
param retentionDays int = 7

resource server 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2022-05-01-preview' existing = {
  name: databaseName
  parent: server
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2022-05-01-preview' = {
  name: 'default'
  parent: database
  properties: {
    diffBackupIntervalInHours: diffBackupIntervalInHours
    retentionDays: retentionDays
  }
}

@description('The resource group of the deployed azure sql backup policy.')
output resourceGroupName string = resourceGroup().name
