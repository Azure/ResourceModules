// @description('Required. Name of the Web Application Portal config name')
// @allowed([
//   'appsettings'
//   'authsettings'
//   'authsettingsV2'
//   'azurestorageaccounts'
//   'backup'
//   'connectionstrings'
//   'logs'
//   'metadata'
//   'pushsettings'
//   'slotConfigNames'
//   'web'
// ])
// param name string

@description('Required. Name of the Web Application Portal Name')
param appName string

@description('Optional. Required if app of kind functionapp. The resource ID of the storage account to manage triggers and logging function executions.')
param storageAccountId string = ''

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

@description('Optional. Version of the function extension.')
param functionsExtensionVersion string = '~3'

@description('Optional. The Resource ID of the App Insight to leverage for the App.')
param appInsightId string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource app 'Microsoft.Web/sites@2020-12-01' existing = {
  name: appName
}

resource appInsight 'microsoft.insights/components@2020-02-02' existing = if (!empty(appInsightId)) {
  name: last(split(appInsightId, '/'))
  scope: resourceGroup(split(appInsightId, '/')[2], split(appInsightId, '/')[4])
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = if (!empty(storageAccountId)) {
  name: last(split(storageAccountId, '/'))
  scope: resourceGroup(split(storageAccountId, '/')[2], split(storageAccountId, '/')[4])
}

resource app_appsettings 'Microsoft.Web/sites/config@2019-08-01' = {
  name: 'appsettings'
  parent: app
  properties: {
    // AzureWebJobsStorage: app.kind == 'functionapp' ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};' : ''
    // AzureWebJobsDashboard: app.kind == 'functionapp' ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};' : ''
    FUNCTIONS_EXTENSION_VERSION: app.kind == 'functionapp' && !empty(functionsExtensionVersion) ? functionsExtensionVersion : ''
    FUNCTIONS_WORKER_RUNTIME: app.kind == 'functionapp' && !empty(functionsWorkerRuntime) ? functionsWorkerRuntime : ''
    APPINSIGHTS_INSTRUMENTATIONKEY: !empty(appInsightId) ? appInsight.properties.InstrumentationKey : ''
    APPLICATIONINSIGHTS_CONNECTION_STRING: !empty(appInsightId) ? appInsight.properties.ConnectionString : ''
  }
}

// @description('The name of the site')
// output siteName string = app.name

// @description('The resourceId of the site')
// output siteResourceId string = app.id

// @description('The resource group the site was deployed into')
// output siteResourceGroup string = resourceGroup().name
