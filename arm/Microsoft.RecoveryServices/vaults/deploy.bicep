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

@description('Optional. Switch to lock Recovery Service Vault from deletion.')
param lockForDeletion bool = false

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object = {}

var diagnosticsMetrics = [
  {
    category: 'Health'
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var diagnosticLogs = [
  {
    category: 'AzureBackupReport'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'CoreAzureBackup'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AddonAzureBackupJobs'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AddonAzureBackupAlerts'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AddonAzureBackupPolicy'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AddonAzureBackupStorage'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AddonAzureBackupProtectedInstance'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryJobs'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryEvents'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryReplicatedItems'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryReplicationStats'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryRecoveryPoints'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryReplicationDataUploadRate'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
  {
    category: 'AzureSiteRecoveryProtectedDiskDataChurn'
    enabled: true
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: true
    }
  }
]
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'Backup Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a795c7a0-d4a2-40c1-ae25-d81f01202912')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'Site Recovery Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dbaa88c4-0c30-4179-9fb3-46319faa6149')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
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
}

resource rsv_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${recoveryVaultName}-rsvDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: rsv
}

resource rsv_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${recoveryVaultName}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticLogs)
  }
  scope: rsv
}

module rsv_backupPolicies './.bicep/nested_backupPolicies.bicep' = [for (protectionPolicy, index) in backupPolicies: {
  name: 'backupPolicies-${(empty(backupPolicies) ? 'dummy' : index)}'
  params: {
    protectionPolicyName: protectionPolicy.Name
    protectionPolicyProperties: protectionPolicy.Properties
    recoveryVaultName: recoveryVaultName
  }
  dependsOn: [
    rsv
  ]
}]

module rsv_protectedContainers './.bicep/nested_protectedContainers.bicep' = [for (protectionContainer, index) in protectionContainers: {
  name: 'protectionContainer-${(empty(protectionContainers) ? 'dummy' : index)}'
  params: {
    protectionContainerName: protectionContainer.Name
    protectionContainerSourceResourceId: protectionContainer.sourceResourceId
    protectionContainerFriendlyName: protectionContainer.friendlyName
    protectionContainerBackupManagementType: protectionContainer.backupManagementType
    protectionContainerContainerType: protectionContainer.containerType
    recoveryVaultName: recoveryVaultName
  }
  dependsOn: [
    rsv
  ]
}]

module rsv_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: rsv.name
  }
}]

output recoveryServicesVaultResourceId string = rsv.id
output recoveryServicesVaultResourceGroup string = resourceGroup().name
output recoveryServicesVaultName string = rsv.name
