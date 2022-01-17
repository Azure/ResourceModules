@description('Optional. Name of the Automation Account job schedule. Must be a GUID. If not provided, a new GUID is generated.')
param name string = newGuid()

@description('Required. Name of the parent Automation Account.')
param automationAccountName string

@description('Required. The runbook property associated with the entity.')
param runbookName string

@description('Required. The schedule property associated with the entity.')
param scheduleName string

@description('Optional. List of job properties.')
param parameters object = {}

@description('Optional. The hybrid worker group that the scheduled job should run on.')
param runOn string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
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

resource jobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2020-01-13-preview' = {
  name: name
  parent: automationAccount
  properties: {
    parameters: parameters
    runbook: {
      name: runbookName
    }
    runOn: !empty(runOn) ? runOn : null
    schedule: {
      name: scheduleName
    }
  }
}

@description('The name of the deployed jobSchedule')
output jobScheduleName string = jobSchedule.name

@description('The resource ID of the deployed jobSchedule')
output jobScheduleResourceId string = jobSchedule.id

@description('The resource group of the deployed jobSchedule')
output jobScheduleResourceGroup string = resourceGroup().name
