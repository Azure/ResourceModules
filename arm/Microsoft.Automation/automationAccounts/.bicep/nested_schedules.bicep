param scheduleName string
param startTime string
param frequency string
param expiryTime string
param interval int
param timeZone string
param advancedSchedule string
param automationAccountName string
param baseTime string

resource schedule 'Microsoft.Automation/automationAccounts/schedules@2015-10-31' = {
  name: '${automationAccountName}/${scheduleName}'
  properties: {
    startTime: (empty(startTime) ? dateTimeAdd(baseTime, 'PT10M') : startTime)
    frequency: (empty(frequency) ? json('null') : frequency)
    expiryTime: (empty(expiryTime) ? json('null') : expiryTime)
    interval: ((0 == interval) ? json('null') : interval)
    timeZone: (empty(timeZone) ? json('null') : timeZone)
    advancedSchedule: (empty(advancedSchedule) ? json('null') : advancedSchedule)
  }
}
