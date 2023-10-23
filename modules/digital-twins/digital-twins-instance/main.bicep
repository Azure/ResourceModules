metadata name = 'Digital Twins Instances'
metadata description = 'This module deploys an Azure Digital Twins Instance.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Digital Twin Instance.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

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

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
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
param roleAssignments roleAssignmentType

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourcesIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

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

var builtInRoleNames = {
  'Azure Digital Twins Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'bcd981a7-7f74-457b-83e1-cceb9e632ffe')
  'Azure Digital Twins Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd57506d4-4c8d-48b1-8587-93c323f6a5a3')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
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

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
  }
}

module digitalTwinsInstance_eventHubEndpoint 'endpoint--event-hub/main.bicep' = if (!empty(eventHubEndpoint)) {
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
    managedIdentities: contains(eventHubEndpoint, 'managedIdentities') ? eventHubEndpoint.managedIdentities : null
  }
}

module digitalTwinsInstance_eventGridEndpoint 'endpoint--event-grid/main.bicep' = if (!empty(eventGridEndpoint)) {
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

module digitalTwinsInstance_serviceBusEndpoint 'endpoint--service-bus/main.bicep' = if (!empty(serviceBusEndpoint)) {
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
    managedIdentities: contains(serviceBusEndpoint, 'managedIdentities') ? serviceBusEndpoint.managedIdentities : null
  }
}

module digitalTwinsInstance_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-digitalTwinsInstance-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(digitalTwinsInstance.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: digitalTwinsInstance.id
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
  }
}]

resource digitalTwinsInstance_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
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

resource digitalTwinsInstance_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(digitalTwinsInstance.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: digitalTwinsInstance
}]

@description('The resource ID of the Digital Twins Instance.')
output resourceId string = digitalTwinsInstance.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Digital Twins Instance.')
output name string = digitalTwinsInstance.name

@description('The hostname of the Digital Twins Instance.')
output hostname string = digitalTwinsInstance.properties.hostName

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(digitalTwinsInstance.identity, 'principalId') ? digitalTwinsInstance.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = digitalTwinsInstance.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
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
