@description('Conditional. The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.')
param administratorLogin string = ''

@description('Conditional. The administrator login password. Required if no `administrators` object for AAD authentication is provided.')
@secure()
param administratorLoginPassword string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the server.')
param name string

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Conditional. The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.')
param primaryUserAssignedIdentityId string = ''

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
param enableDefaultTelemetry bool = true

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The Elastic Pools to create in the server.')
param elasticPools array = []

@description('Optional. The firewall rules to create in the server.')
param firewallRules array = []

@description('Optional. The virtual network rules to create in the server.')
param virtualNetworkRules array = []

@description('Optional. The security alert policies to create in the server.')
param securityAlertPolicies array = []

@description('Optional. The keys to configure.')
param keys array = []

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param administrators object = {}

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. Minimal TLS version allowed.')
param minimalTlsVersion string = '1.2'

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Whether or not to restrict outbound network access for this server.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param restrictOutboundNetworkAccess string = ''

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

@description('Optional. The encryption protection configuration.')
param encryptionProtectorObj object = {}

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj object = {}

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

resource server 'Microsoft.Sql/servers@2022-05-01-preview' = {
  location: location
  name: name
  tags: tags
  identity: identity
  properties: {
    administratorLogin: !empty(administratorLogin) ? administratorLogin : null
    administratorLoginPassword: !empty(administratorLoginPassword) ? administratorLoginPassword : null
    administrators: !empty(administrators) ? {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: administrators.azureADOnlyAuthentication
      login: administrators.login
      principalType: administrators.principalType
      sid: administrators.sid
      tenantId: administrators.tenantId
    } : null
    version: '12.0'
    minimalTlsVersion: minimalTlsVersion
    primaryUserAssignedIdentityId: !empty(primaryUserAssignedIdentityId) ? primaryUserAssignedIdentityId : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(firewallRules) && empty(virtualNetworkRules) ? 'Disabled' : null)
    restrictOutboundNetworkAccess: !empty(restrictOutboundNetworkAccess) ? restrictOutboundNetworkAccess : null
  }
}

resource server_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${server.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: server
}

module server_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Sql-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: server.id
  }
}]

module server_databases 'databases/main.bicep' = [for (database, index) in databases: {
  name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'
  params: {
    name: database.name
    serverName: server.name
    skuTier: contains(database, 'skuTier') ? database.skuTier : 'GeneralPurpose'
    skuName: contains(database, 'skuName') ? database.skuName : 'GP_Gen5_2'
    skuCapacity: contains(database, 'skuCapacity') ? database.skuCapacity : -1
    skuFamily: contains(database, 'skuFamily') ? database.skuFamily : ''
    skuSize: contains(database, 'skuSize') ? database.skuSize : ''
    collation: contains(database, 'collation') ? database.collation : 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: contains(database, 'maxSizeBytes') ? database.maxSizeBytes : 34359738368
    autoPauseDelay: contains(database, 'autoPauseDelay') ? database.autoPauseDelay : 0
    diagnosticLogsRetentionInDays: contains(database, 'diagnosticLogsRetentionInDays') ? database.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(database, 'diagnosticStorageAccountId') ? database.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(database, 'diagnosticEventHubAuthorizationRuleId') ? database.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(database, 'diagnosticEventHubName') ? database.diagnosticEventHubName : ''
    isLedgerOn: contains(database, 'isLedgerOn') ? database.isLedgerOn : false
    location: contains(database, 'location') ? database.location : server.location
    diagnosticLogCategoriesToEnable: contains(database, 'diagnosticLogCategoriesToEnable') ? database.diagnosticLogCategoriesToEnable : []
    licenseType: contains(database, 'licenseType') ? database.licenseType : ''
    maintenanceConfigurationId: contains(database, 'maintenanceConfigurationId') ? database.maintenanceConfigurationId : ''
    minCapacity: contains(database, 'minCapacity') ? database.minCapacity : ''
    diagnosticMetricsToEnable: contains(database, 'diagnosticMetricsToEnable') ? database.diagnosticMetricsToEnable : []
    highAvailabilityReplicaCount: contains(database, 'highAvailabilityReplicaCount') ? database.highAvailabilityReplicaCount : 0
    readScale: contains(database, 'readScale') ? database.readScale : 'Disabled'
    requestedBackupStorageRedundancy: contains(database, 'requestedBackupStorageRedundancy') ? database.requestedBackupStorageRedundancy : ''
    sampleName: contains(database, 'sampleName') ? database.sampleName : ''
    tags: contains(database, 'tags') ? database.tags : {}
    diagnosticWorkspaceId: contains(database, 'diagnosticWorkspaceId') ? database.diagnosticWorkspaceId : ''
    zoneRedundant: contains(database, 'zoneRedundant') ? database.zoneRedundant : false
    diagnosticSettingsName: contains(database, 'diagnosticSettingsName') ? database.diagnosticSettingsName : '${database.name}-diagnosticSettings'
    elasticPoolId: contains(database, 'elasticPoolId') ? database.elasticPoolId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    backupShortTermRetentionPolicy: contains(database, 'backupShortTermRetentionPolicy') ? database.backupShortTermRetentionPolicy : {}
    backupLongTermRetentionPolicy: contains(database, 'backupLongTermRetentionPolicy') ? database.backupLongTermRetentionPolicy : {}
    createMode: contains(database, 'createMode') ? database.createMode : 'Default'
    sourceDatabaseResourceId: contains(database, 'sourceDatabaseResourceId') ? database.sourceDatabaseResourceId : ''
    sourceDatabaseDeletionDate: contains(database, 'sourceDatabaseDeletionDate') ? database.sourceDatabaseDeletionDate : ''
    recoveryServicesRecoveryPointResourceId: contains(database, 'recoveryServicesRecoveryPointResourceId') ? database.recoveryServicesRecoveryPointResourceId : ''
    restorePointInTime: contains(database, 'restorePointInTime') ? database.restorePointInTime : ''
  }
  dependsOn: [
    server_elasticPools // Enables us to add databases to existing elastic pools
  ]
}]

