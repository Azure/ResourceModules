@description('Required. Name of the Azure Bastion resource')
param azureBastionName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Shared services Virtual Network resource identifier')
param vNetId string

@description('Optional. Specifies the name of the Public IP used by Azure Bastion. If it\'s not provided, a \'-pip\' suffix will be appended to the Bastion\'s name.')
param azureBastionPipName string = ''

@description('Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIPPrefixId string = ''

@description('Optional. DNS name of the Public IP resource. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com')
param domainNameLabel string = ''

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

@description('Optional. Switch to lock Key Vault from deletion.')
param lockForDeletion bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var publicIPPrefix = {
  id: publicIPPrefixId
}
var diagnosticsMetrics = [
  {
    category: 'AllMetrics'
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var publicIpDiagnosticsLogs = [
  {
    category: 'DDoSProtectionNotifications'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'DDoSMitigationFlowLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'DDoSMitigationReports'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var azureBastionDiagnosticsLogs = [
  {
    category: 'BastionAuditLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Cluster Create': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','a7b1b19a-0e83-4fe5-935c-faaefbfd18c3')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Azure Service Deploy Release Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','21d96096-b162-414a-8302-d8354f9d91b2')
  'CAL-Custom-Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','7b266cd7-0bba-4ae2-8423-90ede5e1e898')
  'ExpressRoute Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','a48d7896-14b4-4889-afef-fbb65a96e5a2')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'masterreader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','a48d7796-14b4-4889-afef-fbb65a93e5a2')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource azureBastionPip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: (empty(azureBastionPipName) ? '${azureBastionName}-pip' : azureBastionPipName)
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPPrefix: ((!empty(publicIPPrefixId)) ? publicIPPrefix : json('null'))
    dnsSettings: ((!empty(domainNameLabel)) ? json('{"domainNameLabel": "${domainNameLabel}"}') : json('null'))
  }
}

resource azureBastionPip_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${azureBastionPip.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: azureBastionPip
}

resource azureBastionPip_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${azureBastionPip.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : publicIpDiagnosticsLogs)
  }
  scope: azureBastionPip
}

resource azureBastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: azureBastionName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: '${vNetId}/subnets/AzureBastionSubnet'
          }
          publicIPAddress: {
            id: azureBastionPip.id
          }
        }
      }
    ]
  }
}

resource azureBastion_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${azureBastion.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: azureBastion
}

resource azureBastion_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${azureBastion.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : azureBastionDiagnosticsLogs)
  }
  scope: azureBastion
}

module azureBastion_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: azureBastion.name
  }
}]

output azureBastionResourceGroup string = resourceGroup().name
output azureBastionName string = azureBastion.name
output azureBastionResourceId string = azureBastion.id
