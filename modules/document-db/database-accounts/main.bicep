@description('Required. Name of the Database Account.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Database Account resource.')
param tags object = {}

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. The offer type for the Cosmos DB database account.')
@allowed([
  'Standard'
])
param databaseAccountOfferType string = 'Standard'

@description('Required. Locations enabled for the Cosmos DB account.')
param locations array

@allowed([
  'Eventual'
  'ConsistentPrefix'
  'Session'
  'BoundedStaleness'
  'Strong'
])
@description('Optional. The default consistency level of the Cosmos DB account.')
param defaultConsistencyLevel string = 'Session'

@description('Optional. Enable automatic failover for regions.')
param automaticFailover bool = true

@description('Optional. Flag to indicate whether Free Tier is enabled.')
param enableFreeTier bool = false

@minValue(10)
@maxValue(2147483647)
@description('Optional. Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000.')
param maxStalenessPrefix int = 100000

@minValue(5)
@maxValue(86400)
@description('Optional. Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
param maxIntervalInSeconds int = 300

@description('Optional. Specifies the MongoDB server version to use.')
@allowed([
  '3.2'
  '3.6'
  '4.0'
  '4.2'
])
param serverVersion string = '4.2'

@description('Optional. SQL Databases configurations.')
param sqlDatabases array = []

@description('Optional. MongoDB Databases configurations.')
param mongodbDatabases array = []

@description('Optional. Gremlin Databases configurations.')
param gremlinDatabases array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'DataPlaneRequests'
  'MongoRequests'
  'QueryRuntimeStatistics'
  'PartitionKeyStatistics'
  'PartitionKeyRUConsumption'
  'ControlPlaneRequests'
  'CassandraRequests'
  'GremlinRequests'
  'TableApiRequests'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Requests'
])
param diagnosticMetricsToEnable array = [
  'Requests'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@allowed([
  'EnableCassandra'
  'EnableTable'
  'EnableGremlin'
  'EnableMongo'
  'DisableRateLimitingResponses'
  'EnableServerless'
])
@description('Optional. List of Cosmos DB capabilities for the account.')
param capabilitiesToAdd array = []

@allowed([
  'Periodic'
  'Continuous'
])
@description('Optional. Describes the mode of backups.')
param backupPolicyType string = 'Continuous'

@allowed([
  'Continuous30Days'
  'Continuous7Days'
])
@description('Optional. Configuration values for continuous mode backup.')
param backupPolicyContinuousTier string = 'Continuous30Days'

@minValue(60)
@maxValue(1440)
@description('Optional. An integer representing the interval in minutes between two backups. Only applies to periodic backup type.')
param backupIntervalInMinutes int = 240

@minValue(2)
@maxValue(720)
@description('Optional. An integer representing the time (in hours) that each backup is retained. Only applies to periodic backup type.')
param backupRetentionIntervalInHours int = 8

@allowed([
  'Geo'
  'Local'
  'Zone'
])
@description('Optional. Enum to indicate type of backup residency. Only applies to periodic backup type.')
param backupStorageRedundancy string = 'Local'

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var consistencyPolicy = {
  Eventual: {
    defaultConsistencyLevel: 'Eventual'
  }
  ConsistentPrefix: {
    defaultConsistencyLevel: 'ConsistentPrefix'
  }
  Session: {
    defaultConsistencyLevel: 'Session'
  }
  BoundedStaleness: {
    defaultConsistencyLevel: 'BoundedStaleness'
    maxStalenessPrefix: maxStalenessPrefix
    maxIntervalInSeconds: maxIntervalInSeconds
  }
  Strong: {
    defaultConsistencyLevel: 'Strong'
  }
}

var databaseAccount_locations = [for location in locations: {
  failoverPriority: location.failoverPriority
  isZoneRedundant: location.isZoneRedundant
  locationName: location.locationName
}]

var kind = !empty(sqlDatabases) || !empty(gremlinDatabases) ? 'GlobalDocumentDB' : (!empty(mongodbDatabases) ? 'MongoDB' : 'Parse')

var enableReferencedModulesTelemetry = false

var capabilities = [for capability in capabilitiesToAdd: {
  name: capability
}]

var backupPolicy = backupPolicyType == 'Continuous' ? {
  type: backupPolicyType
  continuousModeProperties: {
    tier: backupPolicyContinuousTier
  }
} : {
  type: backupPolicyType
  periodicModeProperties: {
    backupIntervalInMinutes: backupIntervalInMinutes
    backupRetentionIntervalInHours: backupRetentionIntervalInHours
    backupStorageRedundancy: backupStorageRedundancy
  }
}

var databaseAccount_properties = union({
    databaseAccountOfferType: databaseAccountOfferType
  }, ((!empty(sqlDatabases) || !empty(mongodbDatabases) || !empty(gremlinDatabases)) ? {
    // Common properties
    consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
    locations: databaseAccount_locations
    capabilities: capabilities
    enableFreeTier: enableFreeTier
    backupPolicy: backupPolicy
  } : {}), (!empty(sqlDatabases) ? {
    // SQLDB properties
    enableAutomaticFailover: automaticFailover
  } : {}), (!empty(mongodbDatabases) ? {
    // MongoDb properties
    apiProperties: {
      serverVersion: serverVersion
    }
  } : {}))

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
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

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: name
  location: location
  tags: tags
  identity: identity
  kind: kind
  properties: databaseAccount_properties
}

resource databaseAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${databaseAccount.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: databaseAccount
}

resource databaseAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: databaseAccount
}

module databaseAccount_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: databaseAccount.id
  }
}]

module databaseAccount_sqlDatabases 'sql-databases/main.bicep' = [for sqlDatabase in sqlDatabases: {
  name: '${uniqueString(deployment().name, location)}-sqldb-${sqlDatabase.name}'
  params: {
    databaseAccountName: databaseAccount.name
    name: sqlDatabase.name
    containers: contains(sqlDatabase, 'containers') ? sqlDatabase.containers : []
    throughput: contains(sqlDatabase, 'throughput') ? sqlDatabase.throughput : 400
    autoscaleSettingsMaxThroughput: contains(sqlDatabase, 'autoscaleSettingsMaxThroughput') ? sqlDatabase.autoscaleSettingsMaxThroughput : -1
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module databaseAccount_mongodbDatabases 'mongodb-databases/main.bicep' = [for mongodbDatabase in mongodbDatabases: {
  name: '${uniqueString(deployment().name, location)}-mongodb-${mongodbDatabase.name}'
  params: {
    databaseAccountName: databaseAccount.name
    name: mongodbDatabase.name
    collections: contains(mongodbDatabase, 'collections') ? mongodbDatabase.collections : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module databaseAccount_gremlinDatabases 'gremlin-databases/main.bicep' = [for gremlinDatabase in gremlinDatabases: {
  name: '${uniqueString(deployment().name, location)}-gremlin-${gremlinDatabase.name}'
  params: {
    databaseAccountName: databaseAccount.name
    name: gremlinDatabase.name
    graphs: contains(gremlinDatabase, 'graphs') ? gremlinDatabase.graphs : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the database account.')
output name string = databaseAccount.name

@description('The resource ID of the database account.')
output resourceId string = databaseAccount.id

@description('The name of the resource group the database account was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(databaseAccount.identity, 'principalId') ? databaseAccount.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = databaseAccount.location
