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
@description('Optional. Backup retention days for the server. Default is 7 days.')
param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. Default is disabled.')
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
@description('Optional. Max storage allowed for a server. Default is 32GB.')
param storageSizeGB int = 32

@allowed([
  '11'
  '12'
  '13'
  '14'
])
@description('Optional. PostgreSQL Server version. Default is 13.')
param version string = '13'

@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Optional. The mode for high availability. Default is disabled.')
param highAvailability string = 'Disabled'

@allowed([
  'Create'
  'Default'
  'PointInTimeRestore'
  'Update'
])
@description('Optional. The mode to create a new PostgreSQL server. If not provided, will be set to "Default".')
param createMode string = 'Default'

@description('Optional. Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".')
param maintenanceWindow object = {}

@description('Conditional. Property required if "createMode" is set to "PointInTimeRestore".')
param pointInTimeUTC string = ''

@description('Conditional. Property required if "createMode" is set to "PointInTimeRestore".')
param sourceServerResourceId string = ''

@description('Optional. Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration.')
param delegatedSubnetResourceId string = ''

@description('Conditional. Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used.')
param privateDnsZoneArmResourceId string = ''

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

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = false

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

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-01-20-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
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
    network: !empty(delegatedSubnetResourceId) ? {
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

resource flexibleServer_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
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
    resourceId: flexibleServer.id
  }
}]

//module server_databases 'databases/deploy.bicep' = [for (database, index) in databases: {
//  name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'
//  params: {
//    name: database.name
//    serverName: server.name
//    skuTier: contains(database, 'skuTier') ? database.skuTier : 'GeneralPurpose'
//    skuName: contains(database, 'skuName') ? database.skuName : 'GP_Gen5_2'
//    skuCapacity: contains(database, 'skuCapacity') ? database.skuCapacity : -1
//    skuFamily: contains(database, 'skuFamily') ? database.skuFamily : ''
//    skuSize: contains(database, 'skuSize') ? database.skuSize : ''
//    collation: contains(database, 'collation') ? database.collation : 'SQL_Latin1_General_CP1_CI_AS'
//    maxSizeBytes: contains(database, 'maxSizeBytes') ? database.maxSizeBytes : 34359738368
//    autoPauseDelay: contains(database, 'autoPauseDelay') ? database.autoPauseDelay : ''
//    diagnosticLogsRetentionInDays: contains(database, 'diagnosticLogsRetentionInDays') ? database.diagnosticLogsRetentionInDays : 365
//    diagnosticStorageAccountId: contains(database, 'diagnosticStorageAccountId') ? database.diagnosticStorageAccountId : ''
//    diagnosticEventHubAuthorizationRuleId: contains(database, 'diagnosticEventHubAuthorizationRuleId') ? database.diagnosticEventHubAuthorizationRuleId : ''
//    diagnosticEventHubName: contains(database, 'diagnosticEventHubName') ? database.diagnosticEventHubName : ''
//    isLedgerOn: contains(database, 'isLedgerOn') ? database.isLedgerOn : false
//    location: contains(database, 'location') ? database.location : server.location
//    diagnosticLogCategoriesToEnable: contains(database, 'diagnosticLogCategoriesToEnable') ? database.diagnosticLogCategoriesToEnable : []
//    licenseType: contains(database, 'licenseType') ? database.licenseType : ''
//    maintenanceConfigurationId: contains(database, 'maintenanceConfigurationId') ? database.maintenanceConfigurationId : ''
//    minCapacity: contains(database, 'minCapacity') ? database.minCapacity : ''
//    diagnosticMetricsToEnable: contains(database, 'diagnosticMetricsToEnable') ? database.diagnosticMetricsToEnable : []
//    highAvailabilityReplicaCount: contains(database, 'highAvailabilityReplicaCount') ? database.highAvailabilityReplicaCount : 0
//    readScale: contains(database, 'readScale') ? database.readScale : 'Disabled'
//    requestedBackupStorageRedundancy: contains(database, 'requestedBackupStorageRedundancy') ? database.requestedBackupStorageRedundancy : ''
//    sampleName: contains(database, 'sampleName') ? database.sampleName : ''
//    tags: contains(database, 'tags') ? database.tags : {}
//    diagnosticWorkspaceId: contains(database, 'diagnosticWorkspaceId') ? database.diagnosticWorkspaceId : ''
//    zoneRedundant: contains(database, 'zoneRedundant') ? database.zoneRedundant : false
//    enableDefaultTelemetry: enableReferencedModulesTelemetry
//  }
//}]
//

//
//module server_firewallRules 'firewallRules/deploy.bicep' = [for (firewallRule, index) in firewallRules: {
//  name: '${uniqueString(deployment().name, location)}-Sql-FirewallRules-${index}'
//  params: {
//    name: firewallRule.name
//    serverName: server.name
//    endIpAddress: contains(firewallRule, 'endIpAddress') ? firewallRule.endIpAddress : '0.0.0.0'
//    startIpAddress: contains(firewallRule, 'startIpAddress') ? firewallRule.startIpAddress : '0.0.0.0'
//    enableDefaultTelemetry: enableReferencedModulesTelemetry
//  }
//}]
//
//module server_securityAlertPolicies 'securityAlertPolicies/deploy.bicep' = [for (securityAlertPolicy, index) in securityAlertPolicies: {
//  name: '${uniqueString(deployment().name, location)}-Sql-SecAlertPolicy-${index}'
//  params: {
//    name: securityAlertPolicy.name
//    serverName: server.name
//    disabledAlerts: contains(securityAlertPolicy, 'disabledAlerts') ? securityAlertPolicy.disabledAlerts : []
//    emailAccountAdmins: contains(securityAlertPolicy, 'emailAccountAdmins') ? securityAlertPolicy.emailAccountAdmins : false
//    emailAddresses: contains(securityAlertPolicy, 'emailAddresses') ? securityAlertPolicy.emailAddresses : []
//    retentionDays: contains(securityAlertPolicy, 'retentionDays') ? securityAlertPolicy.retentionDays : 0
//    state: contains(securityAlertPolicy, 'state') ? securityAlertPolicy.state : 'Disabled'
//    storageAccountAccessKey: contains(securityAlertPolicy, 'storageAccountAccessKey') ? securityAlertPolicy.storageAccountAccessKey : ''
//    storageEndpoint: contains(securityAlertPolicy, 'storageEndpoint') ? securityAlertPolicy.storageEndpoint : ''
//    enableDefaultTelemetry: enableReferencedModulesTelemetry
//  }
//}]

@description('The name of the deployed PostgreSQL Flexible server.')
output name string = flexibleServer.name

@description('The resource ID of the deployed PostgreSQL Flexible server.')
output resourceId string = flexibleServer.id

@description('The resource group of the deployed PostgreSQL Flexible server.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = flexibleServer.location
