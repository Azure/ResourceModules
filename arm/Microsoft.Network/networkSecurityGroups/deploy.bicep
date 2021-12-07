@description('Required. Name of the Network Security Group.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param networkSecurityGroupSecurityRules array = []

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of log analytics.')
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

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'NetworkSecurityGroupEvent'
  'NetworkSecurityGroupRuleCounter'
])
param logsToEnable array = [
  'NetworkSecurityGroupEvent'
  'NetworkSecurityGroupRuleCounter'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: [for nsgSecurityRule in networkSecurityGroupSecurityRules: {
      name: nsgSecurityRule.name
      properties: {
        description: contains(nsgSecurityRule.properties, 'description') ? nsgSecurityRule.properties.description : ''
        protocol: nsgSecurityRule.properties.protocol
        sourcePortRange: contains(nsgSecurityRule.properties, 'sourcePortRange') ? nsgSecurityRule.properties.sourcePortRange : ''
        destinationPortRange: contains(nsgSecurityRule.properties, 'destinationPortRange') ? nsgSecurityRule.properties.destinationPortRange : ''
        sourceAddressPrefix: contains(nsgSecurityRule.properties, 'sourceAddressPrefix') ? nsgSecurityRule.properties.sourceAddressPrefix : ''
        destinationAddressPrefix: contains(nsgSecurityRule.properties, 'destinationAddressPrefix') ? nsgSecurityRule.properties.destinationAddressPrefix : ''
        access: nsgSecurityRule.properties.access
        priority: int(nsgSecurityRule.properties.priority)
        direction: nsgSecurityRule.properties.direction
        sourcePortRanges: contains(nsgSecurityRule.properties, 'sourcePortRanges') ? nsgSecurityRule.properties.sourcePortRanges : null
        destinationPortRanges: contains(nsgSecurityRule.properties, 'destinationPortRanges') ? nsgSecurityRule.properties.destinationPortRanges : null
        sourceAddressPrefixes: contains(nsgSecurityRule.properties, 'sourceAddressPrefixes') ? nsgSecurityRule.properties.sourceAddressPrefixes : null
        destinationAddressPrefixes: contains(nsgSecurityRule.properties, 'destinationAddressPrefixes') ? nsgSecurityRule.properties.destinationAddressPrefixes : null
        sourceApplicationSecurityGroups: (contains(nsgSecurityRule.properties, 'sourceApplicationSecurityGroupIds') && (!empty(nsgSecurityRule.properties.sourceApplicationSecurityGroupIds))) ? concat([], array(json('{"id": "${nsgSecurityRule.properties.sourceApplicationSecurityGroupIds[0]}", "location": "${location}"}'))) : null
        destinationApplicationSecurityGroups: (contains(nsgSecurityRule.properties, 'destinationApplicationSecurityGroupIds') && (!empty(nsgSecurityRule.properties.destinationApplicationSecurityGroupIds))) ? concat([], array(json('{"id": "${nsgSecurityRule.properties.destinationApplicationSecurityGroupIds[0]}", "location": "${location}"}'))) : null
      }
    }]
  }
}

resource networkSecurityGroup_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${networkSecurityGroup.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkSecurityGroup
}

resource networkSecurityGroup_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName)) {
  name: '${networkSecurityGroup.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(workspaceId) ? null : workspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    logs: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsLogs
  }
  scope: networkSecurityGroup
}

module networkSecurityGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-NSG-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: networkSecurityGroup.id
  }
}]

@description('The resource group the network security group was deployed into')
output networkSecurityGroupResourceGroup string = resourceGroup().name

@description('The resource ID of the network security group')
output networkSecurityGroupResourceId string = networkSecurityGroup.id

@description('The name of the network security group')
output networkSecurityGroupName string = networkSecurityGroup.name