module server_elasticPools 'elastic-pools/main.bicep' = [for (elasticPool, index) in elasticPools: {
  name: '${uniqueString(deployment().name, location)}-SQLServer-ElasticPool-${index}'
  params: {
    name: elasticPool.name
    serverName: server.name
    databaseMaxCapacity: contains(elasticPool, 'databaseMaxCapacity') ? elasticPool.databaseMaxCapacity : 2
    databaseMinCapacity: contains(elasticPool, 'databaseMinCapacity') ? elasticPool.databaseMinCapacity : 0
    highAvailabilityReplicaCount: contains(elasticPool, 'highAvailabilityReplicaCount') ? elasticPool.highAvailabilityReplicaCount : -1
    licenseType: contains(elasticPool, 'licenseType') ? elasticPool.licenseType : 'LicenseIncluded'
    maintenanceConfigurationId: contains(elasticPool, 'maintenanceConfigurationId') ? elasticPool.maintenanceConfigurationId : ''
    maxSizeBytes: contains(elasticPool, 'maxSizeBytes') ? elasticPool.maxSizeBytes : 34359738368
    minCapacity: contains(elasticPool, 'minCapacity') ? elasticPool.minCapacity : 0
    skuCapacity: contains(elasticPool, 'skuCapacity') ? elasticPool.skuCapacity : 2
    skuName: contains(elasticPool, 'skuName') ? elasticPool.skuName : 'GP_Gen5'
    skuTier: contains(elasticPool, 'skuTier') ? elasticPool.skuTier : 'GeneralPurpose'
    zoneRedundant: contains(elasticPool, 'zoneRedundant') ? elasticPool.zoneRedundant : false
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(elasticPool, 'location') ? elasticPool.location : server.location
    tags: contains(elasticPool, 'tags') ? elasticPool.tags : {}
  }
}]

