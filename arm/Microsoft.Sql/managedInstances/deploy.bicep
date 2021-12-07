@description('Required. The name of the SQL managed instance.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The username used to establish jumpbox VMs.')
param administratorLogin string

@description('Required. The password given to the admin user.')
@secure()
param administratorLoginPassword string

@description('Required. The fully qualified resource ID of the subnet on which the SQL managed instance will be placed.')
param subnetId string

@description('Optional. The name of the SKU, typically, a letter + Number code, e.g. P3.')
param skuName string = 'GP_Gen5'

@description('Optional. The tier or edition of the particular SKU, e.g. Basic, Premium.')
param skuTier string = 'GeneralPurpose'

@description('Optional. Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only.')
param storageSizeInGB int = 32

@description('Optional. The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80.')
param vCores int = 4

@description('Optional. The license type. Possible values are \'LicenseIncluded\' (regular price inclusive of a new SQL license) and \'BasePrice\' (discounted AHB price for bringing your own SQL licenses).')
@allowed([
  'LicenseIncluded'
  'BasePrice'
])
param licenseType string = 'LicenseIncluded'

@description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
param hardwareFamily string = 'Gen5'

@description('Optional. Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified.')
@allowed([
  'Default'
  'PointInTimeRestore'
])
param managedInstanceCreateMode string = 'Default'

@description('Optional. The resource ID of another managed instance whose DNS zone this managed instance will share after creation.')
param dnsZonePartner string = ''

@description('Optional. Collation of the managed instance.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Connection type used for connecting to the instance.')
@allowed([
  'Proxy'
  'Redirect'
  'Default'
])
param proxyOverride string = 'Proxy'

@description('Optional. Whether or not the public data endpoint is enabled.')
param publicDataEndpointEnabled bool = false

@description('Optional. ID of the timezone. Allowed values are timezones supported by Windows.')
param timezoneId string = 'UTC'

@description('Optional. The resource ID of the instance pool this managed server belongs to.')
param instancePoolResourceId string = ''

@description('Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
param restorePointInTime string = ''

@description('Optional. The resource identifier of the source managed instance associated with create operation of this instance.')
param sourceManagedInstanceId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of a log analytics workspace.')
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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Mandatory if "managedServiceIdentity" contains UserAssigned. The resource ID of a user assigned identity to be used by default.')
param primaryUserAssignedIdentityId string = ''

@description('Optional. Databases to create in this server.')
param databases array = []

@description('Optional. The vulnerability assessment configuration')
param vulnerabilityAssessmentsObj object = {}

@description('Optional. The security alert policy configuration')
param securityAlertPoliciesObj object = {}

@description('Optional. The keys to configure')
param keys array = []

@description('Optional. The encryption protection configuration')
param encryptionProtectorObj object = {}

@description('Optional. The administrator configuration')
param administratorsObj object = {}

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'ResourceUsageStats'
  'SQLSecurityAuditEvents'
])
param logsToEnable array = [
  'ResourceUsageStats'
  'SQLSecurityAuditEvents'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
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

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' = {
  name: name
  location: location
  identity: identity
  sku: {
    name: skuName
    tier: skuTier
  }
  tags: tags
  properties: {
    managedInstanceCreateMode: managedInstanceCreateMode
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    subnetId: subnetId
    licenseType: licenseType
    hardwareFamily: hardwareFamily
    vCores: vCores
    storageSizeInGB: storageSizeInGB
    collation: collation
    dnsZonePartner: dnsZonePartner
    publicDataEndpointEnabled: publicDataEndpointEnabled
    sourceManagedInstanceId: sourceManagedInstanceId
    restorePointInTime: restorePointInTime
    proxyOverride: proxyOverride
    timezoneId: timezoneId
    instancePoolId: instancePoolResourceId
    primaryUserAssignedIdentityId: primaryUserAssignedIdentityId
  }
}

resource managedInstance_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${managedInstance.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: managedInstance
}

resource managedInstance_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${managedInstance.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? null : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? null : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsLogs)
  }
  scope: managedInstance
}

module managedInstance_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-SqlMi-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: managedInstance.id
  }
}]

