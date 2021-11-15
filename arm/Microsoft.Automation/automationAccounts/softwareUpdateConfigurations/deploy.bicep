@description('Required. The name of the Deployment schedule.')
param name string

@description('Required. Name of the parent Automation Account')
param parent string

@description('Required. The operating system to be configured by the deployment schedule.')
@allowed([
  'Windows'
  'Linux'
])
param operatingSystem string

@description('Required. Reboot setting for the deployment schedule.')
@allowed([
  'IfRequired'
  'Never'
  'RebootOnly'
  'Always'
])
param rebootSetting string

@description('Required. The frequency of the deployment schedule. When using \'Hour\', \'Day\', \'Week\' or \'Month\', an interval needs to be provided.')
@allowed([
  'OneTime'
  'Hour'
  'Day'
  'Week'
  'Month'
])
param frequency string

@description('Optional. Maximum time allowed for the deployment schedule to run. Duration needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601')
param maintenanceWindow string = 'PT2H'

@description('Optional. Update classification included in the deployment schedule.')
@allowed([
  'Critical'
  'Security'
  'UpdateRollup'
  'FeaturePack'
  'ServicePack'
  'Definition'
  'Tools'
  'Updates'
  'Other'
])
param updateClassifications array = [
  'Critical'
  'Security'
]

@description('Optional. KB numbers or Linux packages excluded in the deployment schedule.')
param excludeUpdates array = []

@description('Optional. KB numbers or Linux packages included in the deployment schedule.')
param includeUpdates array = []

@description('Optional. Specify the resources to scope the deployment schedule to.')
param scopeByResources array = [
  subscription().id
]

@description('Optional. Specify tags to which to scope the deployment schedule to.')
param scopeByTags object = {}

@description('Optional. Enables the scopeByTags to require All (Tag A and Tag B) or Any (Tag A or Tag B).')
@allowed([
  'All'
  'Any'
])
param scopeByTagsOperation string = 'All'

@description('Optional. Specify locations to which to scope the deployment schedule to.')
param scopeByLocations array = []

@description('Optional. Parameters provided to the task running before the deployment schedule.')
param preTaskParameters object = {}

@description('Optional. The source of the task running before the deployment schedule.')
param preTaskSource string = ''

@description('Optional. Parameters provided to the task running after the deployment schedule.')
param postTaskParameters object = {}

@description('Optional. The source of the task running after the deployment schedule.')
param postTaskSource string = ''

@description('Optional. The interval of the frequency for the deployment schedule. 1 Hour is every hour, 2 Day is every second day, etc.')
@maxValue(100)
param interval int = 1

@description('Optional. Enables the deployment schedule.')
param isEnabled bool = true

@description('Optional. Time zone for the deployment schedule. IANA ID or a Windows Time Zone ID.')
param timeZone string = 'UTC'

@description('Optional. Array of functions from a Log Analytics workspace, used to scope the deployment schedule.')
param nonAzureQueries array = []

@description('Optional. List of azure resource Ids for azure virtual machines in scope for the deployment schedule.')
param azureVirtualMachines array = []

@description('Optional. List of names of non-azure machines in scope for the deployment schedule.')
param nonAzureComputerNames array = []

@description('Optional. Required when used with frequency \'Week\'. Specified the day of the week to run the deployment schedule.')
@allowed([
  'Monday'
  'Tuesday'
  'Wednesday'
  'Thursday'
  'Friday'
  'Saturday'
  'Sunday'
])
param weekDays array = []

@description('Optional. Can be used with frequency \'Month\'. Provides the specific days of the month to run the deployment schedule.')
@allowed([
  1
  2
  3
  4
  5
  6
  7
  8
  9
  10
  11
  12
  13
  14
  15
  16
  17
  18
  19
  20
  21
  22
  23
  24
  25
  26
  27
  28
  29
  30
  31
])
param monthDays array = []

@description('Optional. Can be used with frequency \'Month\'. Provides the pattern/cadence for running the deployment schedule in a month. Takes objects formed like this {occurance(int),day(string)}. Day is the name of the day to run the deployment schedule, the occurance specifies which occurance of that day to run the deployment schedule.')
param monthlyOccurrences array = []

