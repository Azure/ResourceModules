@description('Required. Name of the Network Watcher resource (hidden)')
@minLength(1)
param networkWatcherName string = 'NetworkWatcher_${location}'

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

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-02-01' = {
  name: networkWatcherName
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
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: networkWatcher.name
  }
}]

module networkWatcher_connectionMonitors 'connectionMonitors/deploy.bicep' = [for connectionMonitor in connectionMonitors: {
  name: connectionMonitor.name
  params: {
    networkWatcherName: networkWatcher.name
    name: connectionMonitor.name
    endpoints: contains(connectionMonitor, 'endpoints') ? connectionMonitor.endpoints : null
    testConfigurations: contains(connectionMonitor, 'testConfigurations') ? connectionMonitor.testConfigurations : null
    testGroups: contains(connectionMonitor, 'testGroups') ? connectionMonitor.testGroups : null
    workspaceResourceId: contains(connectionMonitor, 'workspaceResourceId') ? connectionMonitor.workspaceResourceId : null
  }
}]

module networkWatcher_flowLogs 'flowLogs/deploy.bicep' = [for (flowLog, index) in flowLogs: {
  name: '${deployment().name}-flowLog-${index}'
  params: {
    networkWatcherName: networkWatcher.name
    name: contains(flowLog, 'name') ? flowLog.name : null
    storageId: flowLog.storageId
    targetResourceId: flowLog.targetResourceId
    formatVersion: contains(flowLog, 'formatVersion') ? flowLog.formatVersion : null
    enabled: contains(flowLog, 'enabled') ? flowLog.enabled : null
    retentionInDays: contains(flowLog, 'retentionInDays') ? flowLog.retentionInDays : null
    trafficAnalyticsInterval: contains(flowLog, 'trafficAnalyticsInterval') ? flowLog.trafficAnalyticsInterval : null
    workspaceResourceId: contains(flowLog, 'workspaceResourceId') ? flowLog.workspaceResourceId : null
  }
}]

@description('The name of the deployed network watcher')
output networkWatcherName string = networkWatcher.name

@description('The resourceId of the deployed network watcher')
output networkWatcherResourceId string = networkWatcher.id

@description('The resource group the network watcher was deployed into')
output networkWatcherResourceGroup string = resourceGroup().name
