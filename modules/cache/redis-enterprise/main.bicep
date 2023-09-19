metadata name = 'Redis Cache Enterprise'
metadata description = 'This module deploys a Redis Cache Enterprise.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Cache Enterprise resource.')
param name string

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. Requires clients to use a specified TLS version (or higher) to connect.')
param minimumTlsVersion string = '1.2'

@description('Optional. The size of the Redis Enterprise Cluster. Defaults to 2. Valid values are (2, 4, 6, ...) for Enterprise SKUs and (3, 9, 15, ...) for Flash SKUs.')
param capacity int = 2

@allowed([
  'EnterpriseFlash_F1500'
  'EnterpriseFlash_F300'
  'EnterpriseFlash_F700'
  'Enterprise_E10'
  'Enterprise_E100'
  'Enterprise_E20'
  'Enterprise_E50'
])
@description('Optional. The type of Redis Enterprise Cluster to deploy.')
param skuName string = 'Enterprise_E10'

@description('Optional. When true, the cluster will be deployed across availability zones.')
param zoneRedundant bool = true

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. The databases to create in the Redis Cache Enterprise Cluster.')
param databases array = []

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource, but currently not supported for Redis Cache Enterprise. Set to \'\' to disable log collection.')
@allowed([
  ''
  // 'allLogs'
  'ConnectionEvents'
  'audit'
])
param diagnosticLogCategoriesToEnable array = [
  ''
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var availabilityZones = zoneRedundant ? pickZones('Microsoft.Cache', 'redisEnterprise', location, 3) : []

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource redisCacheEnterprise 'Microsoft.Cache/redisEnterprise@2022-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: capacity
    name: skuName
  }
  properties: {
    minimumTlsVersion: minimumTlsVersion
  }
  zones: availabilityZones
}

resource redisCacheEnterprise_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${redisCacheEnterprise.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: redisCacheEnterprise
}

resource redisCacheEnterprise_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsLogs
  }
  scope: redisCacheEnterprise
}

module redisCacheEnterprise_rbac '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-redisCacheEnterprise-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: redisCacheEnterprise.id
  }
}]

module redisCacheEnterprise_databases 'database/main.bicep' = [for (database, index) in databases: {
  name: '${uniqueString(deployment().name, location)}-redisCacheEnterprise-DB-${index}'
  params: {
    redisCacheEnterpriseName: redisCacheEnterprise.name
    location: location
    clientProtocol: contains(database, 'clientProtocol') ? database.clientProtocol : 'Encrypted'
    clusteringPolicy: contains(database, 'clusteringPolicy') ? database.clusteringPolicy : 'OSSCluster'
    evictionPolicy: contains(database, 'evictionPolicy') ? database.evictionPolicy : 'VolatileLRU'
    geoReplication: contains(database, 'geoReplication') ? database.geoReplication : {}
    modules: contains(database, 'modules') ? database.modules : []
    persistenceAofEnabled: contains(database, 'persistenceAofEnabled') ? database.persistenceAofEnabled : false
    persistenceAofFrequency: contains(database, 'persistenceAofFrequency') ? database.persistenceAofFrequency : ''
    persistenceRdbEnabled: contains(database, 'persistenceRdbEnabled') ? database.persistenceRdbEnabled : false
    persistenceRdbFrequency: contains(database, 'persistenceRdbFrequency') ? database.persistenceRdbFrequency : ''
    port: contains(database, 'port') ? database.port : -1
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module redisCacheEnterprise_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-redisCacheEnterprise-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(redisCacheEnterprise.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: redisCacheEnterprise.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

@description('The name of the redis cache enterprise.')
output name string = redisCacheEnterprise.name

@description('The resource ID of the redis cache enterprise.')
output resourceId string = redisCacheEnterprise.id

@description('The name of the resource group the redis cache enterprise was created in.')
output resourceGroupName string = resourceGroup().name

@description('Redis hostname.')
output hostName string = redisCacheEnterprise.properties.hostName

@description('The location the resource was deployed into.')
output location string = redisCacheEnterprise.location
