@description('Required. The name of the Digital Twin Instance.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object = {}

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

@description('Optional. Event Hub Endpoint.')
param eventHubEndpoint object = {}

@description('Optional. Event Grid Endpoint.')
param eventGridEndpoint object = {}

@description('Optional. Service Bus Endpoint.')
param serviceBusEndpoint object = {}

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticStorageAccountId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'allLogs'
  'DigitalTwinsOperation'
  'EventRoutesOperation'
  'DataHistoryOperation'
  'ModelsOperation'
  'QueryOperation'
  'ResourceProviderOperation'
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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

var enableReferencedModulesTelemetry = false

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
  }
}

module digitalTwinsInstance_eventHubEndpoint 'endpoints--event-hub/main.bicep' = if (!empty(eventHubEndpoint)) {
  name: '${uniqueString(deployment().name, location)}-DigitalTwinsInstance-Endpoints-EventHub'
  params: {
    digitalTwinInstanceName: digitalTwinsInstance.name
    name: contains(eventHubEndpoint, 'name') ? eventHubEndpoint.name : 'EventHubEndpoint'
    authenticationType: contains(eventHubEndpoint, 'authenticationType') ? eventHubEndpoint.authenticationType : 'KeyBased'
    connectionStringPrimaryKey: contains(eventHubEndpoint, 'connectionStringPrimaryKey') ? eventHubEndpoint.connectionStringPrimaryKey : ''
    connectionStringSecondaryKey: contains(eventHubEndpoint, 'connectionStringSecondaryKey') ? eventHubEndpoint.connectionStringSecondaryKey : ''
    deadLetterSecret: contains(eventHubEndpoint, 'deadLetterSecret') ? eventHubEndpoint.deadLetterSecret : ''
    deadLetterUri: contains(eventHubEndpoint, 'deadLetterUri') ? eventHubEndpoint.deadLetterUri : ''
    endpointUri: contains(eventHubEndpoint, 'endpointUri') ? eventHubEndpoint.endpointUri : ''
    entityPath: contains(eventHubEndpoint, 'entityPath') ? eventHubEndpoint.entityPath : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    systemAssignedIdentity: contains(eventHubEndpoint, 'systemAssignedIdentity') ? eventHubEndpoint.systemAssignedIdentity : false
    userAssignedIdentity: contains(eventHubEndpoint, 'userAssignedIdentity') ? eventHubEndpoint.userAssignedIdentity : {}
  }
}

module digitalTwinsInstance_eventGridEndpoint 'endpoints--event-grid/main.bicep' = if (!empty(eventGridEndpoint)) {
  name: '${uniqueString(deployment().name, location)}-DigitalTwinsInstance-Endpoints-EventGrid'
  params: {
    digitalTwinInstanceName: digitalTwinsInstance.name
    name: contains(eventGridEndpoint, 'name') ? eventGridEndpoint.name : 'EventGridEndpoint'
    topicEndpoint: contains(eventGridEndpoint, 'topicEndpoint') ? eventGridEndpoint.topicEndpoint : ''
    deadLetterSecret: contains(eventGridEndpoint, 'deadLetterSecret') ? eventGridEndpoint.deadLetterSecret : ''
    deadLetterUri: contains(eventGridEndpoint, 'deadLetterUri') ? eventGridEndpoint.deadLetterUri : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    eventGridDomainResourceId: contains(eventGridEndpoint, 'eventGridDomainId') ? eventGridEndpoint.eventGridDomainId : ''
  }
}

module digitalTwinsInstance_serviceBusEndpoint 'endpoints--service-bus/main.bicep' = if (!empty(serviceBusEndpoint)) {
  name: '${uniqueString(deployment().name, location)}-DigitalTwinsInstance-Endpoints-ServiceBus'
  params: {
    digitalTwinInstanceName: digitalTwinsInstance.name
    name: contains(serviceBusEndpoint, 'name') ? serviceBusEndpoint.name : 'ServiceBusEndpoint'
    authenticationType: contains(serviceBusEndpoint, 'authenticationType') ? serviceBusEndpoint.authenticationType : ''
    deadLetterSecret: contains(serviceBusEndpoint, 'deadLetterSecret') ? serviceBusEndpoint.deadLetterSecret : ''
    deadLetterUri: contains(serviceBusEndpoint, 'deadLetterUri') ? serviceBusEndpoint.deadLetterUri : ''
    endpointUri: contains(serviceBusEndpoint, 'endpointUri') ? serviceBusEndpoint.endpointUri : ''
    entityPath: contains(serviceBusEndpoint, 'entityPath') ? serviceBusEndpoint.entityPath : ''
    primaryConnectionString: contains(serviceBusEndpoint, 'primaryConnectionString') ? serviceBusEndpoint.primaryConnectionString : ''
    secondaryConnectionString: contains(serviceBusEndpoint, 'secondaryConnectionString') ? serviceBusEndpoint.secondaryConnectionString : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    systemAssignedIdentity: contains(eventHubEndpoint, 'systemAssignedIdentity') ? eventHubEndpoint.systemAssignedIdentity : false
    userAssignedIdentity: contains(eventHubEndpoint, 'userAssignedIdentity') ? eventHubEndpoint.userAssignedIdentity : {}
  }
}

module digitalTwinsInstance_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-digitalTwinsInstance-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(digitalTwinsInstance.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: digitalTwinsInstance.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
  }
}]

resource digitalTwinsInstance_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${digitalTwinsInstance.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: digitalTwinsInstance
}

resource digitalTwinsInstance_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: digitalTwinsInstance
}

module digitalTwinsInstance_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: digitalTwinsInstance.id
  }
}]

@description('The resource ID of the Digital Twins Instance.')
output resourceId string = digitalTwinsInstance.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Digital Twins Instance.')
output name string = digitalTwinsInstance.name

@description('The hostname of the Digital Twins Instance.')
output hostname string = digitalTwinsInstance.properties.hostName

@description('The location the resource was deployed into.')
output location string = digitalTwinsInstance.location
