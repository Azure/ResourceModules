@description('Required. Name of the Azure Recovery Service Vault.')
param name string

@description('Optional. The storage configuration for the Azure Recovery Service Vault.')
param backupStorageConfig object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of all backup policies.')
param backupPolicies array = []

@description('Optional. The backup configuration.')
param backupConfig object = {}

@description('Optional. List of all protection containers.')
@minLength(0)
param protectionContainers array = []

@description('Optional. List of all replication fabrics.')
@minLength(0)
param replicationFabrics array = []

@description('Optional. List of all replication policies.')
@minLength(0)
param replicationPolicies array = []

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

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
param diagnosticLogCategoriesToEnable array = [
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
param diagnosticMetricsToEnable array = [
  'Health'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource rsv 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: name
  location: location
  tags: tags
  identity: any(identity)
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}
}

module rsv_replicationFabrics 'replicationFabrics/deploy.bicep' = [for (replicationFabric, index) in replicationFabrics: {
  name: '${uniqueString(deployment().name, location)}-RSV-Fabric-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: contains(replicationFabric, 'name') ? replicationFabric.name : replicationFabric.location
    location: replicationFabric.location
    replicationContainers: contains(replicationFabric, 'replicationContainers') ? replicationFabric.replicationContainers : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    rsv_replicationPolicies
  ]
}]

module rsv_replicationPolicies 'replicationPolicies/deploy.bicep' = [for (replicationPolicy, index) in replicationPolicies: {
  name: '${uniqueString(deployment().name, location)}-RSV-Policy-${index}'
  params: {
    name: replicationPolicy.name
    recoveryVaultName: rsv.name
    appConsistentFrequencyInMinutes: contains(replicationPolicy, 'appConsistentFrequencyInMinutes') ? replicationPolicy.appConsistentFrequencyInMinutes : 60
    crashConsistentFrequencyInMinutes: contains(replicationPolicy, 'crashConsistentFrequencyInMinutes') ? replicationPolicy.crashConsistentFrequencyInMinutes : 5
    multiVmSyncStatus: contains(replicationPolicy, 'multiVmSyncStatus') ? replicationPolicy.multiVmSyncStatus : 'Enable'
    recoveryPointHistory: contains(replicationPolicy, 'recoveryPointHistory') ? replicationPolicy.recoveryPointHistory : 1440
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module rsv_backupStorageConfiguration 'backupStorageConfig/deploy.bicep' = if (!empty(backupStorageConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupStorageConfig'
  params: {
    recoveryVaultName: rsv.name
    storageModelType: backupStorageConfig.storageModelType
    crossRegionRestoreFlag: backupStorageConfig.crossRegionRestoreFlag
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module rsv_protectionContainers 'protectionContainers/deploy.bicep' = [for (protectionContainer, index) in protectionContainers: {
  name: '${uniqueString(deployment().name, location)}-RSV-ProtectionContainers-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: protectionContainer.name
    sourceResourceId: protectionContainer.sourceResourceId
    friendlyName: protectionContainer.friendlyName
    backupManagementType: protectionContainer.backupManagementType
    containerType: protectionContainer.containerType
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    protectedItems: contains(protectionContainer, 'protectedItems') ? protectionContainer.protectedItems : []
    location: location
  }
}]

module rsv_backupPolicies 'backupPolicies/deploy.bicep' = [for (backupPolicy, index) in backupPolicies: {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupPolicy-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: backupPolicy.name
    backupPolicyProperties: backupPolicy.properties
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module rsv_backupConfig 'backupConfig/deploy.bicep' = if (!empty(backupConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupConfig'
  params: {
    recoveryVaultName: rsv.name
    name: contains(backupConfig, 'name') ? backupConfig.name : 'vaultconfig'
    enhancedSecurityState: contains(backupConfig, 'enhancedSecurityState') ? backupConfig.enhancedSecurityState : 'Enabled'
    resourceGuardOperationRequests: contains(backupConfig, 'resourceGuardOperationRequests') ? backupConfig.resourceGuardOperationRequests : []
    softDeleteFeatureState: contains(backupConfig, 'softDeleteFeatureState') ? backupConfig.softDeleteFeatureState : 'Enabled'
    storageModelType: contains(backupConfig, 'storageModelType') ? backupConfig.storageModelType : 'GeoRedundant'
    storageType: contains(backupConfig, 'storageType') ? backupConfig.storageType : 'GeoRedundant'
    storageTypeState: contains(backupConfig, 'storageTypeState') ? backupConfig.storageTypeState : 'Locked'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource rsv_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${rsv.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: rsv
}

resource rsv_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: rsv
}

module rsv_privateEndpoints '../../Microsoft.Network/privateEndpoints/deploy.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-RSV-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(rsv.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: rsv.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroups: contains(privateEndpoint, 'privateDnsZoneGroups') ? privateEndpoint.privateDnsZoneGroups : []
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
  }
}]

module rsv_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-RSV-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: rsv.id
  }
}]

@description('The resource ID of the recovery services vault.')
output resourceId string = rsv.id

@description('The name of the resource group the recovery services vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the recovery services vault.')
output name string = rsv.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(rsv.identity, 'principalId') ? rsv.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = rsv.location
