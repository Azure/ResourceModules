@description('Required: The domain name specific to Azure ADDS Services only - not recommended to use <<domain>>.onmicrosoft.com for production')
param domainName string

@description('Required: The name of the sku specific to Azure ADDS Services - Standard is the default')
param sku string

@description('Required: The subnet Id to deploy the Azure ADDS Services')
param subnetId string

@description('Required: The location to deploy the Azure ADDS Services')
param location string

@description('Required: The value is the base64encoded representation of the certificate pfx file')
param pfxCertificate string

@description('Required: The value is to decrypt the provided Secure LDAP certificate pfx file')
@secure()
param pfxCertificatePassword string

@description('Required: The email recipient value to receive alerts')
param additionalRecipients string

@description('Optional: The value is to provide domain configuration type')
var domainConfigurationType = 'FullySynced'

@description('Optional: The value is to synchronise scoped users and groups - This is enabled by default')
var filteredSync = 'Enabled'

@description('Optional: The value is to enable clients making request using TLSv1 - This is enabled by default')
var tlsV1 = 'Enabled'

@description('Optional: The value is to enable clients making request using NTLM v1 - This is enabled by default')
var ntlmV1 = 'Enabled'

@description('Optional: The value is to enable synchronised users to use NTLM authentication - This is enabled by default')
var syncNtlmPasswords = 'Enabled'

@description('Optional: The value is to enable on-premises users to authenticate against managed domain - This is enabled by default')
var syncOnPremPasswords = 'Enabled'

@description('Optional: The value is to enable Kerberos requests that use RC4 encryption - This is enabled by default')
var kerberosRc4Encryption = 'Enabled'

@description('Optional: The value is to enable to provide a protected channel between the Kerberos client and the KDC - This is enabled by default')
var kerberosArmoring = 'Enabled'

@description('Optional: The value is to notify the DC Admins - This is enabled by default ')
var notifyDcAdmins = 'Enabled'

@description('Optional: The value is to notify the Global Admins - This is enabled by default')
var notifyGlobalAdmins = 'Enabled'

@description('Required: The value is to enable the Secure LDAP for external services of Azure ADDS Services')
var ldapexternalaccess = 'Enabled'

@description('Required: The value is to enable the Secure LDAP for Azure ADDS Services')
var secureldap = 'Enabled'

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

resource domainName_resource 'Microsoft.AAD/DomainServices@2021-05-01' = {
  name: domainName
  location: location
  tags: tags
  properties: {
    domainName: domainName
    domainConfigurationType: domainConfigurationType
    filteredSync: filteredSync
    notificationSettings: {
      additionalRecipients: [
        additionalRecipients
      ]
      notifyDcAdmins: notifyDcAdmins
      notifyGlobalAdmins: notifyGlobalAdmins
    }
    ldapsSettings: {
      externalAccess: ldapexternalaccess
      ldaps: secureldap
      pfxCertificate: pfxCertificate
      pfxCertificatePassword: pfxCertificatePassword
    }
    replicaSets: [
      {
        location: location
        subnetId: subnetId
      }
    ]
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

resource logAnalyticsWorkspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${domainName}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: domainName_resource
}
