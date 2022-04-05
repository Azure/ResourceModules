@description('Optional. The name of the event hub namespace. If no name is provided, then unique name will be created.')
@maxLength(50)
param name string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. event hub plan SKU name')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Optional. Event Hub plan scale-out capacity of the resource')
@minValue(1)
@maxValue(20)
param skuCapacity int = 1

@description('Optional. Switch to make the Event Hub Namespace zone redundant.')
param zoneRedundant bool = false

@description('Optional. Switch to enable the Auto Inflate feature of Event Hub.')
param isAutoInflateEnabled bool = false

@description('Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units.')
@minValue(0)
@maxValue(20)
param maximumThroughputUnits int = 1

@description('Optional. Authorization Rules for the Event Hub namespace')
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

@description('Optional. Configuration Details for private endpoints.For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Service endpoint object information')
param networkAcls object = {}

@description('Optional. Virtual Network ID to lock down the Event Hub.')
param vNetId string = ''

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

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow('u')

@description('Optional. The event hubs to deploy into this namespace')
param eventHubs array = []

@description('Optional. The disaster recovery config for this namespace')
param disasterRecoveryConfig object = {}

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'ArchiveLogs'
  'OperationalLogs'
  'KafkaCoordinatorLogs'
  'KafkaUserErrorLogs'
  'EventHubVNetConnectionEvent'
  'CustomerManagedKeyUserLogs'
  'AutoScaleLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'ArchiveLogs'
  'OperationalLogs'
  'KafkaCoordinatorLogs'
  'KafkaUserErrorLogs'
  'EventHubVNetConnectionEvent'
  'CustomerManagedKeyUserLogs'
  'AutoScaleLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

var maxNameLength = 50
var uniqueEventHubNamespaceUntrim = uniqueString('EventHub Namespace${baseTime}')
var uniqueEventHubNamespace = length(uniqueEventHubNamespaceUntrim) > maxNameLength ? substring(uniqueEventHubNamespaceUntrim, 0, maxNameLength) : uniqueEventHubNamespaceUntrim
var name_var = empty(name) ? uniqueEventHubNamespace : name
var maximumThroughputUnits_var = !isAutoInflateEnabled ? 0 : maximumThroughputUnits
var virtualNetworkRules = [for index in range(0, (empty(networkAcls) ? 0 : length(networkAcls.virtualNetworkRules))): {
  id: '${vNetId}/subnets/${networkAcls.virtualNetworkRules[index].subnet}'
}]
var networkAcls_var = {
  bypass: !empty(networkAcls) ? networkAcls.bypass : null
  defaultAction: !empty(networkAcls) ? networkAcls.defaultAction : null
  virtualNetworkRules: !empty(networkAcls) ? virtualNetworkRules : null
  ipRules: !empty(networkAcls) ? (length(networkAcls.ipRules) > 0 ? networkAcls.ipRules : null) : null
}

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

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

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-06-01-preview' = {
  name: name_var
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    tier: skuName
    capacity: skuCapacity
  }
  properties: {
    zoneRedundant: zoneRedundant
    isAutoInflateEnabled: isAutoInflateEnabled
    maximumThroughputUnits: maximumThroughputUnits_var
    networkAcls: !empty(networkAcls) ? networkAcls_var : null
  }
}

resource eventHubNamespace_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${eventHubNamespace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: eventHubNamespace
}

resource eventHubNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
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

module eventHubNamespace_eventHubs 'eventhubs/deploy.bicep' = [for (eventHub, index) in eventHubs: {
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
    consumerGroups: contains(eventHub, 'consumerGroups') ? eventHub.consumerGroups : []
    lock: contains(eventHub, 'lock') ? eventHub.lock : 'NotSpecified'
    messageRetentionInDays: contains(eventHub, 'messageRetentionInDays') ? eventHub.messageRetentionInDays : 1
    partitionCount: contains(eventHub, 'partitionCount') ? eventHub.partitionCount : 2
    roleAssignments: contains(eventHub, 'roleAssignments') ? eventHub.roleAssignments : []
    status: contains(eventHub, 'status') ? eventHub.status : 'Active'
  }
}]

module eventHubNamespace_diasterRecoveryConfig 'disasterRecoveryConfigs/deploy.bicep' = if (!empty(disasterRecoveryConfig)) {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-DisRecConfig'
  params: {
    namespaceName: eventHubNamespace.name
    name: disasterRecoveryConfig.name
    partnerNamespaceId: contains(disasterRecoveryConfig, 'partnerNamespaceId') ? disasterRecoveryConfig.partnerNamespaceId : ''
  }
}

module eventHubNamespace_authorizationRules 'authorizationRules/deploy.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-AuthRule-${index}'
  params: {
    namespaceName: eventHubNamespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
  }
}]

module eventHubNamespace_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: eventHubNamespace.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: endpoint
    tags: tags
  }
}]

module eventHubNamespace_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-EvhbNamespace-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: eventHubNamespace.id
  }
}]

@description('The name of the eventspace.')
output name string = eventHubNamespace.name

@description('The resource ID of the eventspace.')
output resourceId string = eventHubNamespace.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(eventHubNamespace.identity, 'principalId') ? eventHubNamespace.identity.principalId : ''
