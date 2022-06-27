@description('Required. Name of the Automation Account schedule.')
param name string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Optional. The properties of the create Advanced Schedule.')
@metadata({
  monthDays: 'Days of the month that the job should execute on. Must be between 1 and 31.'
  monthlyOccurrences: 'Occurrences of days within a month.'
  weekDays: 'Days of the week that the job should execute on.'
})
param advancedSchedule object = {}

@description('Optional. The description of the schedule.')
param scheduleDescription string = ''

@description('Optional. The end time of the schedule.')
param expiryTime string = ''

@allowed([
  'Day'
  'Hour'
  'Minute'
  'Month'
  'OneTime'
  'Week'
])
@description('Optional. The frequency of the schedule.')
param frequency string = 'OneTime'

@description('Optional. Anything.')
param interval int = 0

@description('Optional. The start time of the schedule.')
param startTime string = ''

@description('Optional. The time zone of the schedule.')
param timeZone string = ''

@description('Generated. Time used as a basis for e.g. the schedule start date.')
param baseTime string = utcNow('u')

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' existing = {
  name: automationAccountName
}

resource schedule 'Microsoft.Automation/automationAccounts/schedules@2020-01-13-preview' = {
  name: name
  parent: automationAccount
  properties: {
    advancedSchedule: !empty(advancedSchedule) ? advancedSchedule : null
    description: !empty(scheduleDescription) ? scheduleDescription : null
    expiryTime: !empty(expiryTime) ? expiryTime : null
    frequency: !empty(frequency) ? frequency : 'OneTime'
    interval: (interval != 0) ? interval : null
    startTime: !empty(startTime) ? startTime : dateTimeAdd(baseTime, 'PT10M')
    timeZone: !empty(timeZone) ? timeZone : null
  }
}

@description('The name of the deployed schedule.')
output name string = schedule.name

@description('The resource ID of the deployed schedule.')
output resourceId string = schedule.id

@description('The resource group of the deployed schedule.')
output resourceGroupName string = resourceGroup().name
