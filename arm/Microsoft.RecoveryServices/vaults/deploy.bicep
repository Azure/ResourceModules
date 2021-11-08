@description('Required. Name of the Azure Recovery Service Vault')
@minLength(1)
param recoveryVaultName string

@description('Optional. Enable CRR (Works if vault has not registered any backup instance)')
param enableCRR bool = true

@description('Optional. Change Vault Storage Type (Works if vault has not registered any backup instance)')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of all backup policies.')
param backupPolicies array = []

@description('Optional. List of all protection containers.')
@minLength(0)
param protectionContainers array = []

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object = {}

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'AzureBackupReport'
  'CoreAzureBackup'
  'AddonAzureBackupJobs'
  'AddonAzureBackupAlerts'
  'AddonAzureBackupPolicy'
  'AddonAzureBackupStorage'
  'AddonAzureBackupProtectedInstance'
  'AzureSiteRecoveryJobs'
  'AzureSiteRecoveryEvents'
  'AzureSiteRecoveryReplicatedItems'
  'AzureSiteRecoveryReplicationStats'
  'AzureSiteRecoveryRecoveryPoints'
  'AzureSiteRecoveryReplicationDataUploadRate'
  'AzureSiteRecoveryProtectedDiskDataChurn'
])
param logsToEnable array = [
  'AzureBackupReport'
  'CoreAzureBackup'
  'AddonAzureBackupJobs'
  'AddonAzureBackupAlerts'
  'AddonAzureBackupPolicy'
  'AddonAzureBackupStorage'
  'AddonAzureBackupProtectedInstance'
  'AzureSiteRecoveryJobs'
  'AzureSiteRecoveryEvents'
  'AzureSiteRecoveryReplicatedItems'
  'AzureSiteRecoveryReplicationStats'
  'AzureSiteRecoveryRecoveryPoints'
  'AzureSiteRecoveryReplicationDataUploadRate'
  'AzureSiteRecoveryProtectedDiskDataChurn'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Health'
])
param metricsToEnable array = [
  'Health'
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

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource rsv 'Microsoft.RecoveryServices/vaults@2021-08-01' = {
  name: recoveryVaultName
  location: location
  tags: tags
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}

  resource rsv_vaultstorageconfig 'backupstorageconfig@2020-02-02' = {
    name: 'vaultstorageconfig'
    properties: {
      StorageModelType: vaultStorageType
      CrossRegionRestoreFlag: enableCRR
    }
  }

  resource rsv_protectionContainers 'protectionContainers@2016-12-01' = [for (protectionContainer, index) in protectionContainers: {
    name: protectionContainer.Name
    location: resourceGroup().location
    properties: {
      sourceResourceId: (empty(protectionContainer.sourceResourceId) ? json('null') : protectionContainer.sourceResourceId)
      friendlyName: (empty(protectionContainer.friendlyName) ? json('null') : protectionContainer.friendlyName)
      backupManagementType: (empty(protectionContainer.backupManagementType) ? json('null') : protectionContainer.backupManagementType)
      containerType: (empty(protectionContainer.containerType) ? json('null') : protectionContainer.containerType)
    }
  }]

  resource rsv_backupPolicies 'backupPolicies@2019-06-15' = [for (protectionPolicy, index) in backupPolicies: {
    name: protectionPolicy.name
    location: resourceGroup().location
    properties: protectionPolicy.Properties
  }]
}

resource rsv_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${rsv.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: rsv
}

resource rsv_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${rsv.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: rsv
}

module rsv_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: rsv.name
  }
}]

output recoveryServicesVaultResourceId string = rsv.id
output recoveryServicesVaultResourceGroup string = resourceGroup().name
output recoveryServicesVaultName string = rsv.name
