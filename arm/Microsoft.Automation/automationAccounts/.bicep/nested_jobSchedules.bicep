param jobScheduleName string
param scheduleName string
param runbookName string
param runOn string
param parameters object

@description('Required. Name of the Automation Account')
param automationAccountName string

resource jobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2015-10-31' = {
  name: '${automationAccountName}/${jobScheduleName}'
  properties: {
    schedule: {
      name: scheduleName
    }
    runbook: {
      name: runbookName
    }
    runOn: (empty(runOn) ? json('null') : runOn)
    parameters: (empty(parameters) ? json('null') : parameters)
  }
}
