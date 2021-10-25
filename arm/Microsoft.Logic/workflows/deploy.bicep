@description('Optional. The access control configuration for workflow actions.')
param actionsAccessControlConfiguration object = {}

@description('Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector.')
param connectorEndpointsConfiguration object = {}

@description('Optional. The access control configuration for accessing workflow run contents.')
param contentsAccessControlConfiguration object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.')
param cuaId string = ''

@description('Optional. Parameters for the definition template.')
param definitionParameters object = {}

@description('Optional. Type of managed identity for resource. SystemAssigned or UserAssigned.')
param identity object = {}

@description('Optional. The integration account.')
param integrationAccount object = {}

@description('Optional. The integration service environment.')
param integrationServiceEnvironment object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
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

@description('Required. The logic app workflow name.')
param logicAppName string

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Sku of Logic App. Only to be set when integrating with ISE.')
param sku object = {}

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

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'WorkflowRuntime'
])
param logsToEnable array = [
  'WorkflowRuntime'
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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Azure Sentinel Automation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f4c81013-99ee-4d62-a7ee-b3f1f648599a')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Logic App Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  tags: (empty(tags) ? json('null') : tags)
  identity: ((!empty(identity)) ? identity : any(null))
  properties: {
    state: state
    endpointsConfiguration: {
      workflow: workflowEndpointsConfiguration
      connector: connectorEndpointsConfiguration
    }
    sku: ((!empty(sku)) ? sku : json('null'))
    accessControl: {
      triggers: ((!empty(triggersAccessControlConfiguration)) ? triggersAccessControlConfiguration : json('null'))
      contents: ((!empty(contentsAccessControlConfiguration)) ? contentsAccessControlConfiguration : json('null'))
      actions: ((!empty(actionsAccessControlConfiguration)) ? actionsAccessControlConfiguration : json('null'))
      workflowManagement: ((!empty(workflowManagementAccessControlConfiguration)) ? workflowManagementAccessControlConfiguration : json('null'))
    }
    integrationAccount: ((!empty(integrationAccount)) ? integrationAccount : json('null'))
    integrationServiceEnvironment: ((!empty(integrationServiceEnvironment)) ? integrationServiceEnvironment : json('null'))
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

resource logicApp_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${logicApp.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: logicApp
}

resource logicApp_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${logicAppName}-diagnosticsetting'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: logicApp
}

module logicApp_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: logicApp.name
  }
}]

output logicAppName string = logicApp.name
output logicAppResourceGroup string = resourceGroup().name
output logicAppResourceId string = logicApp.id
