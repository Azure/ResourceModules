@description('Required. Name of the Automation Account job schedule')
param name string

@description('Required. Name of the parent Automation Account')
param parent string

@description('Optional. ')
param parameters object = {}

@description('Required. ')
param runbookName string

@description('Optional. ')
param runOn string = ''

@description('Required. ')
param scheduleName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource jobSchedule_automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' existing = {
  name: parent
}

resource jobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2020-01-13-preview' = {
  name: name
  parent: jobSchedule_automationAccount
  properties: {
    parameters: (empty(parameters) ? null : parameters)
    runbook: {
      name: runbookName
    }
    runOn: (empty(runOn) ? null : runOn)
    schedule: {
      name: scheduleName
    }
  }
}

// @description('The name of the deployed jobSchedule')
output jobScheduleName string = jobSchedule.name

// @description('The id of the deployed jobSchedule')
output jobScheduleResourceId string = jobSchedule.id

// @description('The resource group of the deployed jobSchedule')
output jobScheduleResourceGroup string = resourceGroup().name
