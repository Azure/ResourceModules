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

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
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

@description('Optional. The Resource Id of the App Service Plan to use for the App. If not provided, the hosting plan name is used to create a new plan.')
param appServicePlanId string = ''

@description('Optional. The Resource Id of the App Service Environment to use for the Function App.')
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

@description('Optional. Configures a web site to accept only https requests. Issues redirect for http requests.')
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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Website Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')
}
var hostingEnvironment = {
  id: appServiceEnvironmentId
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = if (empty(appServicePlanId)) {
  name: ((!empty(appServicePlanName)) ? appServicePlanName : 'dummyAppServicePlanName')
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
    hostingEnvironmentProfile: (empty(appServiceEnvironmentId) ? json('null') : json('{ id: ${hostingEnvironment} }'))
  }
}

resource appServicePlan_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified' && empty(appServicePlanId)) {
  name: '${appServicePlan.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
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
    userAssignedIdentities: (empty(userAssignedIdentities) ? json('null') : userAssignedIdentities)
  }
  properties: {
    serverFarmId: ((!empty(appServicePlanId)) ? appServicePlanId : resourceId('Microsoft.Web/serverfarms', appServicePlanName))
    httpsOnly: httpsOnly
    hostingEnvironmentProfile: (empty(appServiceEnvironmentId) ? json('null') : json('{ id: ${hostingEnvironment} }'))
    clientAffinityEnabled: clientAffinityEnabled
    siteConfig: siteConfig
  }
  dependsOn: [
    appServicePlan
  ]

  resource app_appsettings 'config@2019-08-01' = {
    name: 'appsettings'
    properties: {
      AzureWebJobsStorage: ((!empty(storageAccountName)) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listkeys(resourceId(subscription().subscriptionId, storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value};' : any(json('null')))
      AzureWebJobsDashboard: ((!empty(storageAccountName)) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listkeys(resourceId(subscription().subscriptionId, storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value};' : any(json('null')))
      FUNCTIONS_EXTENSION_VERSION: (((appServicePlanType == 'functionApp') && (!empty(functionsExtensionVersion))) ? functionsExtensionVersion : any(json('null')))
      FUNCTIONS_WORKER_RUNTIME: (((appServicePlanType == 'functionApp') && (!empty(functionsWorkerRuntime))) ? functionsWorkerRuntime : any(json('null')))
      APPINSIGHTS_INSTRUMENTATIONKEY: (enableMonitoring ? reference('microsoft.insights/components/${appName}', '2015-05-01').InstrumentationKey : json('null'))
      APPLICATIONINSIGHTS_CONNECTION_STRING: (enableMonitoring ? reference('microsoft.insights/components/${appName}', '2015-05-01').ConnectionString : json('null'))
    }
  }
}

resource app_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${app.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: app
}

resource app_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${app.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
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

module app_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: app.name
  }
}]

module app_privateEndpoint './.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-AppService-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: app.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: privateEndpoint
    tags: tags
  }
  dependsOn: [
    app
  ]
}]

output siteName string = app.name
output siteResourceId string = app.id
output siteResourceGroup string = resourceGroup().name
