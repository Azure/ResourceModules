param variables_jobSchedules_copyIndex_jobScheduleName ? /* TODO: fill in correct type */
param variables_jobSchedules_copyIndex_scheduleName ? /* TODO: fill in correct type */
param variables_jobSchedules_copyIndex_runbookName ? /* TODO: fill in correct type */
param variables_jobSchedules_copyIndex_runOn ? /* TODO: fill in correct type */
param variables_jobSchedules_copyIndex_parameters ? /* TODO: fill in correct type */

@description('Required. Name of the Automation Account')
param automationAccountName string

resource automationAccountName_variables_jobSchedules_copyIndex_jobScheduleName_jobScheduleName 'Microsoft.Automation/automationAccounts/jobSchedules@2015-10-31' = {
  name: '${automationAccountName}/${guid(variables_jobSchedules_copyIndex_jobScheduleName[copyIndex()].jobScheduleName)}'
  location: resourceGroup().location
  properties: {
    schedule: {
      name: variables_jobSchedules_copyIndex_scheduleName[copyIndex()].scheduleName
    }
    runbook: {
      name: variables_jobSchedules_copyIndex_runbookName[copyIndex()].runbookName
    }
    runOn: (empty(variables_jobSchedules_copyIndex_runOn[copyIndex()].runOn) ? json('null') : variables_jobSchedules_copyIndex_runOn[copyIndex()].runOn)
    parameters: (empty(variables_jobSchedules_copyIndex_parameters[copyIndex()].parameters) ? json('null') : variables_jobSchedules_copyIndex_parameters[copyIndex()].parameters)
  }
}