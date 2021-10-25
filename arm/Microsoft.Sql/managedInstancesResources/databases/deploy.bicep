@description('Required. The name of the SQL managed instance database.')
param databaseName string

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

@description('Optional. Conditional. The restorable dropped database resource id to restore when creating this database.')
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

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
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

@description('Required. The name of the Long Term Retention backup policy.')
param backupLongTermRetentionPoliciesName string = 'default'

@description('Required. The weekly retention policy for an LTR backup in an ISO 8601 format.')
param weeklyRetention string = 'P1M'

@description('Required. The monthly retention policy for an LTR backup in an ISO 8601 format.')
param monthlyRetention string = 'P1Y'

@description('Required. The yearly retention policy for an LTR backup in an ISO 8601 format.')
param yearlyRetention string = 'P5Y'

@description('Required. The week of year to take the yearly backup in an ISO 8601 format.')
param weekOfYear int = 5

@description('Required. The name of the Short Term Retention backup policy.')
param backupShortTermRetentionPoliciesName string = 'Default'

@description('Required. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var diagnosticsLogs = [
  {
    category: 'SQLInsights'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'QueryStoreRuntimeStatistics'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'QueryStoreWaitStatistics'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'Errors'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedInstanceDatabase 'Microsoft.Sql/managedInstances/databases@2020-02-02-preview' = {
  name: '${managedInstanceName}/${databaseName}'
  location: location
  tags: tags
  properties: {
    collation: (empty(collation) ? json('null') : collation)
    restorePointInTime: (empty(restorePointInTime) ? json('null') : restorePointInTime)
    catalogCollation: (empty(catalogCollation) ? json('null') : catalogCollation)
    createMode: (empty(createMode) ? json('null') : createMode)
    storageContainerUri: (empty(storageContainerUri) ? json('null') : storageContainerUri)
    sourceDatabaseId: (empty(sourceDatabaseId) ? json('null') : sourceDatabaseId)
    restorableDroppedDatabaseId: (empty(restorableDroppedDatabaseId) ? json('null') : restorableDroppedDatabaseId)
    storageContainerSasToken: (empty(storageContainerSasToken) ? json('null') : storageContainerSasToken)
    recoverableDatabaseId: (empty(recoverableDatabaseId) ? json('null') : recoverableDatabaseId)
    longTermRetentionBackupResourceId: (empty(longTermRetentionBackupResourceId) ? json('null') : longTermRetentionBackupResourceId)
  }

  resource database_backupShortTermRetentionPoliciesName 'backupShortTermRetentionPolicies@2017-03-01-preview' = {
    name: backupShortTermRetentionPoliciesName
    properties: {
      retentionDays: retentionDays
    }
  }

  resource database_backupLongTermRetentionPolicies 'backupLongTermRetentionPolicies@2021-02-01-preview' = {
    name: backupLongTermRetentionPoliciesName
    properties: {
      monthlyRetention: monthlyRetention
      weeklyRetention: weeklyRetention
      weekOfYear: weekOfYear
      yearlyRetention: yearlyRetention
    }
  }
}

resource managedInstanceDatabase_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${split(managedInstanceDatabase.name, '/')[1]}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: managedInstanceDatabase
}

resource managedInstanceDatabase_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${split(managedInstanceDatabase.name, '/')[1]}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: managedInstanceDatabase
}

output managedInstanceDatabaseName string = managedInstanceDatabase.name
output managedInstanceDatabaseResourceId string = managedInstanceDatabase.id
output managedInstanceDatabaseResourceGroup string = resourceGroup().name
