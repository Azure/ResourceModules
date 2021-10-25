@description('Required. The name of the machine learning workspace.')
param workspaceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Specifies the sku, also referred as \'edition\' of the Azure Machine Learning workspace.')
@allowed([
  'Basic'
  'Enterprise'
])
param sku string

@description('Required. The resource id of the associated Storage Account.')
param associatedStorageAccountResourceId string

@description('Required. The resource id of the associated Key Vault.')
param associatedKeyVaultResourceId string

@description('Required. The resource id of the associated Application Insights.')
param associatedApplicationInsightsResourceId string

@description('Optional. The resource id of the associated Container Registry.')
param associatedContainerRegistryResourceId string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.')
param hbiWorkspace bool = false

@description('Optional. The flag to indicate whether to allow public access when behind VNet.')
param allowPublicAccessWhenBehindVnet bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of the Diagnostic setting.')
param diagnosticSettingName string = 'service'

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

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'AmlComputeClusterEvent'
  'AmlComputeClusterNodeEvent'
  'AmlComputeJobEvent'
  'AmlComputeCpuGpuUtilization'
  'AmlRunStatusChangedEvent'
])
param logsToEnable array = [
  'AmlComputeClusterEvent'
  'AmlComputeClusterNodeEvent'
  'AmlComputeJobEvent'
  'AmlComputeCpuGpuUtilization'
  'AmlRunStatusChangedEvent'
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
  'AzureML Metrics Writer (preview)': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/635dd51f-9968-44d3-b7fb-6d9a6bd613ae'
  'Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  'Log Analytics Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  'Log Analytics Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/73c42c96-874c-492b-b04d-ab87d138a893'
  'Managed Application Contributor Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/641177b8-a67a-45b9-a033-47bc880bb21e'
  'Managed Application Operator Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/c7393b34-138c-406f-901b-d8cf2b17e6ae'
  'Managed Applications Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b9331d33-8a36-4f8c-b097-4f54124fdb44'
  'Monitoring Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Metrics Publisher': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/3913510d-42f4-4e42-8a64-420c390055eb'
  'Monitoring Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  'Owner': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  'Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Resource Policy Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/36243c78-bf99-498c-9df9-86d9f8d28608'
  'User Access Administrator': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource workspace 'Microsoft.MachineLearningServices/workspaces@2021-04-01' = {
  name: workspaceName
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: workspaceName
    storageAccount: associatedStorageAccountResourceId
    keyVault: associatedKeyVaultResourceId
    applicationInsights: associatedApplicationInsightsResourceId
    containerRegistry: ((!(associatedContainerRegistryResourceId == '')) ? associatedContainerRegistryResourceId : json('null'))
    hbiWorkspace: hbiWorkspace
    allowPublicAccessWhenBehindVnet: allowPublicAccessWhenBehindVnet
  }
}

resource workspace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${workspace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: workspace
}

resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${workspaceName}-${diagnosticSettingName}'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: workspace
}

module workspace_privateEndpoints './.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Workspace-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: workspace.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: privateEndpoint
    tags: tags
  }
}]

module workspace_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: workspace.name
  }
}]

output machineLearningServiceResourceId string = workspace.id
output machineLearningServiceResourceGroup string = resourceGroup().name
output machineLearningServiceName string = workspace.name
