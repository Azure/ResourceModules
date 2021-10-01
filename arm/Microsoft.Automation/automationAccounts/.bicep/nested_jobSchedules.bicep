param automationAccountName string
param jobScheduleName string
param parameters object
param runbookName string
param runOn string
param scheduleName string

resource jobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2015-10-31' = {
  name: '${automationAccountName}/${jobScheduleName}'
  properties: {
    parameters: (empty(parameters) ? json('null') : parameters)
    runbook: {
      name: runbookName
    }
    runOn: (empty(runOn) ? json('null') : runOn)
    schedule: {
      name: scheduleName
    }
  }
}
