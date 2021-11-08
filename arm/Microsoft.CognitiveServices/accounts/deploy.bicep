@description('Required. The name of Cognitive Services account')
param accountName string

@description('Required. Kind of the Cognitive Services. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'sku\' for your Azure region.')
@allowed([
  'AnomalyDetector'
  'Bing.Autosuggest.v7'
  'Bing.CustomSearch'
  'Bing.EntitySearch'
  'Bing.Search.v7'
  'Bing.SpellCheck.v7'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Face'
  'FormRecognizer'
  'ImmersiveReader'
  'Internal.AllInOne'
  'LUIS'
  'LUIS.Authoring'
  'Personalizer'
  'QnAMaker'
  'SpeechServices'
  'TextAnalytics'
  'TextTranslation'
])
param kind string

@description('Optional. SKU of the Cognitive Services resource. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'sku\' for your Azure region.')
@allowed([
  'C2'
  'C3'
  'C4'
  'F0'
  'F1'
  'S'
  'S0'
  'S1'
  'S10'
  'S2'
  'S3'
  'S4'
  'S5'
  'S6'
  'S7'
  'S8'
  'S9'
])
param sku string = 'S0'

@description('Optional. Location for all Resources.')
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

@description('Optional. Subdomain name used for token-based authentication. Required if \'networkAcls\' are set.')
param customSubDomainName string = ''

@description('Optional. Subdomain name used for token-based authentication. Must be set if \'networkAcls\' are set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Service endpoint object information')
param networkAcls object = {}

@description('Optional. Type of managed service identity.')
@allowed([
  'None'
  'SystemAssigned'
])
param managedIdentity string = 'None'

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'Audit'
  'RequestResponse'
])
param logsToEnable array = [
  'Audit'
  'RequestResponse'
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

var networkAcls_var = {
  defaultAction: ((empty(networkAcls)) ? json('null') : networkAcls.defaultAction)
  virtualNetworkRules: ((empty(networkAcls)) ? json('null') : ((length(networkAcls.virtualNetworkRules) == 0) ? [] : networkAcls.virtualNetworkRules))
  ipRules: ((empty(networkAcls)) ? json('null') : ((length(networkAcls.ipRules) == 0) ? [] : networkAcls.ipRules))
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource cognitiveServices 'Microsoft.CognitiveServices/accounts@2017-04-18' = {
  name: accountName
  kind: kind
  identity: {
    type: managedIdentity
  }
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: (empty(customSubDomainName) ? json('null') : customSubDomainName)
    networkAcls: ((empty(networkAcls)) ? json('null') : networkAcls_var)
    publicNetworkAccess: publicNetworkAccess
  }
}

resource cognitiveServices_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${cognitiveServices.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: cognitiveServices
}

resource cognitiveServices_diagnosticSettingName 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: '${cognitiveServices.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: cognitiveServices
}

module cognitiveServices_privateEndpoints '.bicep/nested_privateEndpoints.bicep' = [for privateEndpoint in privateEndpoints: {
  name: '${uniqueString(deployment().name, privateEndpoint.name)}-privateEndpoint'
  params: {
    privateEndpointResourceId: cognitiveServices.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpoint: privateEndpoint
    tags: tags
  }
}]

module cognitiveServices_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: cognitiveServices.name
  }
}]

output cognitiveServicesName string = cognitiveServices.name
output cognitiveServicesResourceId string = cognitiveServices.id
output cognitiveServicesResourceGroup string = resourceGroup().name
output cognitiveServicesEndpoint string = cognitiveServices.properties.endpoint
output principalId string = managedIdentity != 'None' ? cognitiveServices.identity.principalId : ''
