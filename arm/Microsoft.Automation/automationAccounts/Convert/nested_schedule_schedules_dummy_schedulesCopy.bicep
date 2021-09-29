param variables_schedules_copyIndex_scheduleName ? /* TODO: fill in correct type */
param variables_schedules_copyIndex_startTime ? /* TODO: fill in correct type */
param variables_schedules_copyIndex_frequency ? /* TODO: fill in correct type */
param variables_schedules_copyIndex_expiryTime ? /* TODO: fill in correct type */
param variables_schedules_copyIndex_interval ? /* TODO: fill in correct type */
param variables_schedules_copyIndex_timeZone ? /* TODO: fill in correct type */
param variables_schedules_copyIndex_advancedSchedule ? /* TODO: fill in correct type */

@description('Required. Name of the Automation Account')
param automationAccountName string

@description('Optional. Time used as a basis for e.g. the schedule start date')
param baseTime string

resource automationAccountName_variables_schedules_copyIndex_scheduleName_scheduleName 'Microsoft.Automation/automationAccounts/schedules@2015-10-31' = {
  name: '${automationAccountName}/${variables_schedules_copyIndex_scheduleName[copyIndex()].scheduleName}'
  location: resourceGroup().location
  properties: {
    startTime: (empty(variables_schedules_copyIndex_startTime[copyIndex()].startTime) ? dateTimeAdd(baseTime, 'PT10M') : variables_schedules_copyIndex_startTime[copyIndex()].startTime)
    frequency: variables_schedules_copyIndex_frequency[copyIndex()].frequency
    expiryTime: (empty(variables_schedules_copyIndex_expiryTime[copyIndex()].expiryTime) ? json('null') : variables_schedules_copyIndex_expiryTime[copyIndex()].expiryTime)
    interval: ((0 == variables_schedules_copyIndex_interval[copyIndex()].interval) ? json('null') : variables_schedules_copyIndex_interval[copyIndex()].interval)
    timeZone: (empty(variables_schedules_copyIndex_timeZone[copyIndex()].timeZone) ? json('null') : variables_schedules_copyIndex_timeZone[copyIndex()].timeZone)
    advancedSchedule: (empty(variables_schedules_copyIndex_advancedSchedule[copyIndex()].advancedSchedule) ? json('null') : variables_schedules_copyIndex_advancedSchedule[copyIndex()].advancedSchedule)
  }
}