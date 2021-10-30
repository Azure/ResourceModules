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

@description('Optional. The resource id of another managed instance whose DNS zone this managed instance will share after creation.')
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

@description('Optional. Id of the timezone. Allowed values are timezones supported by Windows.')
param timezoneId string = 'UTC'

@description('Optional. The Id of the instance pool this managed server belongs to.')
param instancePoolId string = ''

@description('Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
param restorePointInTime string = ''

@description('Optional. The resource identifier of the source managed instance associated with create operation of this instance.')
param sourceManagedInstanceId string = ''

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

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The type of identity used for the managed instance. The type "None" (default) will remove any identities from the managed instance.')
@allowed([
  'None'
  'SystemAssigned'
  'UserAssigned'
])
param managedServiceIdentity string = 'SystemAssigned'

@description('Optional. Mandatory if "managedServiceIdentity" contains UserAssigned. The list of user identities associated with the managed instance.')
param userAssignedIdentities object = {}

@description('Optional. Databases to create in this server.')
param databases array = []

@description('Optional. The vulnerability assessment configuration')
param vulnerabilityAssessmentsObj object = {}

@description('Optional. The security alert policy configuration')
param securityAlertPoliciesObj object = {}

@description('Optional. The key configuration')
param keysObj object = {}

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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Reservation Purchaser': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f7b75c60-3036-4b75-91c3-6b41c27c1689')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'SQL Managed Instance Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d')
  'SQL Security Manager': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '056cd41c-7e88-42e1-933e-88ba6a50c9c3')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedInstance 'Microsoft.Sql/managedInstances@2020-08-01-preview' = {
  name: name
  location: location
  identity: {
    type: managedServiceIdentity
    userAssignedIdentities: (empty(userAssignedIdentities)) ? null : userAssignedIdentities
  }
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
    instancePoolId: instancePoolId
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

resource managedInstance_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${managedInstance.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: managedInstance
}

module managedInstance_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: managedInstance.name
  }
}]

module managedInstance_databases 'databases/deploy.bicep' = [for (database, index) in databases: {
  name: 'database-${deployment().name}-${database.name}-${index}'
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
  dependsOn: [
    managedInstance
  ]
}]

module managedInstance_vulnerabilityAssessment 'vulnerabilityAssessments/deploy.bicep' = if (!empty(vulnerabilityAssessmentsObj)) {
  name: '${managedInstance.name}-vulnerabilityAssessment'
  params: {
    managedInstanceName: managedInstance.name
    name: vulnerabilityAssessmentsObj.name
    recurringScansEmails: contains(vulnerabilityAssessmentsObj, 'recurringScansEmails') ? vulnerabilityAssessmentsObj.recurringScansEmails : []
    recurringScansEmailSubscriptionAdmins: contains(vulnerabilityAssessmentsObj, 'recurringScansEmailSubscriptionAdmins') ? vulnerabilityAssessmentsObj.recurringScansEmailSubscriptionAdmins : false
    recurringScansIsEnabled: contains(vulnerabilityAssessmentsObj, 'recurringScansIsEnabled') ? vulnerabilityAssessmentsObj.recurringScansIsEnabled : false
    vulnerabilityAssessmentsStorageAccountId: contains(vulnerabilityAssessmentsObj, 'vulnerabilityAssessmentsStorageAccountId') ? vulnerabilityAssessmentsObj.vulnerabilityAssessmentsStorageAccountId : ''
  }
  dependsOn: [
    managedInstance
  ]
}

module managedInstance_key 'keys/deploy.bicep' = if (!empty(keysObj)) {
  name: '${managedInstance.name}-key'
  params: {
    managedInstanceName: managedInstance.name
    name: keysObj.name
    serverKeyType: contains(keysObj, 'serverKeyType') ? keysObj.serverKeyType : 'ServiceManaged'
    uri: contains(keysObj, 'uri') ? keysObj.uri : ''
  }
  dependsOn: [
    managedInstance
  ]
}
module managedInstance_encryptionProtector 'encryptionProtector/deploy.bicep' = if (!empty(encryptionProtectorObj)) {
  name: '${managedInstance.name}-encryptionProtector'
  params: {
    managedInstanceName: managedInstance.name
    serverKeyName: contains(encryptionProtectorObj, 'serverKeyName') ? encryptionProtectorObj.serverKeyName : managedInstance_key.outputs.keyName
    name: contains(encryptionProtectorObj, 'name') ? encryptionProtectorObj.serverKeyType : 'current'
    serverKeyType: contains(encryptionProtectorObj, 'serverKeyType') ? encryptionProtectorObj.serverKeyType : 'ServiceManaged'
    autoRotationEnabled: contains(encryptionProtectorObj, 'autoRotationEnabled') ? encryptionProtectorObj.autoRotationEnabled : true
  }
  dependsOn: [
    managedInstance
  ]
}

module managedInstance_securityAlertPolicy 'securityAlertPolicies/deploy.bicep' = if (!empty(securityAlertPoliciesObj)) {
  name: '${managedInstance.name}-securityAlertPolicy'
  params: {
    managedInstanceName: managedInstance.name
    name: securityAlertPoliciesObj.name
    emailAccountAdmins: contains(vulnerabilityAssessmentsObj, 'emailAccountAdmins') ? vulnerabilityAssessmentsObj.emailAccountAdmins : false
    state: contains(vulnerabilityAssessmentsObj, 'state') ? vulnerabilityAssessmentsObj.state : 'Disabled'
  }
  dependsOn: [
    managedInstance
  ]
}

module managedInstance_administrator 'administrators/deploy.bicep' = if (!empty(administratorsObj)) {
  name: '${managedInstance.name}-administrator'
  params: {
    managedInstanceName: managedInstance.name
    login: administratorsObj.name
    sid: administratorsObj.name
    tenantId: contains(administratorsObj, 'tenantId') ? administratorsObj.tenantId : ''
  }
  dependsOn: [
    managedInstance
  ]
}

@description('The name of the deployed managed instance')
output managedInstanceName string = managedInstance.name

@description('The resourceId of the deployed managed instance')
output managedInstanceResourceId string = managedInstance.id

@description('The resource group of the deployed managed instance')
output managedInstanceResourceGroup string = resourceGroup().name
