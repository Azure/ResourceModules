metadata name = 'Event Grid System Topics'
metadata description = 'This module deploys an Event Grid System Topic.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Event Grid Topic.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Source for the system topic.')
param source string

@description('Required. TopicType for the system topic.')
param topicType string

@description('Optional. Event subscriptions to deploy.')
param eventSubscriptions array = []

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'DeliveryFailures'
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

resource systemTopic 'Microsoft.EventGrid/systemTopics@2021-12-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    source: source
    topicType: topicType
  }
}

// Event subscriptions
module systemTopics_eventSubscriptions 'event-subscription/main.bicep' = [for (eventSubscription, index) in eventSubscriptions: {
  name: '${uniqueString(deployment().name, location)}-EventGrid-SystemTopics-EventSubscriptions-${index}'
  params: {
    destination: eventSubscription.destination
    systemTopicName: systemTopic.name
    name: eventSubscription.name
    deadLetterDestination: contains(eventSubscription, 'deadLetterDestination') ? eventSubscription.deadLetterDestination : {}
    deadLetterWithResourceIdentity: contains(eventSubscription, 'deadLetterWithResourceIdentity') ? eventSubscription.deadLetterWithResourceIdentity : {}
    deliveryWithResourceIdentity: contains(eventSubscription, 'deliveryWithResourceIdentity') ? eventSubscription.deliveryWithResourceIdentity : {}
    enableDefaultTelemetry: contains(eventSubscription, 'enableDefaultTelemetry') ? eventSubscription.enableDefaultTelemetry : true
    eventDeliverySchema: contains(eventSubscription, 'eventDeliverySchema') ? eventSubscription.eventDeliverySchema : 'EventGridSchema'
    expirationTimeUtc: contains(eventSubscription, 'expirationTimeUtc') ? eventSubscription.expirationTimeUtc : ''
    filter: contains(eventSubscription, 'filter') ? eventSubscription.filter : {}
    labels: contains(eventSubscription, 'labels') ? eventSubscription.labels : []
    location: contains(eventSubscription, 'location') ? eventSubscription.location : systemTopic.location
    retryPolicy: contains(eventSubscription, 'retryPolicy') ? eventSubscription.retryPolicy : {}
  }
}]

resource systemTopic_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${systemTopic.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: systemTopic
}

resource systemTopic_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: systemTopic
}

module systemTopic_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-EventGrid-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: systemTopic.id
  }
}]

@description('The name of the event grid system topic.')
output name string = systemTopic.name

@description('The resource ID of the event grid system topic.')
output resourceId string = systemTopic.id

@description('The name of the resource group the event grid system topic was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(systemTopic.identity, 'principalId') ? systemTopic.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = systemTopic.location
