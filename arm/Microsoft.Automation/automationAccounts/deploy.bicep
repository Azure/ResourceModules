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

@description('Optional. List of variables to be created in the automation account.')
param variables array = []

@description('Optional. ID of the log analytics workspace to be linked to the deployed automation account.')
param linkedWorkspaceId string = ''

@description('Optional. List of gallerySolutions to be created in the linked log analytics workspace')
param gallerySolutions array = []

@description('Optional. List of softwareUpdateConfigurations to be created in the automation account')
param softwareUpdateConfigurations array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@minValue(0)
@maxValue(365)
@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

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

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
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

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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
  identity: identity
}

module automationAccount_modules 'modules/deploy.bicep' = [for (module, index) in modules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Module-${index}'
  params: {
    name: module.name
    automationAccountName: automationAccount.name
    version: module.version
    uri: module.uri
    location: location
    tags: tags
  }
}]

module automationAccount_schedules 'schedules/deploy.bicep' = [for (schedule, index) in schedules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Schedule-${index}'
  params: {
    name: schedule.name
    automationAccountName: automationAccount.name
    advancedSchedule: contains(schedule, 'advancedSchedule') ? schedule.advancedSchedule : null
    scheduleDescription: contains(schedule, 'description') ? schedule.description : ''
    expiryTime: contains(schedule, 'expiryTime') ? schedule.expiryTime : ''
    frequency: contains(schedule, 'frequency') ? schedule.frequency : 'OneTime'
    interval: contains(schedule, 'interval') ? schedule.interval : 0
    startTime: contains(schedule, 'startTime') ? schedule.startTime : ''
    timeZone: contains(schedule, 'timeZone') ? schedule.timeZone : ''
  }
}]

module automationAccount_runbooks 'runbooks/deploy.bicep' = [for (runbook, index) in runbooks: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Runbook-${index}'
  params: {
    name: runbook.name
    automationAccountName: automationAccount.name
    runbookType: runbook.runbookType
    runbookDescription: contains(runbook, 'description') ? runbook.description : ''
    uri: contains(runbook, 'uri') ? runbook.uri : ''
    version: contains(runbook, 'version') ? runbook.version : ''
    location: location
    tags: tags
  }
}]

module automationAccount_jobSchedules 'jobSchedules/deploy.bicep' = [for (jobSchedule, index) in jobSchedules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-JobSchedule-${index}'
  params: {
    automationAccountName: automationAccount.name
    runbookName: jobSchedule.runbookName
    scheduleName: jobSchedule.scheduleName
    parameters: contains(jobSchedule, 'parameters') ? jobSchedule.parameters : {}
    runOn: contains(jobSchedule, 'runOn') ? jobSchedule.runOn : ''
  }
  dependsOn: [
    automationAccount_schedules
    automationAccount_runbooks
  ]
}]

module automationAccount_variables 'variables/deploy.bicep' = [for (variable, index) in variables: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Variable-${index}'
  params: {
    automationAccountName: automationAccount.name
    name: variable.name
    description: contains(variable, 'description') ? variable.description : ''
    value: variable.value
    isEncrypted: contains(variable, 'isEncrypted') ? variable.isEncrypted : false
  }
}]

module automationAccount_linkedService '.bicep/nested_linkedService.bicep' = if (!empty(linkedWorkspaceId)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-LinkedService'
  params: {
    name: 'automation'
    logAnalyticsWorkspaceName: last(split(linkedWorkspaceId, '/'))
    resourceId: automationAccount.id
    tags: tags
  }
  // This is to support linked services to law in different subscription and resource group than the automation account.
  // The current scope is used by default if no linked service is intended to be created.
  scope: resourceGroup(!empty(linkedWorkspaceId) ? split(linkedWorkspaceId, '/')[2] : subscription().subscriptionId, !empty(linkedWorkspaceId) ? split(linkedWorkspaceId, '/')[4] : resourceGroup().name)
}

module automationAccount_solutions '.bicep/nested_solution.bicep' = [for (gallerySolution, index) in gallerySolutions: if (!empty(linkedWorkspaceId)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Solution-${index}'
  params: {
    name: gallerySolution
    location: location
    logAnalyticsWorkspaceName: last(split(linkedWorkspaceId, '/'))
  }
  // This is to support solution to law in different subscription and resource group than the automation account.
  // The current scope is used by default if no linked service is intended to be created.
  scope: resourceGroup(!empty(linkedWorkspaceId) ? split(linkedWorkspaceId, '/')[2] : subscription().subscriptionId, !empty(linkedWorkspaceId) ? split(linkedWorkspaceId, '/')[4] : resourceGroup().name)
  dependsOn: [
    automationAccount_linkedService
  ]
}]

