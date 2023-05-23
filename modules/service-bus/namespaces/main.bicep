@description('Required. Name of the Service Bus Namespace.')
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of this SKU. - Basic, Standard, Premium.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Basic'

@description('Optional. Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones.')
param zoneRedundant bool = false

@description('Optional. Authorization Rules for the Service Bus namespace.')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
]

@description('Optional. The migration configuration.')
param migrationConfigurations object = {}

@description('Optional. The disaster recovery configuration.')
param disasterRecoveryConfigs object = {}

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

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Configure networking options for Premium SKU Service Bus. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets object = {}

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The queues to create in the service bus namespace.')
param queues array = []

@description('Optional. The topics to create in the service bus namespace.')
param topics array = []

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption. If not provided, encryption is automatically enabled with a Microsoft-managed key.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Optional. User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
param requireInfrastructureEncryption bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'OperationalLogs'
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

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

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

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource cMKKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId) && !empty(cMKKeyName)) {
  name: '${last(split(cMKKeyVaultResourceId, '/'))}/${cMKKeyName}'!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: name
  location: location
  tags: empty(tags) ? null : tags
  sku: {
    name: skuName
  }
  identity: identity
  properties: {
    zoneRedundant: zoneRedundant
    encryption: !empty(cMKKeyName) ? {
      keySource: 'Microsoft.KeyVault'
      keyVaultProperties: [
        {
          identity: !empty(cMKUserAssignedIdentityResourceId) ? {
            userAssignedIdentity: cMKUserAssignedIdentityResourceId
          } : null
          keyName: cMKKeyName
          keyVaultUri: cMKKeyVault.properties.vaultUri
          keyVersion: !empty(cMKKeyVersion) ? cMKKeyVersion : last(split(cMKKeyVaultKey.properties.keyUriWithVersion, '/'))
        }
      ]
      requireInfrastructureEncryption: requireInfrastructureEncryption
    } : null
  }
}

