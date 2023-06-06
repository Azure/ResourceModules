@maxLength(50)
@description('Required. The name of the FHIR service.')
param name string

@allowed([
  'fhir-R4'
  'fhir-Stu3'
])
@description('Optional. The kind of the service. Defaults to R4.')
param kind string = 'fhir-R4'

@description('Conditional. The name of the parent health data services workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. List of Azure AD object IDs (User or Apps) that is allowed access to the FHIR service.')
param accessPolicyObjectIds array = []

@description('Optional. The list of the Azure container registry login servers.')
param acrLoginServers array = []

@description('Optional. The list of Open Container Initiative (OCI) artifacts.')
param acrOciArtifacts array = []

@description('Optional. The authority url for the service.')
param authenticationAuthority string = uri(environment().authentication.loginEndpoint, subscription().tenantId)

@description('Optional. The audience url for the service.')
param authenticationAudience string = 'https://${workspaceName}-${name}.fhir.azurehealthcareapis.com'

@description('Optional. Specify URLs of origin sites that can access this API, or use "*" to allow access from any site.')
param corsOrigins array = []

@description('Optional. Specify HTTP headers which can be used during the request. Use "*" for any header.')
param corsHeaders array = []

@allowed([
  'DELETE'
  'GET'
  'OPTIONS'
  'PATCH'
  'POST'
  'PUT'
])
@description('Optional. Specify the allowed HTTP methods.')
param corsMethods array = []

@description('Optional. Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes.')
param corsMaxAge int = -1

@description('Optional. Use this setting to indicate that cookies should be included in CORS requests.')
param corsAllowCredentials bool = false

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

@description('Optional. The name of the default export storage account.')
param exportStorageAccountName string = ''

@description('Optional. The name of the default integration storage account.')
param importStorageAccountName string = ''

@description('Optional. If the import operation is enabled.')
param importEnabled bool = false

@description('Optional. If the FHIR service is in InitialImportMode.')
param initialImportMode bool = false

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Control permission for data plane traffic coming from public networks while private endpoint is enabled.')
param publicNetworkAccess string = 'Disabled'

@allowed([
  'no-version'
  'versioned'
  'versioned-update'
])
@description('Optional. The default value for tracking history across all resources.')
param resourceVersionPolicy string = 'versioned'

@description('Optional. A list of FHIR Resources and their version policy overrides.')
param resourceVersionOverrides object = {}

@description('Optional. If the SMART on FHIR proxy is enabled.')
param smartProxyEnabled bool = false

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@allowed([
  'AuditLogs'
])
@description('Optional. The name of logs that will be streamed.')
param diagnosticLogCategoriesToEnable array = [
  'AuditLogs'
]

@allowed([
  'AllMetrics'
])
@description('Optional. The name of metrics that will be streamed.')
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
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

var accessPolicies = [for id in accessPolicyObjectIds: {
  objectId: id
}]

var exportConfiguration = {
  storageAccountName: exportStorageAccountName
}

// =========== //
// Deployments //
// =========== //
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

resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' existing = {
  name: workspaceName
}

resource fhir 'Microsoft.HealthcareApis/workspaces/fhirservices@2022-06-01' = {
  name: name
  parent: workspace
  location: location
  kind: kind
  tags: tags
  identity: identity
  properties: {
    accessPolicies: accessPolicies
    authenticationConfiguration: {
      authority: authenticationAuthority
      audience: authenticationAudience
      smartProxyEnabled: smartProxyEnabled
    }
    corsConfiguration: {
      allowCredentials: corsAllowCredentials
      headers: corsHeaders
      maxAge: corsMaxAge == -1 ? null : corsMaxAge
      methods: corsMethods
      origins: corsOrigins
    }
    publicNetworkAccess: publicNetworkAccess
    exportConfiguration: exportStorageAccountName == '' ? {} : exportConfiguration
    importConfiguration: {
      enabled: importEnabled
      initialImportMode: initialImportMode
      integrationDataStore: importStorageAccountName == '' ? null : importStorageAccountName
    }
    resourceVersionPolicyConfiguration: {
      default: resourceVersionPolicy
      resourceTypeOverrides: empty(resourceVersionOverrides) ? null : resourceVersionOverrides
    }
    acrConfiguration: {
      loginServers: acrLoginServers
      ociArtifacts: empty(acrOciArtifacts) ? null : acrOciArtifacts
    }
  }
}

resource fhir_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${fhir.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: fhir
}

resource fhir_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: fhir
}

module fhir_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: fhir.id
  }
}]

@description('The name of the fhir service.')
output name string = fhir.name

@description('The resource ID of the fhir service.')
output resourceId string = fhir.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(fhir.identity, 'principalId') ? fhir.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = fhir.location

@description('The name of the fhir workspace.')
output workspaceName string = workspace.name
