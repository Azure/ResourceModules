@description('Required. Name of the scaling plan')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Friendly Name of the scaling plan')
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

// scalingPlan
resource scalingPlan 'Microsoft.DesktopVirtualization/scalingPlans@2022-02-10-preview' = {
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

@description('Optional. Enable logging to loganalytics.')
param enableLogging bool = false

@description('Optional. SubscriptionId where the loganalytics workspace is located.')
param logworkspaceSubscriptionId string = 'ce3aa15d-c8a9-4aaa-9d99-df14cf94010d'

@description('Optional. ResourcegroupName where the loganalytics workspace is located.')
param logworkspaceResourceGroup string = 'analytics-prod-rg'

@description('Optional. Name of the loganalytics workspace.')
param logworkspaceName string = 'mgmt-prod-nore-la'

resource logworkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (enableLogging) {
  name: logworkspaceName
  scope: resourceGroup(logworkspaceSubscriptionId, logworkspaceResourceGroup)
}

resource scalingPlanDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableLogging) {
  scope: scalingPlan
  name: 'scalingDiagnostics'
  properties: {
    workspaceId: logworkspace.id
    logs: [
      {
        category: 'Autoscale'
        enabled: true
      }
    ]
  }
}

@description('The resource ID of the AVD scaling plan')
output resourceId string = scalingPlan.id

@description('The resource group the AVD scaling plan was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name of the AVD scaling plan')
output name string = scalingPlan.name
