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
// param skuTier string
param location string
// param diagnosticLogsRetentionInDays int
// param diagnosticStorageAccountId string
// param workspaceId string
// param eventHubAuthorizationRuleId string
// param eventHubName string
// param lockForDeletion bool
// param roleAssignments array
param tags object

// var diagnosticsMetrics = [
//   {
//     category: 'AllMetrics'
//     timeGrain: null
//     enabled: true
//     retentionPolicy: {
//       enabled: true
//       days: diagnosticLogsRetentionInDays
//     }
//   }
// ]

// var diagnosticsLogs = [
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

var publicIPPrefix = {
  id: publicIPPrefixId
}

// var builtInRoleNames = {
//   'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
//   'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
//   'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
//   'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
//   'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
//   'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
//   'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
//   'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
//   'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
//   'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
//   'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
//   'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
//   'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
//   'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
//   'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
//   'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
//   'Virtual Machine Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c0163c0-47e6-4577-8991-ea5c82e286e4')
//   'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
//   'Virtual Machine User Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb879df8-f326-4884-b1cf-06f3ad86be52')
// }

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIPAddressName
  location: location
  tags: tags
  sku: {
    name: skuName
    // tier: skuTier
  }
  properties: {
    // publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPPrefix: ((!empty(publicIPPrefixId)) ? publicIPPrefix : json('null'))
    // idleTimeoutInMinutes: 4
    // ipTags: []
  }
}

// resource publicIpAddress_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
//   name: '${publicIpAddress.name}-doNotDelete'
//   properties: {
//     level: 'CanNotDelete'
//   }
//   scope: publicIpAddress
// }

// resource publicIpAddress_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
//   name: '${publicIpAddress.name}-diagnosticSettings'
//   properties: {
//     storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
//     workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
//     eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
//     eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
//     metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
//     logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
//   }
//   scope: publicIpAddress
// }

// module publicIpAddress_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
//   name: 'rbac-${deployment().name}${index}'
//   params: {
//     roleAssignmentObj: roleAssignment
//     builtInRoleNames: builtInRoleNames
//     resourceName: publicIpAddress.name
//   }
// }]

output publicIPAddressResourceGroup string = resourceGroup().name
output publicIPAddressName string = publicIpAddress.name
output publicIPAddressResourceId string = publicIpAddress.id
