metadata name = 'Redis Cache'
metadata description = 'This module deploys a Redis Cache.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The location to deploy the Redis cache service.')
param location string = resourceGroup().location

@description('Required. The name of the Redis cache resource.')
param name string

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Specifies whether the non-ssl Redis server port (6379) is enabled.')
param enableNonSslPort bool = false

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. Requires clients to use a specified TLS version (or higher) to connect.')
param minimumTlsVersion string = '1.2'

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc.')
param redisConfiguration object = {}

@allowed([
  '4'
  '6'
])
@description('Optional. Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6).')
param redisVersion string = '6'

@minValue(1)
@description('Optional. The number of replicas to be created per primary.')
param replicasPerMaster int = 1

@minValue(1)
@description('Optional. The number of replicas to be created per primary.')
param replicasPerPrimary int = 1

@minValue(1)
@description('Optional. The number of shards to be created on a Premium Cluster Cache.')
param shardCount int = 1

@allowed([
  0
  1
  2
  3
  4
  5
  6
])
@description('Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).')
param capacity int = 1

@allowed([
  'Basic'
  'Premium'
  'Standard'
])
@description('Optional. The type of Redis cache to deploy.')
param skuName string = 'Basic'

@description('Optional. Static IP address. Optionally, may be specified when deploying a Redis cache inside an existing Azure Virtual Network; auto assigned by default.')
param staticIP string = ''

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1.')
param subnetId string = ''

@description('Optional. A dictionary of tenant settings.')
param tenantSettings object = {}

@description('Optional. When true, replicas will be provisioned in availability zones specified in the zones parameter.')
param zoneRedundant bool = true

@description('Optional. If the zoneRedundant parameter is true, replicas will be provisioned in the availability zones specified here. Otherwise, the service will choose where replicas are deployed.')
param zones array = []

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

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

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'ConnectedClientList'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
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

var availabilityZones = skuName == 'Premium' ? zoneRedundant ? !empty(zones) ? zones : pickZones('Microsoft.Cache', 'redis', location, 3) : [] : []

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

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourcesIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

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

resource redis 'Microsoft.Cache/redis@2022-06-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : null)
    redisConfiguration: !empty(redisConfiguration) ? redisConfiguration : null
    redisVersion: redisVersion
    replicasPerMaster: skuName == 'Premium' ? replicasPerMaster : null
    replicasPerPrimary: skuName == 'Premium' ? replicasPerPrimary : null
    shardCount: skuName == 'Premium' ? shardCount : null // Not supported in free tier
    sku: {
      capacity: capacity
      family: skuName == 'Premium' ? 'P' : 'C'
      name: skuName
    }
    staticIP: !empty(staticIP) ? staticIP : null
    subnetId: !empty(subnetId) ? subnetId : null
    tenantSettings: tenantSettings
  }
  zones: availabilityZones
}

resource redis_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: redis
}

resource redis_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsLogs
  }
  scope: redis
}

resource redis_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(redis.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: redis
}]

module redis_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-redisCache-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(redis.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: redis.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: contains(privateEndpoint, 'privateDnsZoneGroupName') ? privateEndpoint.privateDnsZoneGroupName : 'default'
    privateDnsZoneResourceIds: contains(privateEndpoint, 'privateDnsZoneResourceIds') ? privateEndpoint.privateDnsZoneResourceIds : []
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroupResourceIds: contains(privateEndpoint, 'applicationSecurityGroupResourceIds') ? privateEndpoint.applicationSecurityGroupResourceIds : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

@description('The name of the Redis Cache.')
output name string = redis.name

@description('The resource ID of the Redis Cache.')
output resourceId string = redis.id

@description('The name of the resource group the Redis Cache was created in.')
output resourceGroupName string = resourceGroup().name

@description('Redis hostname.')
output hostName string = redis.properties.hostName

@description('Redis SSL port.')
output sslPort int = redis.properties.sslPort

@description('The full resource ID of a subnet in a virtual network where the Redis Cache was deployed in.')
output subnetId string = !empty(subnetId) ? redis.properties.subnetId : ''

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(redis.identity, 'principalId') ? redis.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = redis.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourcesIds: string[]?
}?

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
