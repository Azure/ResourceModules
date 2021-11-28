@description('Required. Name of the Automation Account schedule.')
param name string

@description('Required. Name of the parent Automation Account.')
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

@description('Optional. Anything')
param interval int = 0

@description('Optional. The start time of the schedule.')
param startTime string = ''

@description('Optional. The time zone of the schedule.')
param timeZone string = ''

@description('Optional. Time used as a basis for e.g. the schedule start date.')
param baseTime string = utcNow('u')

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
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

@description('The name of the deployed schedule')
output scheduleName string = schedule.name

@description('The resource ID of the deployed schedule')
output scheduleResourceId string = schedule.id

@description('The resource group of the deployed schedule')
output scheduleResourceGroup string = resourceGroup().name
