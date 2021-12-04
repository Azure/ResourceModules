@description('Required. Name of the Log Analytics workspace')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode')
@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
param serviceTier string = 'PerGB2018'

@description('Optional. List of storage accounts to be read by the workspace.')
param storageInsightsConfigs array = []

@description('Optional. List of services to be linked.')
param linkedServices array = []

@description('Optional. Kusto Query Language searches to save.')
param savedSearches array = []

@description('Optional. LAW data sources to configure.')
param dataSources array = []

@description('Optional. LAW gallerySolutions from the gallery.')
param gallerySolutions array = []

@description('Required. Number of days data will be retained for')
@minValue(0)
@maxValue(730)
param dataRetention int = 365

@description('Optional. The workspace daily quota for ingestion.')
@minValue(-1)
param dailyQuotaGb int = -1

@description('Optional. The network access type for accessing Log Analytics ingestion.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Log Analytics query.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Set to \'true\' to use resource or workspace permissions and \'false\' (or leave empty) to require workspace permissions.')
param useResourcePermissions bool = false

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var logAnalyticsSearchVersion = 1

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  location: location
  name: name
  tags: tags
  properties: {
    features: {
      searchVersion: logAnalyticsSearchVersion
      enableLogAccessUsingOnlyResourcePermissions: useResourcePermissions
    }
    sku: {
      name: serviceTier
    }
    retentionInDays: dataRetention
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

module logAnalyticsWorkspace_storageInsightConfigs 'storageInsightConfigs/deploy.bicep' = [for (storageInsightsConfig, index) in storageInsightsConfigs: {
  name: '${uniqueString(deployment().name, location)}-LAW-StorageInsightsConfig-${index}'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.name
    containers: contains(storageInsightsConfig, 'containers') ? storageInsightsConfig.containers : []
    tables: contains(storageInsightsConfig, 'tables') ? storageInsightsConfig.tables : []
    storageAccountId: storageInsightsConfig.storageAccountId
  }
}]

module logAnalyticsWorkspace_linkedServices 'linkedServices/deploy.bicep' = [for (linkedService, index) in linkedServices: {
  name: '${uniqueString(deployment().name, location)}-LAW-LinkedService-${index}'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.name
    name: linkedService.name
    resourceId: linkedService.resourceId
    writeAccessResourceId: contains(linkedService, 'writeAccessResourceId') ? linkedService.writeAccessResourceId : ''
  }
}]

module logAnalyticsWorkspace_savedSearches 'savedSearches/deploy.bicep' = [for (savedSearch, index) in savedSearches: {
  name: '${uniqueString(deployment().name, location)}-LAW-SavedSearch-${index}'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.name
    name: '${savedSearch.name}${uniqueString(deployment().name)}'
    displayName: savedSearch.displayName
    category: savedSearch.category
    query: savedSearch.query
    functionAlias: contains(savedSearch, 'functionAlias') ? savedSearch.functionAlias : ''
    functionParameters: contains(savedSearch, 'functionParameters') ? savedSearch.functionParameters : ''
    version: contains(savedSearch, 'version') ? savedSearch.version : 2
  }
}]

module logAnalyticsWorkspace_dataSources 'dataSources/deploy.bicep' = [for (dataSource, index) in dataSources: {
  name: '${uniqueString(deployment().name, location)}-LAW-DataSource-${index}'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.name
    name: dataSource.name
    kind: dataSource.kind
    linkedResourceId: contains(dataSource, 'linkedResourceId') ? dataSource.linkedResourceId : ''
    eventLogName: contains(dataSource, 'eventLogName') ? dataSource.eventLogName : ''
    eventTypes: contains(dataSource, 'eventTypes') ? dataSource.eventTypes : []
    objectName: contains(dataSource, 'objectName') ? dataSource.objectName : ''
    instanceName: contains(dataSource, 'instanceName') ? dataSource.instanceName : ''
    intervalSeconds: contains(dataSource, 'intervalSeconds') ? dataSource.intervalSeconds : 60
    counterName: contains(dataSource, 'counterName') ? dataSource.counterName : ''
    state: contains(dataSource, 'state') ? dataSource.state : ''
    syslogName: contains(dataSource, 'syslogName') ? dataSource.syslogName : ''
    syslogSeverities: contains(dataSource, 'syslogSeverities') ? dataSource.syslogSeverities : []
    performanceCounters: contains(dataSource, 'performanceCounters') ? dataSource.performanceCounters : []
  }
}]

@batchSize(1) // Serial loop deployment
module logAnalyticsWorkspace_solutions '.bicep/nested_solutions.bicep' = [for (gallerySolution, index) in gallerySolutions: if (!empty(gallerySolutions)) {
  name: '${uniqueString(deployment().name, location)}-LAW-Solution-${index}'
  params: {
    gallerySolution: gallerySolution.name
    location: location
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.name
    product: gallerySolution.product
    publisher: gallerySolution.publisher
  }
}]

resource logAnalyticsWorkspace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${logAnalyticsWorkspace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: logAnalyticsWorkspace
}

module logAnalyticsWorkspace_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-LAW-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: logAnalyticsWorkspace.id
  }
}]

@description('The resource ID of the deployed log analytics workspace')
output logAnalyticsResourceId string = logAnalyticsWorkspace.id

@description('The resource group where the log analytics will be deployed')
output logAnalyticsResourceGroup string = resourceGroup().name

@description('The name of the deployed log analytics workspace')
output logAnalyticsName string = logAnalyticsWorkspace.name

@description('The ID associated with the workspace')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.properties.customerId
