@description('Required. The name of the SQL managed instance database.')
param name string

@description('Required. The name of the SQL managed instance.')
param managedInstanceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Collation of the managed instance database.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Conditional. If createMode is PointInTimeRestore, this value is required. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
param restorePointInTime string = ''

@description('Optional. Collation of the managed instance.')
param catalogCollation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore.')
@allowed([
  'Default'
  'RestoreExternalBackup'
  'PointInTimeRestore'
  'Recovery'
  'RestoreLongTermRetentionBackup'
])
param createMode string = 'Default'

@description('Optional. Conditional. If createMode is RestoreExternalBackup, this value is required. Specifies the uri of the storage container where backups for this restore are stored.')
param storageContainerUri string = ''

@description('Optional. Conditional. The resource identifier of the source database associated with create operation of this database.')
param sourceDatabaseId string = ''

@description('Optional. Conditional. The restorable dropped database resource ID to restore when creating this database.')
param restorableDroppedDatabaseId string = ''

@description('Optional. Conditional. If createMode is RestoreExternalBackup, this value is required. Specifies the storage container sas token.')
param storageContainerSasToken string = ''

@description('Optional. Conditional. The resource identifier of the recoverable database associated with create operation of this database.')
param recoverableDatabaseId string = ''

@description('Optional. Conditional. The name of the Long Term Retention backup to be used for restore of this managed database.')
param longTermRetentionBackupResourceId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of log analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. The configuration for the backup short term retention policy definition')
param backupShortTermRetentionPoliciesObj object = {}

@description('Optional. The configuration for the backup long term retention policy definition')
param backupLongTermRetentionPoliciesObj object = {}

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'SQLInsights'
  'QueryStoreRuntimeStatistics'
  'QueryStoreWaitStatistics'
  'Errors'
])
param logsToEnable array = [
  'SQLInsights'
  'QueryStoreRuntimeStatistics'
  'QueryStoreWaitStatistics'
  'Errors'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' existing = {
  name: managedInstanceName
}

resource database 'Microsoft.Sql/managedInstances/databases@2021-05-01-preview' = {
  name: name
  parent: managedInstance
  location: location
  tags: tags
  properties: {
    collation: empty(collation) ? null : collation
    restorePointInTime: empty(restorePointInTime) ? null : restorePointInTime
    catalogCollation: empty(catalogCollation) ? null : catalogCollation
    createMode: empty(createMode) ? null : createMode
    storageContainerUri: empty(storageContainerUri) ? null : storageContainerUri
    sourceDatabaseId: empty(sourceDatabaseId) ? null : sourceDatabaseId
    restorableDroppedDatabaseId: empty(restorableDroppedDatabaseId) ? null : restorableDroppedDatabaseId
    storageContainerSasToken: empty(storageContainerSasToken) ? null : storageContainerSasToken
    recoverableDatabaseId: empty(recoverableDatabaseId) ? null : recoverableDatabaseId
    longTermRetentionBackupResourceId: empty(longTermRetentionBackupResourceId) ? null : longTermRetentionBackupResourceId
  }
}

resource database_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${last(split(database.name, '/'))}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: database
}

resource database_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${last(split(database.name, '/'))}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(workspaceId) ? null : workspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    logs: (empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsLogs
  }
  scope: database
}

module database_backupShortTermRetentionPolicy 'backupShortTermRetentionPolicies/deploy.bicep' = if (!empty(backupShortTermRetentionPoliciesObj)) {
  name: '${deployment().name}-BackupShortTRetPol'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: last(split(database.name, '/'))
    name: backupShortTermRetentionPoliciesObj.name
    retentionDays: contains(backupShortTermRetentionPoliciesObj, 'retentionDays') ? backupShortTermRetentionPoliciesObj.retentionDays : 35
  }
}

module database_backupLongTermRetentionPolicy 'backupLongTermRetentionPolicies/deploy.bicep' = if (!empty(backupLongTermRetentionPoliciesObj)) {
  name: '${deployment().name}-BackupLongTRetPol'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: last(split(database.name, '/'))
    name: backupLongTermRetentionPoliciesObj.name
    weekOfYear: contains(backupLongTermRetentionPoliciesObj, 'weekOfYear') ? backupLongTermRetentionPoliciesObj.weekOfYear : 5
    weeklyRetention: contains(backupLongTermRetentionPoliciesObj, 'weeklyRetention') ? backupLongTermRetentionPoliciesObj.weeklyRetention : 'P1M'
    monthlyRetention: contains(backupLongTermRetentionPoliciesObj, 'monthlyRetention') ? backupLongTermRetentionPoliciesObj.monthlyRetention : 'P1Y'
    yearlyRetention: contains(backupLongTermRetentionPoliciesObj, 'yearlyRetention') ? backupLongTermRetentionPoliciesObj.yearlyRetention : 'P5Y'
  }
}

@description('The name of the deployed database')
output databaseName string = database.name

@description('The resource ID of the deployed database')
output databaseResourceId string = database.id

@description('The resource group the database was deployed into')
output databaseResourceGroup string = resourceGroup().name
