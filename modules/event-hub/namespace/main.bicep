metadata name = 'Event Hub Namespaces'
metadata description = 'This module deploys an Event Hub Namespace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the event hub namespace.')
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. event hub plan SKU name.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Standard'

@description('Optional. The Event Hub\'s throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units.')
@minValue(1)
@maxValue(20)
param skuCapacity int = 1

@description('Optional. Switch to make the Event Hub Namespace zone redundant.')
param zoneRedundant bool = false

@description('Optional. Switch to enable the Auto Inflate feature of Event Hub. Auto Inflate is not supported in Premium SKU EventHub.')
param isAutoInflateEnabled bool = false

@description('Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units.')
@minValue(0)
@maxValue(20)
param maximumThroughputUnits int = 1

@description('Optional. Authorization Rules for the Event Hub namespace.')
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

@description('Optional. This property disables SAS authentication for the Event Hubs namespace.')
param disableLocalAuth bool = true

@description('Optional. Value that indicates whether Kafka is enabled for Event Hubs Namespace.')
param kafkaEnabled bool = false

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. The minimum TLS version for the cluster to support.')
param minimumTlsVersion string = '1.2'

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Configure networking options. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets object = {}

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

@description('Optional. The name of the customer managed key to use for encryption. Customer-managed key encryption at rest is only available for namespaces of premium SKU or namespaces created in a Dedicated Cluster.')
param cMKKeyName string = ''

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
param requireInfrastructureEncryption bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The event hubs to deploy into this namespace.')
param eventhubs array = []

@description('Optional. The disaster recovery config for this namespace.')
param disasterRecoveryConfig object = {}

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'ArchiveLogs'
  'OperationalLogs'
  'AutoScaleLogs'
  'KafkaCoordinatorLogs'
  'KafkaUserErrorLogs'
  'EventHubVNetConnectionEvent'
  'CustomerManagedKeyUserLogs'
  'RuntimeAuditLogs'
  'ApplicationMetricsLogs'
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

var maximumThroughputUnitsVar = !isAutoInflateEnabled ? 0 : maximumThroughputUnits

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

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

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(cMKKeyName)) {
    name: cMKKeyName
  }
}

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

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    tier: skuName
    capacity: skuCapacity
  }
  properties: {
    disableLocalAuth: disableLocalAuth
    encryption: !empty(cMKKeyName) ? {
      keySource: 'Microsoft.KeyVault'
      keyVaultProperties: [
        {
          identity: !empty(cMKUserAssignedIdentityResourceId) ? {
            userAssignedIdentity: cMKUserAssignedIdentityResourceId
          } : null
          keyName: cMKKeyName
          keyVaultUri: cMKKeyVault.properties.vaultUri
          keyVersion: !empty(cMKKeyVersion) ? cMKKeyVersion : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
        }
      ]
      requireInfrastructureEncryption: requireInfrastructureEncryption
    } : null
    isAutoInflateEnabled: isAutoInflateEnabled
    kafkaEnabled: kafkaEnabled
    maximumThroughputUnits: maximumThroughputUnitsVar
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: contains(networkRuleSets, 'publicNetworkAccess') ? networkRuleSets.publicNetworkAccess : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : publicNetworkAccess)
    zoneRedundant: zoneRedundant
  }
}

