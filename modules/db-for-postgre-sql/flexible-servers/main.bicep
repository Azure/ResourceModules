@description('Required. The name of the PostgreSQL flexible server.')
param name string

@description('Required. The administrator login name of a server. Can only be specified when the PostgreSQL server is being created.')
param administratorLogin string

@description('Required. The administrator login password.')
@secure()
param administratorLoginPassword string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@minValue(7)
@maxValue(35)
@description('Optional. Backup retention days for the server.')
param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. Should be left disabled if \'cMKKeyName\' is not empty.')
param geoRedundantBackup string = 'Disabled'

@allowed([
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
@description('Optional. Max storage allowed for a server.')
param storageSizeGB int = 32

@allowed([
  '11'
  '12'
  '13'
  '14'
])
@description('Optional. PostgreSQL Server version.')
param version string = '13'

@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Optional. The mode for high availability.')
param highAvailability string = 'Disabled'

@allowed([
  'Create'
  'Default'
  'PointInTimeRestore'
  'Update'
])
@description('Optional. The mode to create a new PostgreSQL server.')
param createMode string = 'Default'

@description('Conditional. The ID(s) to assign to the resource. Required if \'cMKKeyName\' is not empty.')
param userAssignedIdentities object = {}

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if \'cMKKeyName\' is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".')
param maintenanceWindow object = {}

@description('Conditional. Required if "createMode" is set to "PointInTimeRestore".')
param pointInTimeUTC string = ''

@description('Conditional. Required if "createMode" is set to "PointInTimeRestore".')
param sourceServerResourceId string = ''

@description('Optional. Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration.')
param delegatedSubnetResourceId string = ''

@description('Optional. Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId".')
param privateDnsZoneArmResourceId string = ''

@description('Optional. The firewall rules to create in the PostgreSQL flexible server.')
param firewallRules array = []

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The configurations to create in the server.')
param configurations array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = false

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
  'PostgreSQLLogs'
  'PostgreSQLFlexSessions'
  'PostgreSQLFlexQueryStoreRuntime'
  'PostgreSQLFlexQueryStoreWaitStats'
  'PostgreSQLFlexTableStats'
  'PostgreSQLFlexDatabaseXacts'
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

resource cMKKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2022-07-01' existing = if (!empty(cMKKeyVaultResourceId) && !empty(cMKKeyName)) {
  name: '${last(split(cMKKeyVaultResourceId, '/'))}/${cMKKeyName}'
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
  }
  identity: {
    type: !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'
    userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : {}
  }
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
      primaryKeyURI: !empty(cMKKeyVersion) ? '${cMKKeyVaultKey.properties.keyUri}/${cMKKeyVersion}' : cMKKeyVaultKey.properties.keyUriWithVersion
      primaryUserAssignedIdentityId: cMKUserAssignedIdentityResourceId
      type: 'AzureKeyVault'
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
      privateDnsZoneArmResourceId: privateDnsZoneArmResourceId
    } : null
    pointInTimeUTC: createMode == 'PointInTimeRestore' ? pointInTimeUTC : null
    sourceServerResourceId: createMode == 'PointInTimeRestore' ? sourceServerResourceId : null
    storage: {
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
  name: '${uniqueString(deployment().name, location)}-PostgreSQL-Rbac-${index}'
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
  name: '${uniqueString(deployment().name, location)}-PostgreSQL-DB-${index}'
  params: {
    name: database.name
    flexibleServerName: flexibleServer.name
    collation: contains(database, 'collation') ? database.collation : ''
    charset: contains(database, 'charset') ? database.charset : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module flexibleServer_firewallRules 'firewall-rules/main.bicep' = [for (firewallRule, index) in firewallRules: {
  name: '${uniqueString(deployment().name, location)}-PostgreSQL-FirewallRules-${index}'
  params: {
    name: firewallRule.name
    flexibleServerName: flexibleServer.name
    startIpAddress: firewallRule.startIpAddress
    endIpAddress: firewallRule.endIpAddress
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    flexibleServer_databases
  ]
}]

module flexibleServer_configurations 'configurations/main.bicep' = [for (configuration, index) in configurations: {
  name: '${uniqueString(deployment().name, location)}-PostgreSQL-Configurations-${index}'
  params: {
    name: configuration.name
    flexibleServerName: flexibleServer.name
    source: contains(configuration, 'source') ? configuration.source : ''
    value: contains(configuration, 'value') ? configuration.value : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    flexibleServer_firewallRules
  ]
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

@description('The name of the deployed PostgreSQL Flexible server.')
output name string = flexibleServer.name

@description('The resource ID of the deployed PostgreSQL Flexible server.')
output resourceId string = flexibleServer.id

@description('The resource group of the deployed PostgreSQL Flexible server.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = flexibleServer.location
