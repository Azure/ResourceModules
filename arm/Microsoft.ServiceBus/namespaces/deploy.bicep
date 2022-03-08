@description('Optional. Name of the Service Bus Namespace. If no name is provided, then unique name will be created.')
@maxLength(50)
param name string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Name of this SKU. - Basic, Standard, Premium')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Basic'

@description('Optional. Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones.')
param zoneRedundant bool = false

@description('Optional. Authorization Rules for the Service Bus namespace')
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

@description('Optional. IP Filter Rules for the Service Bus namespace')
param ipFilterRules array = []

@description('Optional. The migration configuration.')
param migrationConfigurations object = {}

@description('Optional. The disaster recovery configuration.')
param disasterRecoveryConfigs object = {}

@description('Optional. vNet Rules SubnetIds for the Service Bus namespace.')
param virtualNetworkRules array = []

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
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow('u')

@description('Optional. The queues to create in the service bus namespace')
param queues array = []

@description('Optional. The topics to create in the service bus namespace')
param topics array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'OperationalLogs'
])
param logsToEnable array = [
  'OperationalLogs'
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

var maxNameLength = 50
var uniqueServiceBusNamespaceNameUntrim = uniqueString('Service Bus Namespace${baseTime}')
var uniqueServiceBusNamespaceName = ((length(uniqueServiceBusNamespaceNameUntrim) > maxNameLength) ? substring(uniqueServiceBusNamespaceNameUntrim, 0, maxNameLength) : uniqueServiceBusNamespaceNameUntrim)

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: !empty(name) ? name : uniqueServiceBusNamespaceName
  location: location
  tags: empty(tags) ? null : tags
  sku: {
    name: skuName
  }
  identity: identity
  properties: {
    zoneRedundant: zoneRedundant
  }
}

module serviceBusNamespace_disasterRecoveryConfig 'disasterRecoveryConfigs/deploy.bicep' = if (!empty(disasterRecoveryConfigs)) {
  name: '${uniqueString(deployment().name, location)}-DisasterRecoveryConfig'
  params: {
    namespaceName: serviceBusNamespace.name
    name: contains(disasterRecoveryConfigs, 'name') ? disasterRecoveryConfigs.name : 'default'
    alternateName: contains(disasterRecoveryConfigs, 'alternateName') ? disasterRecoveryConfigs.alternateName : ''
    partnerNamespaceResourceID: contains(disasterRecoveryConfigs, 'partnerNamespace') ? disasterRecoveryConfigs.partnerNamespace : ''
  }
}

module serviceBusNamespace_migrationConfigurations 'migrationConfigurations/deploy.bicep' = if (!empty(migrationConfigurations)) {
  name: '${uniqueString(deployment().name, location)}-MigrationConfigurations'
  params: {
    namespaceName: serviceBusNamespace.name
    name: contains(migrationConfigurations, 'name') ? migrationConfigurations.name : '$default'
    postMigrationName: migrationConfigurations.postMigrationName
    targetNamespaceResourceId: migrationConfigurations.targetNamespace
  }
}

module serviceBusNamespace_virtualNetworkRules 'virtualNetworkRules/deploy.bicep' = [for (virtualNetworkRule, index) in virtualNetworkRules: {
  name: '${uniqueString(deployment().name, location)}-VirtualNetworkRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: last(split(virtualNetworkRule, '/'))
    virtualNetworkSubnetId: virtualNetworkRule
  }
}]

module serviceBusNamespace_authorizationRules 'authorizationRules/deploy.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-AuthorizationRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
  }
}]

module serviceBusNamespace_ipFilterRules 'ipFilterRules/deploy.bicep' = [for (ipFilterRule, index) in ipFilterRules: {
  name: '${uniqueString(deployment().name, location)}-IpFilterRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: contains(ipFilterRule, 'name') ? ipFilterRule.name : ipFilterRule.filterName
    action: ipFilterRule.action
    filterName: ipFilterRule.filterName
    ipMask: ipFilterRule.ipMask
  }
}]

module serviceBusNamespace_queues 'queues/deploy.bicep' = [for (queue, index) in queues: {
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
    lock: contains(queue, 'lock') ? queue.lock : 'NotSpecified'
    lockDuration: contains(queue, 'lockDuration') ? queue.lockDuration : 'PT1M'
    maxDeliveryCount: contains(queue, 'maxDeliveryCount') ? queue.maxDeliveryCount : 10
    maxSizeInMegabytes: contains(queue, 'maxSizeInMegabytes') ? queue.maxSizeInMegabytes : 1024
    requiresDuplicateDetection: contains(queue, 'requiresDuplicateDetection') ? queue.requiresDuplicateDetection : false
    requiresSession: contains(queue, 'requiresSession') ? queue.requiresSession : false
    roleAssignments: contains(queue, 'roleAssignments') ? queue.roleAssignments : []
    status: contains(queue, 'status') ? queue.status : 'Active'
  }
}]

module serviceBusNamespace_topics 'topics/deploy.bicep' = [for (topic, index) in topics: {
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
    lock: contains(topic, 'lock') ? topic.lock : 'NotSpecified'
    maxMessageSizeInKilobytes: contains(topic, 'maxMessageSizeInKilobytes') ? topic.maxMessageSizeInKilobytes : 1024
    maxSizeInMegabytes: contains(topic, 'maxSizeInMegabytes') ? topic.maxSizeInMegabytes : 1024
    requiresDuplicateDetection: contains(topic, 'requiresDuplicateDetection') ? topic.requiresDuplicateDetection : false
    roleAssignments: contains(topic, 'roleAssignments') ? topic.roleAssignments : []
    status: contains(topic, 'status') ? topic.status : 'Active'
    supportOrdering: contains(topic, 'supportOrdering') ? topic.supportOrdering : false
  }
}]

resource serviceBusNamespace_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${serviceBusNamespace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: serviceBusNamespace
}

resource serviceBusNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${serviceBusNamespace.name}-diagnosticSettings'
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

module serviceBusNamespace_privateEndpoints '.bicep/nested_privateEndpoints.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: serviceBusNamespace.id
    privateEndpointVnetLocation: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpoint: privateEndpoint
    tags: tags
  }
}]

module serviceBusNamespace_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: serviceBusNamespace.id
  }
}]

@description('The resource ID of the deployed service bus namespace')
output resourceId string = serviceBusNamespace.id

@description('The resource group of the deployed service bus namespace')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed service bus namespace')
output name string = serviceBusNamespace.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(serviceBusNamespace.identity, 'principalId') ? serviceBusNamespace.identity.principalId : ''
