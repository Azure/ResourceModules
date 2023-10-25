metadata name = 'Redis Cache Enterprise'
metadata description = 'This module deploys a Redis Cache Enterprise.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Cache Enterprise resource.')
param name string

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

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
param privateEndpoints privateEndpointType

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

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Redis Cache Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e0f68234-74aa-48ed-b826-c38b57376e17')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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

resource redisEnterprise 'Microsoft.Cache/redisEnterprise@2022-01-01' = {
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

resource redisEnterprise_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: redisEnterprise
}

resource redisEnterprise_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsLogs
  }
  scope: redisEnterprise
}

resource redisEnterprise_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(redisEnterprise.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: redisEnterprise
}]

module redisEnterprise_databases 'database/main.bicep' = [for (database, index) in databases: {
  name: '${uniqueString(deployment().name, location)}-redisCacheEnterprise-DB-${index}'
  params: {
    redisCacheEnterpriseName: redisEnterprise.name
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

module redisEnterprise_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-redisEnterprise-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'redisEnterprise'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(redisEnterprise.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
    serviceResourceId: redisEnterprise.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

@description('The name of the redis cache enterprise.')
output name string = redisEnterprise.name

@description('The resource ID of the redis cache enterprise.')
output resourceId string = redisEnterprise.id

@description('The name of the resource group the redis cache enterprise was created in.')
output resourceGroupName string = resourceGroup().name

@description('Redis hostname.')
output hostName string = redisEnterprise.properties.hostName

@description('The location the resource was deployed into.')
output location string = redisEnterprise.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    fqdn: string?
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    name: string
    groupId: string
    memberName: string
    privateIpAddress: string
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?
