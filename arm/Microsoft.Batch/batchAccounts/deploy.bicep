@description('Required. Name of the Azure Batch.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Required. The resource ID of the storage account to be used for auto-storage account.')
param storageAccountId string

@allowed([
  'BatchAccountManagedIdentity'
  'StorageKeys'
])
@description('Optional. The authentication mode which the Batch service will use to manage the auto-storage account.')
param storageAuthenticationMode string = 'StorageKeys'

@description('Optional. The reference to a user assigned identity associated with the Batch pool which a compute node will use.')
param storageAccessIdentity string = ''

@allowed([
  'BatchService'
  'UserSubscription'
])
@description('Optional. The allocation mode for creating pools in the Batch account. Determines which quota will be used.')
param poolAllocationMode string = 'BatchService'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. The network access type for operating on the resources in the Batch account.')
param publicNetworkAccess string = 'Enabled'

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

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'AAD'
  'SharedKey'
  'TaskAuthenticationToken'
])
@description('Optional. List of allowed authentication modes for the Batch account that can be used to authenticate with the data plane.')
param allowedAuthenticationModes array = []

@allowed([
  'Microsoft.Batch'
  'Microsoft.KeyVault'
])
@description('Optional. Type of the key source.')
param encryptionKeySource string = 'Microsoft.Batch'

@description('Conditional. Full path to the versioned secret. Required if `encryptionKeySource` is set to `Microsoft.KeyVault` or `poolAllocationMode` is set to `UserSubscription`.')
param encryptionKeyIdentifier string = ''

@description('Conditional. The resource ID of the Azure key vault associated with the Batch account. Required if `encryptionKeySource` is set to `Microsoft.KeyVault` or `poolAllocationMode` is set to `UserSubscription`.')
param keyVaultResourceId string = ''

@description('Conditional. The URL of the Azure key vault associated with the Batch account. Required if `encryptionKeySource` is set to `Microsoft.KeyVault` or `poolAllocationMode` is set to `UserSubscription`.')
param keyVaultUri string = ''

@description('Optional. A list of application package definitions.')
param applications array = []

@description('Optional. A list of node pool configurations.')
param pools array = []

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'ServiceLog'
])
param diagnosticLogCategoriesToEnable array = [
  'ServiceLog'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

var identityType = systemAssignedIdentity ? 'SystemAssigned' : !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

var nodeIdentityReference = !empty(storageAccessIdentity) ? {
  resourceId: !empty(storageAccessIdentity) ? storageAccessIdentity : null
} : null

var autoStorageConfig = {
  authenticationMode: storageAuthenticationMode
  nodeIdentityReference: nodeIdentityReference
  storageAccountId: storageAccountId
}

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

resource batchAccount 'Microsoft.Batch/batchAccounts@2022-01-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    allowedAuthenticationModes: allowedAuthenticationModes
    autoStorage: autoStorageConfig
    encryption: {
      keySource: encryptionKeySource
      keyVaultProperties: encryptionKeySource == 'Microsoft.KeyVault' && systemAssignedIdentity == true || poolAllocationMode == 'UserSubscription' ? {
        keyIdentifier: encryptionKeyIdentifier
      } : null
    }
    keyVaultReference: encryptionKeySource == 'Microsoft.KeyVault' && systemAssignedIdentity == true || poolAllocationMode == 'UserSubscription' ? {
      id: keyVaultResourceId
      url: keyVaultUri
    } : null
    poolAllocationMode: poolAllocationMode
    publicNetworkAccess: publicNetworkAccess
  }
}

resource batchAccount_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${batchAccount.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: batchAccount
}

resource batchAccount_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: batchAccount
}

module batchAccount_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-batchAccount-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: batchAccount.id
  }
}]

module application 'applications/deploy.bicep' = [for app in applications: {
  name: '${uniqueString(deployment().name, batchAccount.name)}-${app.name}'
  params: {
    batchName: batchAccount.name
    appName: app.name
    allowUpdates: app.allowUpdates
    defaultVersion: app.defaultVersion
    displayName: app.displayName
  }
}]

module pool 'pools/deploy.bicep' = [for (pool, index) in pools: {
  name: '${uniqueString(deployment().name, batchAccount.name)}-pool-${index}'
  params: {
    batchAccountName: batchAccount.name
    poolName: pool.poolName
    userAssignedIdentities: contains(pool, 'userAssignedIdentities') ? pool.userAssignedIdentities : {}
    applicationLicenses: contains(pool, 'applicationLicenses') ? pool.applicationLicenses : []
    applicationPackages: contains(pool, 'applicationPackages') ? pool.applicationPackages : []
    certificates: contains(pool, 'certificates') ? pool.certificates : []
    deploymentConfiguration: pool.deploymentConfiguration
    displayName: pool.displayName
    interNodeCommunication: contains(pool, 'interNodeCommunication') ? pool.interNodeCommunication : 'Disabled'
    metadata: contains(pool, 'metadata') ? pool.metadata : []
    mountConfiguration: contains(pool, 'mountConfiguration') ? pool.mountConfiguration : []
    networkConfiguration: pool.networkConfiguration
    scaleSettings: pool.scaleSettings
    startTask: contains(pool, 'startTask') ? pool.startTask : {}
    taskSchedulingPolicy: contains(pool, 'taskSchedulingPolicy') ? pool.taskSchedulingPolicy : 'Pack'
    taskSlotsPerNode: contains(pool, 'taskSlotsPerNode') ? pool.taskSlotsPerNode : 1
    userAccounts: contains(pool, 'userAccounts') ? pool.userAccounts : []
    vmSize: pool.vmSize
  }
}]

@description('The name of the batch account.')
output name string = batchAccount.name

@description('The resource ID of the batch account.')
output resourceId string = batchAccount.id

@description('The resource group the batch account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = batchAccount.location
