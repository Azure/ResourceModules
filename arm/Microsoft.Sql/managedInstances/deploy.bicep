@description('Required. The name of the SQL managed instance.')
param managedInstanceName string

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

@description('Optional. The URI of the key (in Azure Key Vault) for transparent data encryption. The key vault must have SoftDelete enabled and must reside in the same region as the SQL MI. The managed identity of the SQL managed instance needs to have the following key permissions in the key vault: Get, Unwrap Key, Wrap Key. If blank, service managed key will be used.')
param customerManagedEnryptionKeyUri string = ''

@description('Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.')
param enableAdvancedDataSecurity bool = false

@description('Optional. A blob storage to hold the scan results.')
param vulnerabilityAssessmentsStorageAccountId string = ''

@description('Optional. Recurring scans state.')
param enableRecuringVulnerabilityAssessmentsScans bool = false

@description('Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators.')
param sendScanReportEmailsToSubscriptionAdmins bool = false

@description('Optional. Specifies an array of e-mail addresses to which the scan notification is sent.')
param sendScanReportToEmailAddresses array = []

@description('Optional. An Azure Active Directory administrator account.')
param azureAdAdmin object = {}

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

var splittedKeyUri = split(customerManagedEnryptionKeyUri, '/')
var serverKeyName = (empty(customerManagedEnryptionKeyUri) ? 'ServiceManaged' : '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${splittedKeyUri[5]}')

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedInstance 'Microsoft.Sql/managedInstances@2020-08-01-preview' = {
  name: managedInstanceName
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

  resource keys 'keys@2017-10-01-preview' = if (!empty(customerManagedEnryptionKeyUri)) {
    name: serverKeyName
    properties: {
      serverKeyType: 'AzureKeyVault'
      uri: customerManagedEnryptionKeyUri
    }
  }

  resource encryptionProtector 'encryptionProtector@2017-10-01-preview' = {
    name: 'current'
    properties: {
      serverKeyName: keys.name
      serverKeyType: (empty(customerManagedEnryptionKeyUri) ? 'ServiceManaged' : 'AzureKeyVault')
      uri: customerManagedEnryptionKeyUri
    }
  }

  resource securityAlertPolicies 'securityAlertPolicies@2017-03-01-preview' = {
    name: 'Default'
    properties: {
      state: (enableAdvancedDataSecurity ? 'Enabled' : 'Disabled')
      emailAccountAdmins: sendScanReportEmailsToSubscriptionAdmins
    }
  }

  resource vulnerabilityAssessments 'vulnerabilityAssessments@2021-02-01-preview' = if (enableAdvancedDataSecurity) {
    name: 'default'
    properties: {
      storageContainerPath: (enableAdvancedDataSecurity ? 'https://${split(vulnerabilityAssessmentsStorageAccountId, '/')[8]}.blob.core.windows.net/vulnerability-assessment/' : '')
      storageAccountAccessKey: (enableAdvancedDataSecurity ? listKeys(vulnerabilityAssessmentsStorageAccountId, '2019-06-01').keys[0].value : '')
      recurringScans: {
        isEnabled: enableRecuringVulnerabilityAssessmentsScans
        emailSubscriptionAdmins: sendScanReportEmailsToSubscriptionAdmins
        emails: sendScanReportToEmailAddresses
      }
    }
  }

  resource administrators 'administrators@2021-02-01-preview' = if (!empty(azureAdAdmin)) {
    name: 'ActiveDirectory'
    properties: {
      administratorType: 'ActiveDirectory'
      login: azureAdAdmin.login
      sid: azureAdAdmin.sid
      tenantId: azureAdAdmin.tenantId
    }
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

module managedInstance_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: managedInstance.name
  }
}]

output managedInstanceName string = managedInstance.name
output managedInstanceResourceId string = managedInstance.id
output managedInstanceResourceGroup string = resourceGroup().name