module managedInstance_databases 'databases/deploy.bicep' = [for (database, index) in databases: {
  name: '${uniqueString(deployment().name, location)}-SqlMi-DB-${index}'
  params: {
    name: database.name
    managedInstanceName: managedInstance.name
    catalogCollation: contains(database, 'catalogCollation') ? database.catalogCollation : 'SQL_Latin1_General_CP1_CI_AS'
    collation: contains(database, 'collation') ? database.collation : 'SQL_Latin1_General_CP1_CI_AS'
    createMode: contains(database, 'createMode') ? database.createMode : 'Default'
    diagnosticLogsRetentionInDays: contains(database, 'diagnosticLogsRetentionInDays') ? database.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(database, 'diagnosticStorageAccountId') ? database.diagnosticStorageAccountId : ''
    eventHubAuthorizationRuleId: contains(database, 'eventHubAuthorizationRuleId') ? database.eventHubAuthorizationRuleId : ''
    eventHubName: contains(database, 'eventHubName') ? database.eventHubName : ''
    location: contains(database, 'location') ? database.location : managedInstance.location
    lock: contains(database, 'lock') ? database.lock : lock
    longTermRetentionBackupResourceId: contains(database, 'longTermRetentionBackupResourceId') ? database.longTermRetentionBackupResourceId : ''
    recoverableDatabaseId: contains(database, 'recoverableDatabaseId') ? database.recoverableDatabaseId : ''
    restorableDroppedDatabaseId: contains(database, 'restorableDroppedDatabaseId') ? database.restorableDroppedDatabaseId : ''
    restorePointInTime: contains(database, 'restorePointInTime') ? database.restorePointInTime : ''
    sourceDatabaseId: contains(database, 'sourceDatabaseId') ? database.sourceDatabaseId : ''
    storageContainerSasToken: contains(database, 'storageContainerSasToken') ? database.storageContainerSasToken : ''
    storageContainerUri: contains(database, 'storageContainerUri') ? database.storageContainerUri : ''
    tags: contains(database, 'tags') ? database.tags : {}
    workspaceId: contains(database, 'workspaceId') ? database.workspaceId : ''
    backupShortTermRetentionPoliciesObj: contains(database, 'backupShortTermRetentionPolicies') ? database.backupShortTermRetentionPolicies : {}
    backupLongTermRetentionPoliciesObj: contains(database, 'backupLongTermRetentionPolicies') ? database.backupLongTermRetentionPolicies : {}
  }
}]

module managedInstance_securityAlertPolicy 'securityAlertPolicies/deploy.bicep' = if (!empty(securityAlertPoliciesObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-SecAlertPol'
  params: {
    managedInstanceName: managedInstance.name
    name: securityAlertPoliciesObj.name
    emailAccountAdmins: contains(securityAlertPoliciesObj, 'emailAccountAdmins') ? securityAlertPoliciesObj.emailAccountAdmins : false
    state: contains(securityAlertPoliciesObj, 'state') ? securityAlertPoliciesObj.state : 'Disabled'
  }
}

module managedInstance_vulnerabilityAssessment 'vulnerabilityAssessments/deploy.bicep' = if (!empty(vulnerabilityAssessmentsObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-VulnAssessm'
  params: {
    managedInstanceName: managedInstance.name
    name: vulnerabilityAssessmentsObj.name
    recurringScansEmails: contains(vulnerabilityAssessmentsObj, 'recurringScansEmails') ? vulnerabilityAssessmentsObj.recurringScansEmails : []
    recurringScansEmailSubscriptionAdmins: contains(vulnerabilityAssessmentsObj, 'recurringScansEmailSubscriptionAdmins') ? vulnerabilityAssessmentsObj.recurringScansEmailSubscriptionAdmins : false
    recurringScansIsEnabled: contains(vulnerabilityAssessmentsObj, 'recurringScansIsEnabled') ? vulnerabilityAssessmentsObj.recurringScansIsEnabled : false
    vulnerabilityAssessmentsStorageAccountId: contains(vulnerabilityAssessmentsObj, 'vulnerabilityAssessmentsStorageAccountId') ? vulnerabilityAssessmentsObj.vulnerabilityAssessmentsStorageAccountId : ''
  }
  dependsOn: [
    managedInstance_securityAlertPolicy
  ]
}

module managedInstance_key 'keys/deploy.bicep' = [for (key, index) in keys: {
  name: '${uniqueString(deployment().name, location)}-SqlMi-Key-${index}'
  params: {
    managedInstanceName: managedInstance.name
    name: contains(key, 'name') ? key.name : ''
    serverKeyType: contains(key, 'serverKeyType') ? key.serverKeyType : 'ServiceManaged'
    uri: contains(key, 'uri') ? key.uri : ''
  }
}]

module managedInstance_encryptionProtector 'encryptionProtector/deploy.bicep' = if (!empty(encryptionProtectorObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-EncryProtector'
  params: {
    managedInstanceName: managedInstance.name
    serverKeyName: contains(encryptionProtectorObj, 'serverKeyName') ? encryptionProtectorObj.serverKeyName : managedInstance_key[0].outputs.keyName
    name: contains(encryptionProtectorObj, 'name') ? encryptionProtectorObj.serverKeyType : 'current'
    serverKeyType: contains(encryptionProtectorObj, 'serverKeyType') ? encryptionProtectorObj.serverKeyType : 'ServiceManaged'
    autoRotationEnabled: contains(encryptionProtectorObj, 'autoRotationEnabled') ? encryptionProtectorObj.autoRotationEnabled : true
  }
}

module managedInstance_administrator 'administrators/deploy.bicep' = if (!empty(administratorsObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-Admin'
  params: {
    managedInstanceName: managedInstance.name
    login: administratorsObj.name
    sid: administratorsObj.name
    tenantId: contains(administratorsObj, 'tenantId') ? administratorsObj.tenantId : ''
  }
}

@description('The name of the deployed managed instance')
output managedInstanceName string = managedInstance.name

@description('The resource ID of the deployed managed instance')
output managedInstanceResourceId string = managedInstance.id

@description('The resource group of the deployed managed instance')
output managedInstanceResourceGroup string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity ? managedInstance.identity.principalId : ''
