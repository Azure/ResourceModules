@description('Optional. The collation of the database.')
param collation string

@description('Required. The name of the database.')
param name string

@description('Optional. The tier or edition of the particular SKU.')
param tier string

@description('Required. The name of the SKU.')
param skuName string

@description('Optional. The max size of the database expressed in bytes.')
param maxSizeBytes int

@description('Required. The Name of SQL Server')
param serverName string

@description('Optional. The name of the sample schema to apply when creating this database.')
param sampleName string = ''

@description('Optional. Whether or not this database is zone redundant.')
param zoneRedundant bool = false

@description('Optional. The license type to apply for this database.')
param licenseType string = ''

@description('Optional. The state of read-only routing.')
@allowed([
  'Enabled'
  'Disabled'
])
param readScale string = 'Disabled'

@description('Optional. The number of readonly secondary replicas associated with the database.')
param highAvailabilityReplicaCount int = 0

@description('Optional. Minimal capacity that database will always have allocated.')
param minCapacity string = ''

@description('Optional. Time in minutes after which database is automatically paused.')
param autoPauseDelay string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'SQLInsights'
  'AutomaticTuning'
  'QueryStoreRuntimeStatistics'
  'QueryStoreWaitStatistics'
  'Errors'
  'DatabaseWaitStatistics'
  'Timouts'
  'Blocks'
  'Deadlocks'
])
param logsToEnable array = [
  'SQLInsights'
  'AutomaticTuning'
  'QueryStoreRuntimeStatistics'
  'QueryStoreWaitStatistics'
  'Errors'
  'DatabaseWaitStatistics'
  'Timouts'
  'Blocks'
  'Deadlocks'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Basic'
])
param metricsToEnable array = [
  'Basic'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

@description('Optional. The storage account type to be used to store backups for this database.')
@allowed([
  'Geo'
  'Local'
  'Zone'
  ''
])
param requestedBackupStorageRedundancy string = ''

@description('Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created.')
param isLedgerOn bool = false

@description('Optional. Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur.')
param maintenanceConfigurationId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource server 'Microsoft.Sql/servers@2021-05-01-preview' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: name
  parent: server
  location: location
  tags: tags
  properties: {
    collation: collation
    maxSizeBytes: maxSizeBytes
    sampleName: sampleName
    zoneRedundant: zoneRedundant
    licenseType: licenseType
    readScale: readScale
    minCapacity: !empty(minCapacity) ? json(minCapacity) : 0
    autoPauseDelay: !empty(autoPauseDelay) ? json(autoPauseDelay) : 0
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    requestedBackupStorageRedundancy: any(requestedBackupStorageRedundancy)
    isLedgerOn: isLedgerOn
    maintenanceConfigurationId: !empty(maintenanceConfigurationId) ? maintenanceConfigurationId : null
  }
  sku: {
    name: skuName
    tier: tier
  }
}

resource database_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${last(split(database.name, '/'))}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: database
}

@description('The name of the deployed database')
output name string = database.name

@description('The resource ID of the deployed database')
output resourceId string = database.id

@description('The resourceGroup of the deployed database')
output resourceGroupName string = resourceGroup().name