module serviceBusNamespace_authorizationRules 'authorization-rules/main.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-AuthorizationRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module serviceBusNamespace_disasterRecoveryConfig 'disaster-recovery-configs/main.bicep' = if (!empty(disasterRecoveryConfigs)) {
  name: '${uniqueString(deployment().name, location)}-DisasterRecoveryConfig'
  params: {
    namespaceName: serviceBusNamespace.name
    name: contains(disasterRecoveryConfigs, 'name') ? disasterRecoveryConfigs.name : 'default'
    alternateName: contains(disasterRecoveryConfigs, 'alternateName') ? disasterRecoveryConfigs.alternateName : ''
    partnerNamespaceResourceID: contains(disasterRecoveryConfigs, 'partnerNamespace') ? disasterRecoveryConfigs.partnerNamespace : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module serviceBusNamespace_migrationConfigurations 'migration-configurations/main.bicep' = if (!empty(migrationConfigurations)) {
  name: '${uniqueString(deployment().name, location)}-MigrationConfigurations'
  params: {
    namespaceName: serviceBusNamespace.name
    postMigrationName: migrationConfigurations.postMigrationName
    targetNamespaceResourceId: migrationConfigurations.targetNamespace
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module serviceBusNamespace_networkRuleSet 'network-rule-sets/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-NetworkRuleSet'
  params: {
    namespaceName: serviceBusNamespace.name
    publicNetworkAccess: contains(networkRuleSets, 'publicNetworkAccess') ? networkRuleSets.publicNetworkAccess : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    defaultAction: contains(networkRuleSets, 'defaultAction') ? networkRuleSets.defaultAction : 'Allow'
    trustedServiceAccessEnabled: contains(networkRuleSets, 'trustedServiceAccessEnabled') ? networkRuleSets.trustedServiceAccessEnabled : true
    ipRules: contains(networkRuleSets, 'ipRules') ? networkRuleSets.ipRules : []
    virtualNetworkRules: contains(networkRuleSets, 'virtualNetworkRules') ? networkRuleSets.virtualNetworkRules : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module serviceBusNamespace_queues 'queues/main.bicep' = [for (queue, index) in queues: {
  name: '${uniqueString(deployment().name, location)}-Queue-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: queue.name
    authorizationRules: contains(queue, 'authorizationRules') ? queue.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    ]
    deadLetteringOnMessageExpiration: contains(queue, 'deadLetteringOnMessageExpiration') ? queue.deadLetteringOnMessageExpiration : true
    defaultMessageTimeToLive: contains(queue, 'defaultMessageTimeToLive') ? queue.defaultMessageTimeToLive : 'P14D'
    duplicateDetectionHistoryTimeWindow: contains(queue, 'duplicateDetectionHistoryTimeWindow') ? queue.duplicateDetectionHistoryTimeWindow : 'PT10M'
    enableBatchedOperations: contains(queue, 'enableBatchedOperations') ? queue.enableBatchedOperations : true
    enableExpress: contains(queue, 'enableExpress') ? queue.enableExpress : false
    enablePartitioning: contains(queue, 'enablePartitioning') ? queue.enablePartitioning : false
    lock: contains(queue, 'lock') ? queue.lock : ''
    lockDuration: contains(queue, 'lockDuration') ? queue.lockDuration : 'PT1M'
    maxDeliveryCount: contains(queue, 'maxDeliveryCount') ? queue.maxDeliveryCount : 10
    maxSizeInMegabytes: contains(queue, 'maxSizeInMegabytes') ? queue.maxSizeInMegabytes : 1024
    requiresDuplicateDetection: contains(queue, 'requiresDuplicateDetection') ? queue.requiresDuplicateDetection : false
    requiresSession: contains(queue, 'requiresSession') ? queue.requiresSession : false
    roleAssignments: contains(queue, 'roleAssignments') ? queue.roleAssignments : []
    status: contains(queue, 'status') ? queue.status : 'Active'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module serviceBusNamespace_topics 'topics/main.bicep' = [for (topic, index) in topics: {
  name: '${uniqueString(deployment().name, location)}-Topic-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: topic.name
    authorizationRules: contains(topic, 'authorizationRules') ? topic.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    ]
    autoDeleteOnIdle: contains(topic, 'autoDeleteOnIdle') ? topic.autoDeleteOnIdle : 'PT5M'
    defaultMessageTimeToLive: contains(topic, 'defaultMessageTimeToLive') ? topic.defaultMessageTimeToLive : 'P14D'
    duplicateDetectionHistoryTimeWindow: contains(topic, 'duplicateDetectionHistoryTimeWindow') ? topic.duplicateDetectionHistoryTimeWindow : 'PT10M'
    enableBatchedOperations: contains(topic, 'enableBatchedOperations') ? topic.enableBatchedOperations : true
    enableExpress: contains(topic, 'enableExpress') ? topic.enableExpress : false
    enablePartitioning: contains(topic, 'enablePartitioning') ? topic.enablePartitioning : false
    lock: contains(topic, 'lock') ? topic.lock : ''
    maxMessageSizeInKilobytes: contains(topic, 'maxMessageSizeInKilobytes') ? topic.maxMessageSizeInKilobytes : 1024
    maxSizeInMegabytes: contains(topic, 'maxSizeInMegabytes') ? topic.maxSizeInMegabytes : 1024
    requiresDuplicateDetection: contains(topic, 'requiresDuplicateDetection') ? topic.requiresDuplicateDetection : false
    roleAssignments: contains(topic, 'roleAssignments') ? topic.roleAssignments : []
    status: contains(topic, 'status') ? topic.status : 'Active'
    supportOrdering: contains(topic, 'supportOrdering') ? topic.supportOrdering : false
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource serviceBusNamespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${serviceBusNamespace.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: serviceBusNamespace
}

resource serviceBusNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: serviceBusNamespace
}

module serviceBusNamespace_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Namespace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(serviceBusNamespace.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: serviceBusNamespace.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module serviceBusNamespace_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: serviceBusNamespace.id
  }
}]

@description('The resource ID of the deployed service bus namespace.')
output resourceId string = serviceBusNamespace.id

@description('The resource group of the deployed service bus namespace.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed service bus namespace.')
output name string = serviceBusNamespace.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(serviceBusNamespace.identity, 'principalId') ? serviceBusNamespace.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = serviceBusNamespace.location
