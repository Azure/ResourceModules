@description('Optional. The name of the AADDS resource. Defaults to the domain name specific to the Azure ADDS service.')
param name string = domainName

@description('Required. The domain name specific to the Azure ADDS service.')
param domainName string

@description('Optional. The name of the SKU specific to Azure ADDS Services.')
@allowed([
  'Standard'
  'Enterprise'
  'Premium'
])
param sku string = 'Standard'

@description('Optional. The location to deploy the Azure ADDS Services.')
param location string = resourceGroup().location

@description('Optional. Additional replica set for the managed domain.')
param replicaSets array = []

@description('Conditional. The certificate required to configure Secure LDAP. Should be a base64encoded representation of the certificate PFX file. Required if secure LDAP is enabled and must be valid more than 30 days.')
param pfxCertificate string = ''

@description('Conditional. The password to decrypt the provided Secure LDAP certificate PFX file. Required if secure LDAP is enabled.')
@secure()
param pfxCertificatePassword string = ''

@description('Optional. The email recipient value to receive alerts.')
param additionalRecipients array = []

@description('Optional. The value is to provide domain configuration type.')
@allowed([
  'FullySynced'
  'ResourceTrusting'
])
param domainConfigurationType string = 'FullySynced'

@description('Optional. The value is to synchronise scoped users and groups.')
param filteredSync string = 'Enabled'

@description('Optional. The value is to enable clients making request using TLSv1.')
@allowed([
  'Enabled'
  'Disabled'
])
param tlsV1 string = 'Enabled'

@description('Optional. The value is to enable clients making request using NTLM v1.')
@allowed([
  'Enabled'
  'Disabled'
])
param ntlmV1 string = 'Enabled'

@description('Optional. The value is to enable synchronized users to use NTLM authentication.')
@allowed([
  'Enabled'
  'Disabled'
])
param syncNtlmPasswords string = 'Enabled'

@description('Optional. The value is to enable on-premises users to authenticate against managed domain.')
@allowed([
  'Enabled'
  'Disabled'
])
param syncOnPremPasswords string = 'Enabled'

@description('Optional. The value is to enable Kerberos requests that use RC4 encryption.')
@allowed([
  'Enabled'
  'Disabled'
])
param kerberosRc4Encryption string = 'Enabled'

@description('Optional. The value is to enable to provide a protected channel between the Kerberos client and the KDC.')
@allowed([
  'Enabled'
  'Disabled'
])
param kerberosArmoring string = 'Enabled'

@description('Optional. The value is to notify the DC Admins.')
@allowed([
  'Enabled'
  'Disabled'
])
param notifyDcAdmins string = 'Enabled'

@description('Optional. The value is to notify the Global Admins.')
@allowed([
  'Enabled'
  'Disabled'
])
param notifyGlobalAdmins string = 'Enabled'

@description('Optional. The value is to enable the Secure LDAP for external services of Azure ADDS Services.')
@allowed([
  'Enabled'
  'Disabled'
])
param externalAccess string = 'Enabled'

@description('Optional. A flag to determine whether or not Secure LDAP is enabled or disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param ldaps string = 'Enabled'

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'SystemSecurity'
  'AccountManagement'
  'LogonLogoff'
  'ObjectAccess'
  'PolicyChange'
  'PrivilegeUse'
  'DetailTracking'
  'DirectoryServiceAccess'
  'AccountLogon'
])
param logsToEnable array = [
  'SystemSecurity'
  'AccountManagement'
  'LogonLogoff'
  'ObjectAccess'
  'PolicyChange'
  'PrivilegeUse'
  'DetailTracking'
  'DirectoryServiceAccess'
  'AccountLogon'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource domainService 'Microsoft.AAD/DomainServices@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    domainName: domainName
    domainConfigurationType: domainConfigurationType
    filteredSync: filteredSync
    notificationSettings: {
      additionalRecipients: additionalRecipients
      notifyDcAdmins: notifyDcAdmins
      notifyGlobalAdmins: notifyGlobalAdmins
    }
    ldapsSettings: {
      externalAccess: externalAccess
      ldaps: ldaps
      pfxCertificate: !empty(pfxCertificate) ? pfxCertificate : null
      pfxCertificatePassword: !empty(pfxCertificatePassword) ? pfxCertificatePassword : null
    }
    replicaSets: replicaSets
    domainSecuritySettings: {
      tlsV1: tlsV1
      ntlmV1: ntlmV1
      syncNtlmPasswords: syncNtlmPasswords
      syncOnPremPasswords: syncOnPremPasswords
      kerberosRc4Encryption: kerberosRc4Encryption
      kerberosArmoring: kerberosArmoring
    }
    sku: sku
  }
}

resource domainService_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${domainService.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: domainService
}

resource domainService_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${domainService.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: domainService
}

module domainService_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VNet-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: domainService.id
  }
}]

@description('The domain name of the Azure Active Directory Domain Services(Azure ADDS).')
output name string = domainService.name

@description('The name of the resource group the Azure Active Directory Domain Services(Azure ADDS) was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Azure Active Directory Domain Services(Azure ADDS).')
output resourceId string = domainService.id

@description('The location the resource was deployed into.')
output location string = domainService.location
