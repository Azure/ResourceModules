@description('Required. Name of your Azure Container Registry')
@minLength(5)
@maxLength(50)
param acrName string

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Basic'

@description('Optional. The value that indicates whether the policy is enabled or not.')
param quarantinePolicyStatus string = ''

@description('Optional. The value that indicates whether the policy is enabled or not.')
param trustPolicyStatus string = ''

@description('Optional. The value that indicates whether the policy is enabled or not.')
param retentionPolicyStatus string = ''

@description('Optional. The number of days to retain an untagged manifest after which it gets purged.')
param retentionPolicyDays string = ''

@description('Optional. Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access.')
param dataEndpointEnabled bool = false

@description('Optional. Whether or not public network access is allowed for the container registry. - Enabled or Disabled')
param publicNetworkAccess string = 'Enabled'

@description('Optional. Whether to allow trusted Azure services to access a network restricted registry. Not relevant in case of public access. - AzureServices or None')
param networkRuleBypassOptions string = 'AzureServices'

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

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

var cleanAcrName_var = replace(toLower(acrName), '-', '')
var builtInRoleNames = {}
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
    category: 'ContainerRegistryRepositoryEvents'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'ContainerRegistryLoginEvents'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource resgistry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: cleanAcrName_var
  location: location
  tags: tags
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
    policies: {
      quarantinePolicy: {
        status: (empty(quarantinePolicyStatus) ? json('null') : quarantinePolicyStatus)
      }
      trustPolicy: {
        type: 'Notary'
        status: (empty(trustPolicyStatus) ? json('null') : trustPolicyStatus)
      }
      retentionPolicy: {
        days: (empty(retentionPolicyDays) ? json('null') : int(retentionPolicyDays))
        status: (empty(retentionPolicyStatus) ? json('null') : retentionPolicyStatus)
      }
    }
    dataEndpointEnabled: dataEndpointEnabled
    publicNetworkAccess: publicNetworkAccess
    networkRuleBypassOptions: networkRuleBypassOptions
  }
}

resource resgistry_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${resgistry.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: resgistry
}

resource resgistry_diagnosticSettingName 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${resgistry.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: resgistry
}

module cognitiveServices_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: resgistry.name
  }
}]

module name_location_ContainerRegistry_PrivateEndpoints './.bicep/nested_privateEndpoints.bicep' = [for privateEndpoint in privateEndpoints: {
  name: '${uniqueString(deployment().name, privateEndpoint.name)}-privateEndpoint'
  params: {
    privateEndpointResourceId: resgistry.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpoint: privateEndpoint
    tags: tags
  }
}]

output acrName string = resgistry.name
output acrLoginServer string = reference(resgistry.id, '2019-05-01').loginServer
output acrResourceGroup string = resourceGroup().name
output acrResourceId string = resgistry.id
