@description('Required. Name of the Automation Account.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Free'
  'Basic'
])
@description('Optional. SKU name of the account.')
param skuName string = 'Basic'

@description('Optional. List of modules to be created in the automation account.')
param modules array = []

@description('Optional. List of runbooks to be created in the automation account.')
param runbooks array = []

@description('Optional. List of schedules to be created in the automation account.')
param schedules array = []

@description('Optional. List of jobSchedules to be created in the automation account.')
param jobSchedules array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@minValue(0)
@maxValue(365)
@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'JobLogs'
  'JobStreams'
  'DscNodeStatus'
])
param logsToEnable array = [
  'JobLogs'
  'JobStreams'
  'DscNodeStatus'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
  }
}

module automationAccount_modules './modules/deploy.bicep' = [for (module, index) in modules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Module-${index}'
  params: {
    name: module.name
    parent: automationAccount.name
    version: module.version
    uri: module.uri
    location: location
    tags: tags
  }
}]

module automationAccount_schedules './schedules/deploy.bicep' = [for (schedule, index) in schedules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Schedule-${index}'
  params: {
    name: schedule.name
    parent: automationAccount.name
    advancedSchedule: contains(schedule, 'advancedSchedule') ? schedule.advancedSchedule : null
    scheduleDescription: contains(schedule, 'description') ? schedule.description : ''
    expiryTime: contains(schedule, 'expiryTime') ? schedule.expiryTime : ''
    frequency: contains(schedule, 'frequency') ? schedule.frequency : 'OneTime'
    interval: contains(schedule, 'interval') ? schedule.interval : 0
    startTime: contains(schedule, 'startTime') ? schedule.startTime : ''
    timeZone: contains(schedule, 'timeZone') ? schedule.timeZone : ''
  }
}]

module automationAccount_runbooks './runbooks/deploy.bicep' = [for (runbook, index) in runbooks: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Runbook-${index}'
  params: {
    name: runbook.name
    parent: automationAccount.name
    runbookType: runbook.runbookType
    runbookDescription: contains(runbook, 'description') ? runbook.description : ''
    uri: contains(runbook, 'uri') ? runbook.uri : ''
    version: contains(runbook, 'version') ? runbook.version : ''
    location: location
    tags: tags
  }
}]

module automationAccount_jobSchedules './jobSchedules/deploy.bicep' = [for (jobSchedule, index) in jobSchedules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-JobSchedule-${index}'
  params: {
    parent: automationAccount.name
    runbookName: jobSchedule.runbookName
    scheduleName: jobSchedule.scheduleName
    parameters: contains(jobSchedule, 'parameters') ? (!empty(jobSchedule.parameters) ? jobSchedule.parameters : {}) : {}
    runOn: contains(jobSchedule, 'runOn') ? (!empty(jobSchedule.runOn) ? jobSchedule.runOn : '') : ''

  }
  dependsOn: [
      automationAccount_schedules
      automationAccount_runbooks
    ]
}]

resource automationAccount_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: automationAccount
}

resource automationAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? null : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? null : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? null : diagnosticsLogs)
  }
  scope: automationAccount
}

module automationAccount_privateEndpoints './.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: if (!empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: automationAccount.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: endpoint
    tags: tags
  }
  dependsOn: [
    automationAccount
  ]
}]

module automationAccount_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: automationAccount.name
  }
}]

@description('The name of the deployed automation account')
output automationAccountName string = automationAccount.name

@description('The id of the deployed automation account')
output automationAccountResourceId string = automationAccount.id

@description('The resource group of the deployed automation account')
output automationAccountResourceGroup string = resourceGroup().name
