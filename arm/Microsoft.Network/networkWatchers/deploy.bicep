@description('Required. Name of the Network Watcher resource (hidden)')
@minLength(1)
param networkWatcherName string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array that contains the monitors')
param monitors array = []

@description('Optional. Specify the Workspace Resource ID')
param workspaceResourceId string = ''

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

var outputs = [
  {
    type: 'Workspace'
    workspaceSettings: {
      workspaceResourceId: workspaceResourceId
    }
  }
]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-02-01' = {
  location: location
  name: networkWatcherName
  properties: {}

  resource connectionMonitors 'connectionMonitors@2021-02-01' = [for monitor in monitors: if (!empty(monitors)) {
    name: (empty(monitors) ? 'dummy/dummy' : '${networkWatcher.name}/${monitor.connectionMonitorName}')
    location: location
    tags: tags
    properties: {
      endpoints: (empty(monitors) ? json('null') : monitor.endpoints)
      testConfigurations: (empty(monitors) ? json('null') : monitor.testConfigurations)
      testGroups: (empty(monitors) ? json('null') : monitor.testGroups)
      outputs: (empty(workspaceResourceId) ? json('null') : outputs)
    }
  }]
}

resource networkWatcher_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${networkWatcher.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
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

output networkWatcherResourceGroup string = resourceGroup().name
output networkWatcherResourceId string = networkWatcher.id
output networkWatcherName string = networkWatcher.name
