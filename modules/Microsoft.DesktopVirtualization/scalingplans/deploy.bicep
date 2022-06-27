@description('Required. Name of the scaling plan.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Friendly Name of the scaling plan.')
param friendlyName string = name

@description('Optional. Description of the scaling plan.')
param scalingplanDescription string = name

@description('Optional. Timezone to be used for the scaling plan.')
param timeZone string = 'W. Europe Standard Time'

@allowed([
  'Pooled'
])
@description('Optional. The type of hostpool where this scaling plan should be applied.')
param hostPoolType string = 'Pooled'

@description('Optional. Provide a tag to be used for hosts that should not be affected by the scaling plan.')
param exclusionTag string = ''

@description('Optional. The schedules related to this scaling plan. If no value is provided a default schedule will be provided.')
param schedules array = [
  {
    rampUpStartTime: {
      hour: 7
      minute: 0
    }
    peakStartTime: {
      hour: 9
      minute: 0
    }
    rampDownStartTime: {
      hour: 18
      minute: 0
    }
    offPeakStartTime: {
      hour: 20
      minute: 0
    }
    name: 'weekdays_schedule'
    daysOfWeek: [
      'Monday'
      'Tuesday'
      'Wednesday'
      'Thursday'
      'Friday'
    ]
    rampUpLoadBalancingAlgorithm: 'DepthFirst'
    rampUpMinimumHostsPct: 20
    rampUpCapacityThresholdPct: 60
    peakLoadBalancingAlgorithm: 'DepthFirst'
    rampDownLoadBalancingAlgorithm: 'DepthFirst'
    rampDownMinimumHostsPct: 10
    rampDownCapacityThresholdPct: 90
    rampDownForceLogoffUsers: true
    rampDownWaitTimeMinutes: 30
    rampDownNotificationMessage: 'You will be logged off in 30 min. Make sure to save your work.'
    rampDownStopHostsWhen: 'ZeroSessions'
    offPeakLoadBalancingAlgorithm: 'DepthFirst'
  }
]

@description('Optional. An array of references to hostpools.')
param hostPoolReferences array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'Autoscale'
])
param logsToEnable array = [
  'Autoscale'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource scalingPlan 'Microsoft.DesktopVirtualization/scalingPlans@2021-09-03-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    friendlyName: friendlyName
    timeZone: timeZone
    hostPoolType: hostPoolType
    exclusionTag: exclusionTag
    schedules: schedules
    hostPoolReferences: hostPoolReferences
    description: scalingplanDescription
  }
}

resource scalingplan_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${scalingPlan.name}-diagnosticsetting'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: scalingPlan
}

module scalingplan_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Workspace-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: scalingPlan.id
  }
}]

@description('The resource ID of the AVD scaling plan.')
output resourceId string = scalingPlan.id

@description('The resource group the AVD scaling plan was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the AVD scaling plan.')
output name string = scalingPlan.name

@description('The location the resource was deployed into.')
output location string = scalingPlan.location
