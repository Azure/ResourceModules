@sys.description('Required. Name of the scaling plan.')
@minLength(1)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Friendly Name of the scaling plan.')
param friendlyName string = name

@sys.description('Optional. Description of the scaling plan.')
param description string = name

@sys.description('Optional. Timezone to be used for the scaling plan.')
param timeZone string = 'W. Europe Standard Time'

@allowed([
  'Pooled'
])
@sys.description('Optional. The type of hostpool where this scaling plan should be applied.')
param hostPoolType string = 'Pooled'

@sys.description('Optional. Provide a tag to be used for hosts that should not be affected by the scaling plan.')
param exclusionTag string = ''

@sys.description('Optional. The schedules related to this scaling plan. If no value is provided a default schedule will be provided.')
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

@sys.description('Optional. An array of references to hostpools.')
param hostPoolReferences array = []

@sys.description('Optional. Tags of the resource.')
param tags object = {}

@sys.description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@sys.description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@sys.description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@sys.description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@sys.description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'Autoscale'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource scalingPlan 'Microsoft.DesktopVirtualization/scalingPlans@2022-09-09' = {
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
    description: description
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
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: scalingPlan.id
  }
}]

@sys.description('The resource ID of the AVD scaling plan.')
output resourceId string = scalingPlan.id

@sys.description('The resource group the AVD scaling plan was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the AVD scaling plan.')
output name string = scalingPlan.name

@sys.description('The location the resource was deployed into.')
output location string = scalingPlan.location