module automationAccount_softwareUpdateConfigurations 'softwareUpdateConfigurations/deploy.bicep' = [for (softwareUpdateConfiguration, index) in softwareUpdateConfigurations: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-SwUpdateConfig-${index}'
  params: {
    name: softwareUpdateConfiguration.name
    automationAccountName: automationAccount.name
    frequency: softwareUpdateConfiguration.frequency
    operatingSystem: softwareUpdateConfiguration.operatingSystem
    rebootSetting: softwareUpdateConfiguration.rebootSetting
    azureVirtualMachines: contains(softwareUpdateConfiguration, 'azureVirtualMachines') ? softwareUpdateConfiguration.azureVirtualMachines : []
    excludeUpdates: contains(softwareUpdateConfiguration, 'excludeUpdates') ? softwareUpdateConfiguration.excludeUpdates : []
    expiryTime: contains(softwareUpdateConfiguration, 'expiryTime') ? softwareUpdateConfiguration.expiryTime : ''
    expiryTimeOffsetMinutes: contains(softwareUpdateConfiguration, 'expiryTimeOffsetMinutes') ? softwareUpdateConfiguration.expiryTimeOffsetMinute : 0
    includeUpdates: contains(softwareUpdateConfiguration, 'includeUpdates') ? softwareUpdateConfiguration.includeUpdates : []
    interval: contains(softwareUpdateConfiguration, 'interval') ? softwareUpdateConfiguration.interval : 1
    isEnabled: contains(softwareUpdateConfiguration, 'isEnabled') ? softwareUpdateConfiguration.isEnabled : true
    maintenanceWindow: contains(softwareUpdateConfiguration, 'maintenanceWindow') ? softwareUpdateConfiguration.maintenanceWindow : 'PT2H'
    monthDays: contains(softwareUpdateConfiguration, 'monthDays') ? softwareUpdateConfiguration.monthDays : []
    monthlyOccurrences: contains(softwareUpdateConfiguration, 'monthlyOccurrences') ? softwareUpdateConfiguration.monthlyOccurrences : []
    nextRun: contains(softwareUpdateConfiguration, 'nextRun') ? softwareUpdateConfiguration.nextRun : ''
    nextRunOffsetMinutes: contains(softwareUpdateConfiguration, 'nextRunOffsetMinutes') ? softwareUpdateConfiguration.nextRunOffsetMinutes : 0
    nonAzureComputerNames: contains(softwareUpdateConfiguration, 'nonAzureComputerNames') ? softwareUpdateConfiguration.nonAzureComputerNames : []
    nonAzureQueries: contains(softwareUpdateConfiguration, 'nonAzureQueries') ? softwareUpdateConfiguration.nonAzureQueries : []
    postTaskParameters: contains(softwareUpdateConfiguration, 'postTaskParameters') ? softwareUpdateConfiguration.postTaskParameters : {}
    postTaskSource: contains(softwareUpdateConfiguration, 'postTaskSource') ? softwareUpdateConfiguration.postTaskSource : ''
    preTaskParameters: contains(softwareUpdateConfiguration, 'preTaskParameters') ? softwareUpdateConfiguration.preTaskParameters : {}
    preTaskSource: contains(softwareUpdateConfiguration, 'preTaskSource') ? softwareUpdateConfiguration.preTaskSource : ''
    scheduleDescription: contains(softwareUpdateConfiguration, 'scheduleDescription') ? softwareUpdateConfiguration.scheduleDescription : ''
    scopeByLocations: contains(softwareUpdateConfiguration, 'scopeByLocations') ? softwareUpdateConfiguration.scopeByLocations : []
    scopeByResources: contains(softwareUpdateConfiguration, 'scopeByResources') ? softwareUpdateConfiguration.scopeByResources : [
      subscription().id
    ]
    scopeByTags: contains(softwareUpdateConfiguration, 'scopeByTags') ? softwareUpdateConfiguration.scopeByTags : {}
    scopeByTagsOperation: contains(softwareUpdateConfiguration, 'scopeByTagsOperation') ? softwareUpdateConfiguration.scopeByTagsOperation : 'All'
    startTime: contains(softwareUpdateConfiguration, 'startTime') ? softwareUpdateConfiguration.startTime : ''
    timeZone: contains(softwareUpdateConfiguration, 'timeZone') ? softwareUpdateConfiguration.timeZone : 'UTC'
    updateClassifications: contains(softwareUpdateConfiguration, 'updateClassifications') ? softwareUpdateConfiguration.updateClassifications : [
      'Critical'
      'Security'
    ]
    weekDays: contains(softwareUpdateConfiguration, 'weekDays') ? softwareUpdateConfiguration.weekDays : []
  }
  dependsOn: [
    automationAccount_solutions
  ]
}]

resource automationAccount_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${automationAccount.name}-AutoAccount-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: automationAccount
}

resource automationAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${automationAccount.name}-AutoAccount-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: automationAccount
}

module automationAccount_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: if (!empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: automationAccount.id
    privateEndpointVnetLocation: !empty(privateEndpoints) ? reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location : 'dummy'
    privateEndpointObj: endpoint
    tags: tags
  }
}]

module automationAccount_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: automationAccount.id
  }
}]

@description('The name of the deployed automation account')
output name string = automationAccount.name

@description('The resource ID of the deployed automation account')
output resourceId string = automationAccount.id

@description('The resource group of the deployed automation account')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(automationAccount.identity, 'principalId') ? automationAccount.identity.principalId : ''
