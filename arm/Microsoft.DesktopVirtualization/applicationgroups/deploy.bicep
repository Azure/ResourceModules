@description('Required. Name of the Application Group to create this application in.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The type of the Application Group to be created. Allowed values: RemoteApp or Desktop')
@allowed([
  'RemoteApp'
  'Desktop'
])
param appGroupType string

@description('Required. Name of the Host Pool to be linked to this Application Group.')
param hostpoolName string

@description('Optional. The friendly name of the Application Group to be created.')
param friendlyName string = ''

@description('Optional. The description of the Application Group to be created.')
param appGroupDescription string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

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

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'Checkpoint'
  'Error'
  'Management'
])
param logsToEnable array = [
  'Checkpoint'
  'Error'
  'Management'
]

@description('Optional. List of applications to be created in the Application Group.')
param applications array = []

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

resource appGroup_hostpool 'Microsoft.DesktopVirtualization/hostpools@2021-07-12' existing = {
  name: hostpoolName
}

resource appGroup 'Microsoft.DesktopVirtualization/applicationgroups@2021-07-12' = {
  name: name
  location: location
  tags: tags
  properties: {
    hostPoolArmPath: appGroup_hostpool.id
    friendlyName: friendlyName
    description: appGroupDescription
    applicationGroupType: appGroupType
  }
}

resource appGroup_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${appGroup.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: appGroup
}

resource appGroup_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${appGroup.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: appGroup
}

module appGroup_applications 'applications/deploy.bicep' = [for (application, index) in applications: {
  name: '${uniqueString(deployment().name, location)}-application-${index}'
  params: {
    name: application.name
    appGroupName: appGroup.name
    appDescription: application.description
    friendlyName: application.friendlyName
    filePath: application.filePath
    commandLineSetting: application.commandLineSetting
    commandLineArguments: application.commandLineArguments
    showInPortal: application.showInPortal
    iconPath: application.iconPath
    iconIndex: application.iconIndez
  }
}]

module appGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: appGroup.name
  }
}]

output appGroupResourceId string = appGroup.id
output appGroupResourceGroup string = resourceGroup().name
output appGroupName string = appGroup.name
