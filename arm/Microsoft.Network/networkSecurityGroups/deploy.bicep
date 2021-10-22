@description('Required. Name of the Network Security Group.')
param networkSecurityGroupName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param networkSecurityGroupSecurityRules array = []

@description('Optional. If the flow log should be enabled')
param flowLogEnabled bool = false

@description('Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG')
param networkWatcherName string = ''

@description('Optional. If the flow log retention should be enabled')
param retentionEnabled bool = true

@description('Optional. The flow log format version')
@allowed([
  1
  2
])
param logFormatVersion int = 2

@description('Optional. Name of the NSG flow log. If empty, no flow log will be deployed.')
param flowLogName string = ''

@description('Optional. Resource identifier of Log Analytics for the flow logs.')
param flowLogworkspaceId string = ''

@description('Optional. Enables/disables flow analytics. If Flow Analytics was previously enabled, workspaceResourceID is mandatory (even when disabling it)')
param flowAnalyticsEnabled bool = false

@description('Optional. The interval in minutes which would decide how frequently TA service should do flow analytics.')
@allowed([
  10
  60
])
param flowLogIntervalInMinutes int = 60

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

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

@description('Optional. Tags of the NSG resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Resource Group Name of the network watcher in whcih the NSG flow log would be created.')
param networkwatcherResourceGroup string = 'NetworkWatcherRG'

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'NetworkSecurityGroupEvent'
  'NetworkSecurityGroupRuleCounter'
])
param logsToEnable array = [
  'NetworkSecurityGroupEvent'
  'NetworkSecurityGroupRuleCounter'
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

var nsgResourceGroup = resourceGroup().name
var flowLogName_var = ((!empty(flowLogName)) ? '${networkWatcherName}/${flowLogName}' : 'dummy/dummy')
var flowAnalyticsConfig = {
  networkWatcherFlowAnalyticsConfiguration: {
    enabled: flowAnalyticsEnabled
    workspaceResourceId: flowLogworkspaceId
    trafficAnalyticsInterval: flowLogIntervalInMinutes
  }
}

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
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
  'SQL Managed Instance Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  tags: tags
  properties: {
    securityRules: [for nsgSecurityRule in networkSecurityGroupSecurityRules: {
      name: nsgSecurityRule.name
      properties: {
        description: (contains(nsgSecurityRule.properties, 'description') ? nsgSecurityRule.properties.description : '')
        protocol: nsgSecurityRule.properties.protocol
        sourcePortRange: (contains(nsgSecurityRule.properties, 'sourcePortRange') ? nsgSecurityRule.properties.sourcePortRange : '')
        destinationPortRange: (contains(nsgSecurityRule.properties, 'destinationPortRange') ? nsgSecurityRule.properties.destinationPortRange : '')
        sourceAddressPrefix: (contains(nsgSecurityRule.properties, 'sourceAddressPrefix') ? nsgSecurityRule.properties.sourceAddressPrefix : '')
        destinationAddressPrefix: (contains(nsgSecurityRule.properties, 'destinationAddressPrefix') ? nsgSecurityRule.properties.destinationAddressPrefix : '')
        access: nsgSecurityRule.properties.access
        priority: int(nsgSecurityRule.properties.priority)
        direction: nsgSecurityRule.properties.direction
        sourcePortRanges: (contains(nsgSecurityRule.properties, 'sourcePortRanges') ? nsgSecurityRule.properties.sourcePortRanges : json('null'))
        destinationPortRanges: (contains(nsgSecurityRule.properties, 'destinationPortRanges') ? nsgSecurityRule.properties.destinationPortRanges : json('null'))
        sourceAddressPrefixes: (contains(nsgSecurityRule.properties, 'sourceAddressPrefixes') ? nsgSecurityRule.properties.sourceAddressPrefixes : json('null'))
        destinationAddressPrefixes: (contains(nsgSecurityRule.properties, 'destinationAddressPrefixes') ? nsgSecurityRule.properties.destinationAddressPrefixes : json('null'))
        sourceApplicationSecurityGroups: ((contains(nsgSecurityRule.properties, 'sourceApplicationSecurityGroupIds') && (!empty(nsgSecurityRule.properties.sourceApplicationSecurityGroupIds))) ? concat([], array(json('{"id": "${nsgSecurityRule.properties.sourceApplicationSecurityGroupIds[0]}", "location": "${location}"}'))) : json('null'))
        destinationApplicationSecurityGroups: ((contains(nsgSecurityRule.properties, 'destinationApplicationSecurityGroupIds') && (!empty(nsgSecurityRule.properties.destinationApplicationSecurityGroupIds))) ? concat([], array(json('{"id": "${nsgSecurityRule.properties.destinationApplicationSecurityGroupIds[0]}", "location": "${location}"}'))) : json('null'))
      }
    }]
  }
}

resource networkSecurityGroup_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${networkSecurityGroup.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkSecurityGroup
}

resource networkSecurityGroup_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${networkSecurityGroup.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: networkSecurityGroup
}

module networkSecurityGroup_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: networkSecurityGroup.name
  }
}]

module flowLogs './.bicep/nested_flowLogs.bicep' = if (!empty(flowLogName)) {
  name: 'flowLogs'
  scope: resourceGroup(networkwatcherResourceGroup)
  params: {
    location: location
    nsgResourceGroup: nsgResourceGroup
    networkSecurityGroupName: networkSecurityGroup.name
    flowLogName: flowLogName_var
    flowLogEnabled: flowLogEnabled
    retentionEnabled: retentionEnabled
    logFormatVersion: logFormatVersion
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    tags: tags
    flowLogworkspaceId: flowLogworkspaceId
    flowAnalyticsConfig: flowAnalyticsConfig
  }
}

output networkSecurityGroupsResourceGroup string = resourceGroup().name
output networkSecurityGroupsResourceId string = networkSecurityGroup.id
output networkSecurityGroupsName string = networkSecurityGroup.name
output flowLogResourceId string = flowLogs.outputs.flowLogResourceId
output flowLogName string = flowLogs.outputs.flowLogName