module eventHubNamespace_authorizationRules 'authorization-rule/main.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-AuthRule-${index}'
  params: {
    namespaceName: eventHubNamespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module eventHubNamespace_disasterRecoveryConfig 'disaster-recovery-config/main.bicep' = if (!empty(disasterRecoveryConfig)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-DisRecConfig'
  params: {
    namespaceName: eventHubNamespace.name
    name: disasterRecoveryConfig.name
    partnerNamespaceId: contains(disasterRecoveryConfig, 'partnerNamespaceId') ? disasterRecoveryConfig.partnerNamespaceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module eventHubNamespace_eventhubs 'eventhub/main.bicep' = [for (eventHub, index) in eventhubs: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-EventHub-${index}'
  params: {
    namespaceName: eventHubNamespace.name
    name: eventHub.name
    authorizationRules: contains(eventHub, 'authorizationRules') ? eventHub.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    ]
    captureDescriptionDestinationArchiveNameFormat: contains(eventHub, 'captureDescriptionDestinationArchiveNameFormat') ? eventHub.captureDescriptionDestinationArchiveNameFormat : '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
    captureDescriptionDestinationBlobContainer: contains(eventHub, 'captureDescriptionDestinationBlobContainer') ? eventHub.captureDescriptionDestinationBlobContainer : ''
    captureDescriptionDestinationName: contains(eventHub, 'captureDescriptionDestinationName') ? eventHub.captureDescriptionDestinationName : 'EventHubArchive.AzureBlockBlob'
    captureDescriptionDestinationStorageAccountResourceId: contains(eventHub, 'captureDescriptionDestinationStorageAccountResourceId') ? eventHub.captureDescriptionDestinationStorageAccountResourceId : ''
    captureDescriptionEnabled: contains(eventHub, 'captureDescriptionEnabled') ? eventHub.captureDescriptionEnabled : false
    captureDescriptionEncoding: contains(eventHub, 'captureDescriptionEncoding') ? eventHub.captureDescriptionEncoding : 'Avro'
    captureDescriptionIntervalInSeconds: contains(eventHub, 'captureDescriptionIntervalInSeconds') ? eventHub.captureDescriptionIntervalInSeconds : 300
    captureDescriptionSizeLimitInBytes: contains(eventHub, 'captureDescriptionSizeLimitInBytes') ? eventHub.captureDescriptionSizeLimitInBytes : 314572800
    captureDescriptionSkipEmptyArchives: contains(eventHub, 'captureDescriptionSkipEmptyArchives') ? eventHub.captureDescriptionSkipEmptyArchives : false
    consumergroups: contains(eventHub, 'consumergroups') ? eventHub.consumergroups : []
    lock: contains(eventHub, 'lock') ? eventHub.lock : ''
    messageRetentionInDays: contains(eventHub, 'messageRetentionInDays') ? eventHub.messageRetentionInDays : 1
    partitionCount: contains(eventHub, 'partitionCount') ? eventHub.partitionCount : 2
    roleAssignments: contains(eventHub, 'roleAssignments') ? eventHub.roleAssignments : []
    status: contains(eventHub, 'status') ? eventHub.status : 'Active'
    retentionDescriptionCleanupPolicy: contains(eventHub, 'retentionDescriptionCleanupPolicy') ? eventHub.retentionDescriptionCleanupPolicy : 'Delete'
    retentionDescriptionRetentionTimeInHours: contains(eventHub, 'retentionDescriptionRetentionTimeInHours') ? eventHub.retentionDescriptionRetentionTimeInHours : 1
    retentionDescriptionTombstoneRetentionTimeInHours: contains(eventHub, 'retentionDescriptionTombstoneRetentionTimeInHours') ? eventHub.retentionDescriptionTombstoneRetentionTimeInHours : 1
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module eventHubNamespace_networkRuleSet 'network-rule-set/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-NetworkRuleSet'
  params: {
    namespaceName: eventHubNamespace.name
    publicNetworkAccess: contains(networkRuleSets, 'publicNetworkAccess') ? networkRuleSets.publicNetworkAccess : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    defaultAction: contains(networkRuleSets, 'defaultAction') ? networkRuleSets.defaultAction : 'Allow'
    trustedServiceAccessEnabled: contains(networkRuleSets, 'trustedServiceAccessEnabled') ? networkRuleSets.trustedServiceAccessEnabled : true
    ipRules: contains(networkRuleSets, 'ipRules') ? networkRuleSets.ipRules : []
    virtualNetworkRules: contains(networkRuleSets, 'virtualNetworkRules') ? networkRuleSets.virtualNetworkRules : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module eventHubNamespace_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(eventHubNamespace.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: eventHubNamespace.id
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

module eventHubNamespace_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: eventHubNamespace.id
  }
}]

resource eventHubNamespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${eventHubNamespace.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: eventHubNamespace
}

resource eventHubNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: eventHubNamespace
}

@description('The name of the eventspace.')
output name string = eventHubNamespace.name

@description('The resource ID of the eventspace.')
output resourceId string = eventHubNamespace.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(eventHubNamespace.identity, 'principalId') ? eventHubNamespace.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = eventHubNamespace.location
