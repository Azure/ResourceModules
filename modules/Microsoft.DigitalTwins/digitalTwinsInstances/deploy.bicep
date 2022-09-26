@description('Required. Resource Name.')
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
param eventhubEndpoint object = {}

@description('Optional. Event Grid Endpoint.')
param eventgridEndpoint object = {}

@description('Optional. Service Bus Endpoint.')
param servicebusEndpoint object = {}

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
  'AuditEvent'
  'AzurePolicyEvaluationDetails'
])
param diagnosticLogCategoriesToEnable array = [
  'AuditEvent'
  'AzurePolicyEvaluationDetails'
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

resource digitaltwin 'Microsoft.DigitalTwins/digitalTwinsInstances@2022-05-31' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : null)
  }
}

resource eventhubendpointid 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2022-05-31' = if ((!empty(eventhubEndpoint) && contains(eventhubEndpoint, 'EventHubURI'))) {
  name: contains(eventhubEndpoint, 'EndpointName') ? '${digitaltwin.name}/${eventhubEndpoint.EndpointName}Id' : '${digitaltwin.name}/EventHubEndpointId'
  properties: {
    endpointType: 'EventHub'
    authenticationType: 'IdentityBased'
    endpointUri: !empty(eventhubEndpoint.EventHubURI) ? eventhubEndpoint.EventHubURI : ''
    entityPath: contains(eventhubEndpoint, 'EventHubEntityPath') ? eventhubEndpoint.EventHubEntityPath : ''
  }
}

resource eventhubendpointkey 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2022-05-31' = if ((!empty(eventhubEndpoint)) && contains(eventhubEndpoint, 'EventHubConnectionStringPrimaryKey')) {
  name: contains(eventhubEndpoint, 'EndpointName') ? '${digitaltwin.name}/${eventhubEndpoint.EndpointName}Key' : '${digitaltwin.name}/EventHubEndpointKey'
  properties: {
    endpointType: 'EventHub'
    authenticationType: 'KeyBased'
    connectionStringPrimaryKey: contains(eventhubEndpoint, 'EventHubConnectionStringPrimaryKey') ? eventhubEndpoint.EventHubConnectionStringPrimaryKey : ''
    connectionStringSecondaryKey: contains(eventhubEndpoint, 'EventHubConnectionStringSecondaryKey') ? eventhubEndpoint.EventHubConnectionStringSecondaryKey : ''
  }
}

resource eventgridendpointid 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2022-05-31' = if ((!empty(eventgridEndpoint) && contains(eventgridEndpoint, 'EventGridTopicEndpoint')) && contains(eventgridEndpoint, 'EventGridAccessKey1')) {
  name: contains(eventgridEndpoint, 'EndpointName') ? '${digitaltwin.name}/${eventgridEndpoint.EndpointName}' : '${digitaltwin.name}/EventGridEndpoint'
  properties: {
    endpointType: 'EventGrid'
    authenticationType: 'KeyBased'
    accessKey1: contains(eventgridEndpoint, 'EventGridAccessKey1') ? eventgridEndpoint.EventGridAccessKey1 : ''
    accessKey2: contains(eventgridEndpoint, 'EventGridAccessKey2') ? eventgridEndpoint.EventGridAccessKey2 : ''
    TopicEndpoint: contains(eventgridEndpoint, 'EventGridTopicEndpoint') ? eventgridEndpoint.EventGridTopicEndpoint : ''
  }
}

resource servicebusendpointid 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2022-05-31' = if ((!empty(servicebusEndpoint)) && contains(servicebusEndpoint, 'ServiceBusEndpointUri')) {
  name: contains(servicebusEndpoint, 'EndpointName') ? '${digitaltwin.name}/${servicebusEndpoint.EndpointName}Id' : '${digitaltwin.name}/ServiceBusEndpointId'
  properties: {
    endpointType: 'ServiceBus'
    authenticationType: 'IdentityBased'
    endpointUri: contains(servicebusEndpoint, 'ServiceBusEndpointUri') ? servicebusEndpoint.ServiceBusEndpointUri : ''
    entityPath: contains(servicebusEndpoint, 'ServiceBusEntityPath') ? servicebusEndpoint.ServiceBusEntityPath : ''
  }
}

resource servicebusendpointkey 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2022-05-31' = if ((!empty(servicebusEndpoint)) && contains(servicebusEndpoint, 'ServiceBusPrimaryConnectionString')) {
  name: contains(servicebusEndpoint, 'EndpointName') ? '${digitaltwin.name}/${servicebusEndpoint.EndpointName}Key' : '${digitaltwin.name}/ServiceBusEndpointKey'
  properties: {
    endpointType: 'ServiceBus'
    authenticationType: 'KeyBased'
    primaryConnectionString: contains(servicebusEndpoint, 'ServiceBusPrimaryConnectionString') ? servicebusEndpoint.ServiceBusPrimaryConnectionString : ''
    secondaryConnectionString: contains(servicebusEndpoint, 'ServiceBusSecondaryConnectionString') ? servicebusEndpoint.ServiceBusSecondaryConnectionString : ''
  }
}

module digitaltwin_privateEndpoints '../../Microsoft.Network/privateEndpoints/deploy.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-DigitalTwin-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(digitaltwin.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: digitaltwin.id
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

resource server_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${digitaltwin.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: digitaltwin
}

resource digitaltwin_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: digitaltwin
}

module digitaltwin_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: digitaltwin.id
  }
}]

@description('The resource ID of the Digital Twin.')
output resourceId string = digitaltwin.id

@description('The name of the resource group the key vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Digital Twin.')
output name string = digitaltwin.name

@description('The hostname of the Digital Twin.')
output hostname string = digitaltwin.properties.hostName

@description('The location the resource was deployed into.')
output location string = digitaltwin.location
