@description('Required. Name of the Azure Bastion resource')
param natGatewayName string

@description('Optional. The idle timeout of the nat gateway.')
param idleTimeoutInMinutes int = 5

@description('Optional. Use to have a new Public IP Address created for the NAT Gateway.')
param natGatewayPublicIpAddress bool = false

@description('Optional. Specifies the name of the Public IP used by the NAT Gateway. If it\'s not provided, a \'-pip\' suffix will be appended to the Bastion\'s name.')
param natGatewayPipName string = ''

@description('Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param natGatewayPublicIPPrefixId string = ''

@description('Optional. DNS name of the Public IP resource. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com')
param natGatewayDomainNameLabel string = ''

@description('Optional. Existing Public IP Address resource names to use for the NAT Gateway.')
param publicIpAddresses array = []

@description('Optional. Existing Public IP Prefixes resource names to use for the NAT Gateway.')
param publicIpPrefixes array = []

@description('Optional. A list of availability zones denoting the zone in which Nat Gateway should be deployed.')
param zones array = []

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@description('Optional. Switch to lock resource from deletion.')
param lockForDeletion bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags for the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
])
param logsToEnable array = [
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
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

var natGatewayPipName_var = (empty(natGatewayPipName) ? '${natGatewayName}-pip' : natGatewayPipName)
var natGatewayPublicIPPrefix = {
  id: natGatewayPublicIPPrefixId
}

var natGatewayPropertyPublicIPPrefixes = [for publicIpPrefix in publicIpPrefixes: {
  id: resourceId('Microsoft.Network/publicIPPrefixes', publicIpPrefix)
}]
var natGatewayPropertyPublicIPAddresses = [for publicIpAddress in publicIpAddresses: {
  id: resourceId('Microsoft.Network/publicIPAddresses', publicIpAddress)
}]
var natGatewayProperties = {
  idleTimeoutInMinutes: idleTimeoutInMinutes
  publicIpPrefixes: natGatewayPropertyPublicIPPrefixes
  publicIpAddresses: natGatewayPropertyPublicIPAddresses
}
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

// PUBLIC IP
// =========
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = if (natGatewayPublicIpAddress) {
  name: natGatewayPipName_var
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPPrefix: ((!empty(natGatewayPublicIPPrefixId)) ? natGatewayPublicIPPrefix : json('null'))
    dnsSettings: ((!empty(natGatewayDomainNameLabel)) ? json('{"domainNameLabel": "${natGatewayDomainNameLabel}"}') : json('null'))
  }
}

resource publicIP_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion && natGatewayPublicIpAddress) {
  name: '${publicIP.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: publicIP
}

resource publicIP_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${publicIP.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: publicIP
}

// NAT GATEWAY
// ===========
resource natGateway 'Microsoft.Network/natGateways@2021-02-01' = {
  name: natGatewayName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: natGatewayProperties
  zones: zones
}

resource natGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${natGateway.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: natGateway
}

module natGateway_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: natGateway.name
  }
}]

output natGatewayName string = natGateway.name
output natGatewayResourceId string = natGateway.id
output natGatewayResourceGroup string = resourceGroup().name