module server_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-SQLServer-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(server.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: server.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

module server_firewallRules 'firewall-rules/main.bicep' = [for (firewallRule, index) in firewallRules: {
  name: '${uniqueString(deployment().name, location)}-Sql-FirewallRules-${index}'
  params: {
    name: firewallRule.name
    serverName: server.name
    endIpAddress: contains(firewallRule, 'endIpAddress') ? firewallRule.endIpAddress : '0.0.0.0'
    startIpAddress: contains(firewallRule, 'startIpAddress') ? firewallRule.startIpAddress : '0.0.0.0'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_virtualNetworkRules 'virtual-network-rules/main.bicep' = [for (virtualNetworkRule, index) in virtualNetworkRules: {
  name: '${uniqueString(deployment().name, location)}-Sql-VirtualNetworkRules-${index}'
  params: {
    name: virtualNetworkRule.name
    serverName: server.name
    ignoreMissingVnetServiceEndpoint: contains(virtualNetworkRule, 'ignoreMissingVnetServiceEndpoint') ? virtualNetworkRule.ignoreMissingVnetServiceEndpoint : false
    virtualNetworkSubnetId: virtualNetworkRule.virtualNetworkSubnetId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_securityAlertPolicies 'security-alert-policies/main.bicep' = [for (securityAlertPolicy, index) in securityAlertPolicies: {
  name: '${uniqueString(deployment().name, location)}-Sql-SecAlertPolicy-${index}'
  params: {
    name: securityAlertPolicy.name
    serverName: server.name
    disabledAlerts: contains(securityAlertPolicy, 'disabledAlerts') ? securityAlertPolicy.disabledAlerts : []
    emailAccountAdmins: contains(securityAlertPolicy, 'emailAccountAdmins') ? securityAlertPolicy.emailAccountAdmins : false
    emailAddresses: contains(securityAlertPolicy, 'emailAddresses') ? securityAlertPolicy.emailAddresses : []
    retentionDays: contains(securityAlertPolicy, 'retentionDays') ? securityAlertPolicy.retentionDays : 0
    state: contains(securityAlertPolicy, 'state') ? securityAlertPolicy.state : 'Disabled'
    storageAccountAccessKey: contains(securityAlertPolicy, 'storageAccountAccessKey') ? securityAlertPolicy.storageAccountAccessKey : ''
    storageEndpoint: contains(securityAlertPolicy, 'storageEndpoint') ? securityAlertPolicy.storageEndpoint : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_vulnerabilityAssessment 'vulnerability-assessments/main.bicep' = if (!empty(vulnerabilityAssessmentsObj)) {
  name: '${uniqueString(deployment().name, location)}-Sql-VulnAssessm'
  params: {
    serverName: server.name
    name: vulnerabilityAssessmentsObj.name
    recurringScansEmails: contains(vulnerabilityAssessmentsObj, 'recurringScansEmails') ? vulnerabilityAssessmentsObj.recurringScansEmails : []
    recurringScansEmailSubscriptionAdmins: contains(vulnerabilityAssessmentsObj, 'recurringScansEmailSubscriptionAdmins') ? vulnerabilityAssessmentsObj.recurringScansEmailSubscriptionAdmins : false
    recurringScansIsEnabled: contains(vulnerabilityAssessmentsObj, 'recurringScansIsEnabled') ? vulnerabilityAssessmentsObj.recurringScansIsEnabled : false
    storageAccountResourceId: contains(vulnerabilityAssessmentsObj, 'storageAccountResourceId') ? vulnerabilityAssessmentsObj.storageAccountResourceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    server_securityAlertPolicies
  ]
}

module server_keys 'keys/main.bicep' = [for (key, index) in keys: {
  name: '${uniqueString(deployment().name, location)}-Sql-Key-${index}'
  params: {
    name: key.name
    serverName: server.name
    serverKeyType: contains(key, 'serverKeyType') ? key.serverKeyType : 'ServiceManaged'
    uri: contains(key, 'uri') ? key.uri : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_encryptionProtector 'encryption-protector/main.bicep' = if (!empty(encryptionProtectorObj)) {
  name: '${uniqueString(deployment().name, location)}-Sql-EncryProtector'
  params: {
    sqlServerName: server.name
    serverKeyName: encryptionProtectorObj.serverKeyName
    serverKeyType: contains(encryptionProtectorObj, 'serverKeyType') ? encryptionProtectorObj.serverKeyType : 'ServiceManaged'
    autoRotationEnabled: contains(encryptionProtectorObj, 'autoRotationEnabled') ? encryptionProtectorObj.autoRotationEnabled : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    server_keys
  ]
}

@description('The name of the deployed SQL server.')
output name string = server.name

@description('The resource ID of the deployed SQL server.')
output resourceId string = server.id

@description('The resource group of the deployed SQL server.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(server.identity, 'principalId') ? server.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = server.location
