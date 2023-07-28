@description('Required. The name of the MySQL flexible server.')
param name string

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. The administrator login name of a server. Can only be specified when the MySQL server is being created.')
param administratorLogin string

@description('Required. The administrator login password.')
@secure()
param administratorLoginPassword string

@description('Required. The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.')
param skuName string

@allowed([
  'GeneralPurpose'
  'Burstable'
  'MemoryOptimized'
])
@description('Required. The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3".')
param tier string

@allowed([
  ''
  '1'
  '2'
  '3'
])
@description('Optional. Availability zone information of the server. Default will have no preference set.')
param availabilityZone string = ''

@minValue(1)
@maxValue(35)
@description('Optional. Backup retention days for the server.')
param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required.')
param geoRedundantBackup string = 'Disabled'

@allowed([
  'Default'
  'GeoRestore'
  'PointInTimeRestore'
  'Replica'
])
@description('Optional. The mode to create a new MySQL server.')
param createMode string = 'Default'

@description('Conditional. The ID(s) to assign to the resource. Required if "cMKKeyName" is not empty.')
param userAssignedIdentities object = {}

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled".')
param geoBackupCMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption when geoRedundantBackup is "Enabled".')
param geoBackupCMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption when geoRedundantBackup is "Enabled". If not provided, the latest key version is used.')
param geoBackupCMKKeyVersion string = ''

@description('Conditional. Geo backup user identity resource ID as identity cant cross region, need identity in same region as geo backup. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled".')
param geoBackupCMKUserAssignedIdentityResourceId string = ''

@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Optional. The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning.')
param highAvailability string = 'Disabled'

@description('Optional. Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".')
param maintenanceWindow object = {}

@description('Optional. Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29.')
param delegatedSubnetResourceId string = ''

@description('Conditional. Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server.')
param privateDnsZoneResourceId string = ''

@description('Conditional. Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore".')
param restorePointInTime string = ''

@allowed([
  'None'
  'Replica'
  'Source'
])
@description('Optional. The replication role.')
param replicationRole string = 'None'

@description('Conditional. The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore".')
param sourceServerResourceId string = ''

@allowed([
  'Disabled'
  'Enabled'
])
@description('Conditional. Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled".')
param storageAutoGrow string = 'Disabled'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs.')
param storageAutoIoScaling string = 'Disabled'

@minValue(360)
@maxValue(48000)
@description('Optional. Storage IOPS for a server. Max IOPS are determined by compute size.')
param storageIOPS int = 1000

@allowed([
  20
  32
  64
  128
  256
  512
  1024
  2048
  4096
  8192
  16384
])
@description('Optional. Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB.')
param storageSizeGB int = 64

@allowed([
  '5.7'
  '8.0.21'
])
@description('Optional. MySQL Server version.')
param version string = '5.7'

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The firewall rules to create in the MySQL flexible server.')
param firewallRules array = []

@description('Optional. Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11".')
param roleAssignments array = []

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

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'MySqlAuditLogs'
  'MySqlSlowLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])

  resource cMKKey 'keys@2022-07-01' existing = if (!empty(cMKKeyName)) {
    name: cMKKeyName
  }
}

resource geoBackupCMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(geoBackupCMKKeyVaultResourceId)) {
  name: last(split(geoBackupCMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(geoBackupCMKKeyVaultResourceId, '/')[2], split(geoBackupCMKKeyVaultResourceId, '/')[4])

  resource geoBackupCMKKey 'keys@2023-02-01' existing = if (!empty(geoBackupCMKKeyName)) {
    name: geoBackupCMKKeyName
  }
}

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2022-09-30-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
  }
  identity: identity
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    availabilityZone: availabilityZone
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    createMode: createMode
    dataEncryption: !empty(cMKKeyName) ? {
      type: 'AzureKeyVault'
      geoBackupKeyURI: geoRedundantBackup == 'Enabled' ? (!empty(geoBackupCMKKeyVersion) ? '${geoBackupCMKKeyVault::geoBackupCMKKey.properties.keyUri}/${geoBackupCMKKeyVersion}' : geoBackupCMKKeyVault::geoBackupCMKKey.properties.keyUriWithVersion) : null
      geoBackupUserAssignedIdentityId: geoRedundantBackup == 'Enabled' ? geoBackupCMKUserAssignedIdentityResourceId : null
      primaryKeyURI: !empty(cMKKeyVersion) ? '${cMKKeyVault::cMKKey.properties.keyUri}/${cMKKeyVersion}' : cMKKeyVault::cMKKey.properties.keyUriWithVersion
      primaryUserAssignedIdentityId: cMKUserAssignedIdentityResourceId
    } : null
    highAvailability: {
      mode: highAvailability
      standbyAvailabilityZone: highAvailability == 'SameZone' ? availabilityZone : null
    }
    maintenanceWindow: !empty(maintenanceWindow) ? {
      customWindow: maintenanceWindow.customWindow
      dayOfWeek: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.dayOfWeek : 0
      startHour: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.startHour : 0
      startMinute: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.startMinute : 0
    } : null
    network: !empty(delegatedSubnetResourceId) && empty(firewallRules) ? {
      delegatedSubnetResourceId: delegatedSubnetResourceId
      privateDnsZoneResourceId: privateDnsZoneResourceId
    } : null
    replicationRole: replicationRole
    restorePointInTime: restorePointInTime
    sourceServerResourceId: !empty(sourceServerResourceId) ? sourceServerResourceId : null
    storage: {
      autoGrow: storageAutoGrow
      autoIoScaling: storageAutoIoScaling
      iops: storageIOPS
      storageSizeGB: storageSizeGB
    }
    version: version
  }
}

resource flexibleServer_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${flexibleServer.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: flexibleServer
}

module flexibleServer_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-MySQL-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: flexibleServer.id
  }
}]

module flexibleServer_databases 'databases/main.bicep' = [for (database, index) in databases: {
  name: '${uniqueString(deployment().name, location)}-MySQL-DB-${index}'
  params: {
    name: database.name
    flexibleServerName: flexibleServer.name
    collation: contains(database, 'collation') ? database.collation : ''
    charset: contains(database, 'charset') ? database.charset : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module flexibleServer_firewallRules 'firewall-rules/main.bicep' = [for (firewallRule, index) in firewallRules: {
  name: '${uniqueString(deployment().name, location)}-MySQL-FirewallRules-${index}'
  params: {
    name: firewallRule.name
    flexibleServerName: flexibleServer.name
    startIpAddress: firewallRule.startIpAddress
    endIpAddress: firewallRule.endIpAddress
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource flexibleServer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: flexibleServer
}

@description('The name of the deployed MySQL Flexible server.')
output name string = flexibleServer.name

@description('The resource ID of the deployed MySQL Flexible server.')
output resourceId string = flexibleServer.id

@description('The resource group of the deployed MySQL Flexible server.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = flexibleServer.location
