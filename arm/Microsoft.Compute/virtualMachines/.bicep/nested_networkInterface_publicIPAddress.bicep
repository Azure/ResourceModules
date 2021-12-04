param publicIPAddressName string
param publicIPPrefixId string
param publicIPAllocationMethod string
param skuName string
param skuTier string
param location string
param diagnosticStorageAccountId string
param diagnosticLogsRetentionInDays int
param workspaceId string
param eventHubAuthorizationRuleId string
param eventHubName string
param metricsToEnable array
param logsToEnable array
param lock string
param roleAssignments array
param tags object

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

var publicIPPrefix = {
  id: publicIPPrefixId
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPPrefix: ((!empty(publicIPPrefixId)) ? publicIPPrefix : null)
  }
}

resource publicIpAddress_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${publicIpAddress.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: publicIpAddress
}

resource publicIpAddress_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${publicIpAddress.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? null : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? null : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsLogs)
  }
  scope: publicIpAddress
}

module publicIpAddress_rbac 'nested_networkInterface_publicIPAddress_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: publicIpAddress.id
  }
}]

@description('The name of the Resource Group the public IP address was deployed.')
output publicIPAddressResourceGroup string = resourceGroup().name
@description('The name of the public IP address.')
output publicIPAddressName string = publicIpAddress.name
@description('The Resource ID of the public IP address.')
output publicIPAddressResourceId string = publicIpAddress.id
