@description('Required. Name of the Web Application Portal Name')
param appName string

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

@description('Optional. If true, ApplicationInsights will be configured for the Function App.')
param enableMonitoring bool = true

@description('Optional. Mandatory \'managedServiceIdentity\' contains UserAssigned. The identy to assign to the resource.')
param userAssignedIdentities object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. The name of the storage account to managing triggers and logging function executions.')
param storageAccountName string = ''

@description('Optional. Resource group of the storage account to use. Required if the storage account is in a different resource group than the function app itself.')
param storageAccountResourceGroupName string = resourceGroup().name

@description('Optional. Runtime of the function worker.')
@allowed([
  'dotnet'
  'node'
  'python'
  'java'
  'powershell'
  ''
])
param functionsWorkerRuntime string = ''

@description('Optional. Version if the function extension.')
param functionsExtensionVersion string = '~3'

@description('Optional. Required if no appServicePlanId is provided to deploy a new app service plan.')
param appServicePlanName string = ''

@description('Optional. The pricing tier for the hosting plan.')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P1v2'
  'P2'
  'P3'
  'P4'
])
param appServicePlanSkuName string = 'F1'

@description('Optional. Defines the number of workers from the worker pool that will be used by the app service plan')
param appServicePlanWorkerSize int = 2

@description('Optional. SkuTier of app service plan deployed if no appServicePlanId was provided.')
param appServicePlanTier string = ''

@description('Optional. SkuSize of app service plan deployed if no appServicePlanId was provided.')
param appServicePlanSize string = ''

@description('Optional. SkuFamily of app service plan deployed if no appServicePlanId was provided.')
param appServicePlanFamily string = ''

@description('Optional. SkuType of app service plan deployed if no appServicePlanId was provided.')
@allowed([
  'linux'
  'windows'
])
param appServicePlanType string = 'linux'

@description('Optional. The Resource ID of the App Service Plan to use for the App. If not provided, the hosting plan name is used to create a new plan.')
param appServicePlanId string = ''

@description('Optional. The Resource ID of the App Service Environment to use for the Function App.')
param appServiceEnvironmentId string = ''

@description('Required. Type of site to deploy')
@allowed([
  'functionapp'
  'app'
])
param appType string

@description('Optional. Type of managed service identity.')
@allowed([
  'None'
  'SystemAssigned'
  'SystemAssigned, UserAssigned'
  'UserAssigned'
])
param managedServiceIdentity string = 'None'

@description('Optional. Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests.')
param httpsOnly bool = true

@description('Optional. If Client Affinity is enabled.')
param clientAffinityEnabled bool = true

@description('Required. Configuration of the app.')
param siteConfig object = {}

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'AppServiceHTTPLogs'
  'AppServiceConsoleLogs'
  'AppServiceAppLogs'
  'AppServiceFileAuditLogs'
  'AppServiceAuditLogs'
])
param logsToEnable array = [
  'AppServiceHTTPLogs'
  'AppServiceConsoleLogs'
  'AppServiceAppLogs'
  'AppServiceFileAuditLogs'
  'AppServiceAuditLogs'
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

var hostingEnvironment = {
  id: appServiceEnvironmentId
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = if (empty(appServicePlanId)) {
  name: !empty(appServicePlanName) ? appServicePlanName : 'dummyAppServicePlanName'
  kind: appServicePlanType
  location: location
  tags: tags
  sku: {
    name: appServicePlanSkuName
    capacity: appServicePlanWorkerSize
    tier: appServicePlanTier
    size: appServicePlanSize
    family: appServicePlanFamily
  }
  properties: {
    hostingEnvironmentProfile: !empty(appServiceEnvironmentId) ? json('{ id: ${hostingEnvironment} }') : null
  }
}

resource appServicePlan_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified' && empty(appServicePlanId)) {
  name: '${appServicePlan.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: appServicePlan
}

resource app 'Microsoft.Web/sites@2020-12-01' = {
  name: appName
  location: location
  kind: appType
  tags: tags
  identity: {
    type: managedServiceIdentity
    userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
  }
  properties: {
    serverFarmId: !empty(appServicePlanId) ? appServicePlanId : appServicePlan.id
    httpsOnly: httpsOnly
    hostingEnvironmentProfile: !empty(appServiceEnvironmentId) ? json('{ id: ${hostingEnvironment} }') : null
    clientAffinityEnabled: clientAffinityEnabled
    siteConfig: siteConfig
  }

  resource app_appsettings 'config@2019-08-01' = {
    name: 'appsettings'
    properties: {
      AzureWebJobsStorage: !empty(storageAccountName) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listkeys(resourceId(subscription().subscriptionId, storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value};' : any(null)
      AzureWebJobsDashboard: !empty(storageAccountName) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listkeys(resourceId(subscription().subscriptionId, storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value};' : any(null)
      FUNCTIONS_EXTENSION_VERSION: appServicePlanType == 'functionApp' && !empty(functionsExtensionVersion) ? functionsExtensionVersion : any(null)
      FUNCTIONS_WORKER_RUNTIME: appServicePlanType == 'functionApp' && !empty(functionsWorkerRuntime) ? functionsWorkerRuntime : any(null)
      APPINSIGHTS_INSTRUMENTATIONKEY: enableMonitoring ? reference('microsoft.insights/components/${appName}', '2015-05-01').InstrumentationKey : null
      APPLICATIONINSIGHTS_CONNECTION_STRING: enableMonitoring ? reference('microsoft.insights/components/${appName}', '2015-05-01').ConnectionString : null
    }
  }
}

resource app_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${app.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: app
}

resource app_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName)) {
  name: '${app.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(workspaceId) ? null : workspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsLogs
  }
  scope: app
}

resource app_insights 'microsoft.insights/components@2020-02-02' = if (enableMonitoring) {
  name: app.name
  location: location
  kind: 'web'
  tags: tags
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

module app_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: app.name
  }
}]

module app_privateEndpoint '.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-AppService-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: app.id
    privateEndpointVnetLocation: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpointObj: privateEndpoint
    tags: tags
  }
}]

@description('The name of the site')
output siteName string = app.name

@description('The resource ID of the site')
output siteResourceId string = app.id

@description('The resource group the site was deployed into')
output siteResourceGroup string = resourceGroup().name
