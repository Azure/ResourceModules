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

@description('Optional. Switch to lock Cognitive Services from deletion.')
param lockForDeletion bool = false

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var diagnosticsMetrics = [
  {
    category: 'AllMetrics'
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var diagnosticsLogs = [
  {
    category: 'Audit'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'RequestResponse'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var builtInRoleNames = {
}
var deployServiceEndpoint = (!empty(networkAcls))
var emptyArray = []
var networkAcls_var = {
  defaultAction: ((!deployServiceEndpoint) ? json('null') : networkAcls.defaultAction)
  virtualNetworkRules: ((!deployServiceEndpoint) ? json('null') : ((length(networkAcls.virtualNetworkRules) == 0) ? emptyArray : networkAcls.virtualNetworkRules))
  ipRules: ((!deployServiceEndpoint) ? json('null') : ((length(networkAcls.ipRules) == 0) ? emptyArray : networkAcls.ipRules))
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
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
    networkAcls: ((!deployServiceEndpoint) ? json('null') : networkAcls_var)
    publicNetworkAccess: publicNetworkAccess
  }
}

resource cognitiveServices_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${cognitiveServices.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
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

module name_location_CognitiveServices_PrivateEndpoints './.bicep/nested_privateEndpoints.bicep' = [for (item, i) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-CognitiveServices-PrivateEndpoints-${i}'
  params: {
    privateEndpointResourceId: cognitiveServices.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(item.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpoint: item
    tags: tags
  }
  dependsOn: [
    cognitiveServices
  ]
}]

module cognitiveServices_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: cognitiveServices.name
  }
  dependsOn: [
    cognitiveServices
  ]
}]

output cognitiveServicesName string = cognitiveServices.name
output cognitiveServicesResourceId string = cognitiveServices.id
output cognitiveServicesResourceGroup string = resourceGroup().name
output cognitiveServicesKeys object = listKeys(cognitiveServices.id, '2017-04-18')
output cognitiveServicesKey1 string = listKeys(cognitiveServices.id, '2017-04-18').key1
output cognitiveServicesKey2 string = listKeys(cognitiveServices.id, '2017-04-18').key2
output cognitiveServicesEndpoint string = reference(cognitiveServices.id, '2017-04-18').endpoint
output principalId string = reference(cognitiveServices.id, '2017-04-18', 'Full').identity.principalId
