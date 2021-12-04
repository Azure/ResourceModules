@description('Required. Name of the Network Watcher resource (hidden)')
@minLength(1)
param name string = 'NetworkWatcher_${location}'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array that contains the Connection Monitors')
param connectionMonitors array = []

@description('Optional. Array that contains the Flow Logs')
param flowLogs array = []

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

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource networkWatcher_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${networkWatcher.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkWatcher
}

module networkWatcher_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-NW-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: networkWatcher.id
  }
}]

module networkWatcher_connectionMonitors 'connectionMonitors/deploy.bicep' = [for (connectionMonitor, index) in connectionMonitors: {
  name: '${uniqueString(deployment().name, location)}-NW-ConnectionMonitor-${index}'
  params: {
    endpoints: contains(connectionMonitor, 'endpoints') ? connectionMonitor.endpoints : []
    name: connectionMonitor.name
    networkWatcherName: networkWatcher.name
    testConfigurations: contains(connectionMonitor, 'testConfigurations') ? connectionMonitor.testConfigurations : []
    testGroups: contains(connectionMonitor, 'testGroups') ? connectionMonitor.testGroups : []
    workspaceResourceId: contains(connectionMonitor, 'workspaceResourceId') ? connectionMonitor.workspaceResourceId : ''
  }
}]

module networkWatcher_flowLogs 'flowLogs/deploy.bicep' = [for (flowLog, index) in flowLogs: {
  name: '${uniqueString(deployment().name, location)}-NW-FlowLog-${index}'
  params: {
    enabled: contains(flowLog, 'enabled') ? flowLog.enabled : true
    formatVersion: contains(flowLog, 'formatVersion') ? flowLog.formatVersion : 2
    location: contains(flowLog, 'location') ? flowLog.location : location
    name: contains(flowLog, 'name') ? flowLog.name : '${last(split(flowLog.targetResourceId, '/'))}-${split(flowLog.targetResourceId, '/')[4]}-flowlog'
    networkWatcherName: networkWatcher.name
    retentionInDays: contains(flowLog, 'retentionInDays') ? flowLog.retentionInDays : 365
    storageId: flowLog.storageId
    targetResourceId: flowLog.targetResourceId
    trafficAnalyticsInterval: contains(flowLog, 'trafficAnalyticsInterval') ? flowLog.trafficAnalyticsInterval : 60
    workspaceResourceId: contains(flowLog, 'workspaceResourceId') ? flowLog.workspaceResourceId : ''
  }
}]

@description('The name of the deployed network watcher')
output networkWatcherName string = networkWatcher.name

@description('The resource ID of the deployed network watcher')
output networkWatcherResourceId string = networkWatcher.id

@description('The resource group the network watcher was deployed into')
output networkWatcherResourceGroup string = resourceGroup().name
