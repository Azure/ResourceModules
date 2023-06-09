@description('Required. The logic app workflow name.')
param name string

@description('Optional. The access control configuration for workflow actions.')
param actionsAccessControlConfiguration object = {}

@description('Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector.')
param connectorEndpointsConfiguration object = {}

@description('Optional. The access control configuration for accessing workflow run contents.')
param contentsAccessControlConfiguration object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Parameters for the definition template.')
param definitionParameters object = {}

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. The integration account.')
param integrationAccount object = {}

@description('Optional. The integration service environment Id.')
param integrationServiceEnvironmentResourceId string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended.')
@allowed([
  'NotSpecified'
  'Completed'
  'Enabled'
  'Disabled'
  'Deleted'
  'Suspended'
])
param state string = 'Enabled'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The access control configuration for invoking workflow triggers.')
param triggersAccessControlConfiguration object = {}

@description('Optional. The definitions for one or more actions to execute at workflow runtime.')
param workflowActions object = {}

@description('Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow.')
param workflowEndpointsConfiguration object = {}

@description('Optional. The access control configuration for workflow management.')
param workflowManagementAccessControlConfiguration object = {}

@description('Optional. The definitions for the outputs to return from a workflow run.')
param workflowOutputs object = {}

@description('Optional. The definitions for one or more parameters that pass the values to use at your logic app\'s runtime.')
param workflowParameters object = {}

@description('Optional. The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults.')
param workflowStaticResults object = {}

@description('Optional. The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer.')
param workflowTriggers object = {}

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'WorkflowRuntime'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var identityType = systemAssignedIdentity ? 'SystemAssigned' : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: name
  location: location
  tags: !empty(tags) ? tags : null
  identity: identity
  properties: {
    state: state
    endpointsConfiguration: {
      workflow: workflowEndpointsConfiguration
      connector: connectorEndpointsConfiguration
    }
    accessControl: {
      triggers: !empty(triggersAccessControlConfiguration) ? triggersAccessControlConfiguration : null
      contents: !empty(contentsAccessControlConfiguration) ? contentsAccessControlConfiguration : null
      actions: !empty(actionsAccessControlConfiguration) ? actionsAccessControlConfiguration : null
      workflowManagement: !empty(workflowManagementAccessControlConfiguration) ? workflowManagementAccessControlConfiguration : null
    }
    integrationAccount: !empty(integrationAccount) ? integrationAccount : null
    integrationServiceEnvironment: !empty(integrationServiceEnvironmentResourceId) ? {
      id: integrationServiceEnvironmentResourceId
    } : null

    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: workflowActions
      contentVersion: '1.0.0.0'
      outputs: workflowOutputs
      parameters: workflowParameters
      staticResults: workflowStaticResults
      triggers: workflowTriggers
    }
    parameters: definitionParameters
  }
}

resource logicApp_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${logicApp.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: logicApp
}

resource logicApp_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: logicApp
}

module logicApp_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-LogicApp-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: logicApp.id
  }
}]

@description('The name of the logic app.')
output name string = logicApp.name

@description('The resource group the logic app was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the logic app.')
output resourceId string = logicApp.id

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(logicApp.identity, 'principalId') ? logicApp.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = logicApp.location