@description('Optional. The start time of the deployment schedule in ISO 8601 format. To specify a specific time use YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. For schedules where we want to start the deployment as soon as possible, specify the time segment only in 24 hour format, HH:MM, 22:00.')
param startTime string = ''

@description('Optional. The end time of the deployment schedule in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00')
param expiryTime string = ''

@description('Optional. The expiry time\'s offset in minutes.')
param expiryTimeOffsetMinutes int = 0

@description('Optional. The next run time of the deployment schedule in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00')
param nextRun string = ''

@description('Optional. The next run time\'s offset in minutes.')
param nextRunOffsetMinutes int = 0

@description('Optional. The schedules description.')
param scheduleDescription string = ''

@description('Generated. Do not touch. Is used to provide the base time for time comparison for startTime. If startTime is specified in HH:MM format, baseTime is used to check if the provided startTime has passed, adding one day before setting the deployment schedule.')
param baseTime string = utcNow('u')

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var updateClassifications_var = '${replace(replace(replace(replace(string(updateClassifications), ',', ', '), '[', ''), ']', ''), '"', '')}'

// var timeLimit = dateTimeAdd(baseTime, 'PT5M', 'u')

// var providedStartTime = dateTimeAdd(startTime, 'PT0S', 'u')

// var startTime_var = providedStartTime > timeLimit ? providedStartTime : dateTimeAdd(providedStartTime, 'P1D', 'u')

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource softwareUpdateConfiguration_automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' existing = {
  name: parent
}

resource softwareUpdateConfiguration 'Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01' = {
  name: name
  parent: softwareUpdateConfiguration_automationAccount
  properties: {
    updateConfiguration: {
      operatingSystem: operatingSystem
      duration: maintenanceWindow
      linux: ((operatingSystem == 'Linux') ? {
        excludedPackageNameMasks: excludeUpdates
        includedPackageNameMasks: includeUpdates
        includedPackageClassifications: updateClassifications_var
        rebootSetting: rebootSetting
      } : null)
      windows: ((operatingSystem == 'Windows') ? {
        excludedKbNumbers: excludeUpdates
        includedKbNumbers: includeUpdates
        includedUpdateClassifications: updateClassifications_var
        rebootSetting: rebootSetting
      } : null)
      targets: {
        azureQueries: [
          {
            scope: scopeByResources
            tagSettings: {
              tags: scopeByTags
              filterOperator: scopeByTagsOperation
            }
            locations: scopeByLocations
          }
        ]
        nonAzureQueries: nonAzureQueries
        // nonAzureQueries: empty(nonAzureQueries) ? null : nonAzureQueries
      }
      azureVirtualMachines: azureVirtualMachines
      nonAzureComputerNames: nonAzureComputerNames
    }
    tasks: {
      preTask: {
        parameters: (empty(preTaskParameters) ? null : preTaskParameters)
        source: (empty(preTaskSource) ? null : preTaskSource)
      }
      postTask: {
        parameters: (empty(postTaskParameters) ? null : postTaskParameters)
        source: (empty(postTaskSource) ? null : postTaskSource)
      }
    }
    scheduleInfo: {
      interval: interval
      frequency: frequency
      isEnabled: isEnabled
      timeZone: timeZone
      advancedSchedule: {
        weekDays: (empty(weekDays) ? null : weekDays)
        monthDays: (empty(monthDays) ? null : monthDays)
        monthlyOccurrences: (empty(monthlyOccurrences) ? null : monthlyOccurrences)
      }
      // startTime: startTime_var
      startTime: (empty(startTime) ? dateTimeAdd(baseTime, 'PT10M') : startTime)
      expiryTime: expiryTime
      expiryTimeOffsetMinutes: expiryTimeOffsetMinutes
      nextRun: nextRun
      nextRunOffsetMinutes: nextRunOffsetMinutes
      description: scheduleDescription
    }
  }
}

@description('The name of the deployed softwareUpdateConfiguration')
output softwareUpdateConfigurationName string = softwareUpdateConfiguration.name

@description('The Id of the deployed softwareUpdateConfiguration')
output softwareUpdateConfigurationResourceId string = softwareUpdateConfiguration.id

@description('The resource group of the deployed softwareUpdateConfiguration')
output softwareUpdateConfigurationResourceGroup string = resourceGroup().name
