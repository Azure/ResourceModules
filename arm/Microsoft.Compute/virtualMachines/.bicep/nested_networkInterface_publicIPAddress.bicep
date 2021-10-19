// nested_nicConfigurations_1_vmName_nicConfigurations_0_nicSuffix_nicConfigurations_0_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop_dummyVmNicPipConfigLoop
// // param location string
// // param tags object
// // param vmName string
// // param ipConfiguration object
// // param lockForDeletion bool
// // param diagnosticSettingName string
// // param diagnosticStorageAccountId string
// // param workspaceId string
// // param eventHubAuthorizationRuleId string
// // param eventHubName string
// // param diagnosticsMetrics array
// // param diagnosticLogsRetentionInDays int

// // var publicIPAddressName = (contains(ipConfiguration, 'publicIpNameSuffix') ? concat(vmName, ipConfiguration.publicIpNameSuffix) : 'dummyPipName')
// var pipDiagnosticsLogs = [
//   {
//     category: 'DDoSProtectionNotifications'
//     enabled: true
//     retentionPolicy: {
//       enabled: true
//       days: diagnosticLogsRetentionInDays
//     }
//   }
//   {
//     category: 'DDoSMitigationFlowLogs'
//     enabled: true
//     retentionPolicy: {
//       enabled: true
//       days: diagnosticLogsRetentionInDays
//     }
//   }
//   {
//     category: 'DDoSMitigationReports'
//     enabled: true
//     retentionPolicy: {
//       enabled: true
//       days: diagnosticLogsRetentionInDays
//     }
//   }
// ]

// // resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2020-08-01' = if (contains(ipConfiguration, 'enablePublicIP') && ipConfiguration.enablePublicIP) {
// //   name: publicIPAddressName
// //   location: location
// //   tags: tags
// //   sku: {
// //     name: 'Standard'
// //   }
// //   properties: {
// //     publicIPAllocationMethod: 'Static'
// //     publicIPPrefix: (contains(ipConfiguration, 'publicIPPrefixId') ? ((!empty(ipConfiguration.publicIPPrefixId)) ? json('{"id": "${ipConfiguration.publicIPPrefixId}"}') : json('null')) : json('null'))
// //   }
// //   zones: json('null')
// // }

// resource pipName_Microsoft_Authorization_publicIpDoNotDelete 'Microsoft.Network/publicIPAddresses/providers/locks@2016-09-01' = if (contains(ipConfiguration, 'enablePublicIP') && ipConfiguration.enablePublicIP) {
//   name: '${pipName_var}/Microsoft.Authorization/publicIpDoNotDelete'
//   properties: {
//     level: 'CannotDelete'
//   }
//   dependsOn: [
//     pipName
//   ]
// }

// resource pipName_Microsoft_Insights_diagnosticSettingName 'Microsoft.Network/publicIPAddresses/providers/diagnosticSettings@2017-05-01-preview' = if (contains(ipConfiguration, 'enablePublicIP') && ipConfiguration.enablePublicIP) {
//   location: location
//   tags: tags
//   name: '${pipName_var}/Microsoft.Insights/${diagnosticSettingName}'
//   properties: {
//     storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
//     workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
//     eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
//     eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
//     metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
//     logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : pipDiagnosticsLogs)
//   }
//   dependsOn: [
//     pipName
//   ]
// }

// nested_networkInterface_publicIPAddress_rbac

// param cuaId string
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
param builtInRoleNames object
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

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIPAddressName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPPrefix: ((!empty(publicIPPrefixId)) ? publicIPPrefix : json('null'))
  }
}

resource publicIpAddress_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${publicIpAddress.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: publicIpAddress
}

resource publicIpAddress_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${publicIpAddress.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: publicIpAddress
}

module publicIpAddress_rbac './nested_networkInterface_publicIPAddress_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: publicIpAddress.name
  }
}]

output publicIPAddressResourceGroup string = resourceGroup().name
output publicIPAddressName string = publicIpAddress.name
output publicIPAddressResourceId string = publicIpAddress.id
