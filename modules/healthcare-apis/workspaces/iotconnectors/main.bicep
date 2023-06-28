@description('Required. The name of the MedTech service.')
@maxLength(50)
param name string

@description('Conditional. The name of the parent health data services workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. Event Hub name to connect to.')
param eventHubName string

@description('Optional. Consumer group of the event hub to connected to.')
param consumerGroup string = name

@description('Required. Namespace of the Event Hub to connect to.')
param eventHubNamespaceName string

@description('Required. The mapping JSON that determines how incoming device data is normalized.')
param deviceMapping object = {
  templateType: 'CollectionContent'
  template: []
}

@description('Optional. FHIR Destination.')
param fhirdestination object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'DiagnosticLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'DiagnosticLogs'
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

var enableReferencedModulesTelemetry = false

// =========== //
// Deployments //
// =========== //
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

resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' existing = {
  name: workspaceName
}

resource iotConnector 'Microsoft.HealthcareApis/workspaces/iotconnectors@2022-06-01' = {
  name: name
  parent: workspace
  location: location
  tags: tags
  identity: identity
  properties: {
    ingestionEndpointConfiguration: {
      eventHubName: eventHubName
      consumerGroup: consumerGroup
      fullyQualifiedEventHubNamespace: '${eventHubNamespaceName}.servicebus.windows.net'
    }
    deviceMapping: {
      content: deviceMapping
    }
  }
}

resource iotConnector_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${iotConnector.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: iotConnector
}

resource iotConnector_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: iotConnector
}

module fhir_destination 'fhirdestinations/main.bicep' = if (!empty(fhirdestination)) {
  name: '${deployment().name}-FhirDestination'
  params: {
    name: '${uniqueString(workspaceName, iotConnector.name)}-map'
    iotConnectorName: iotConnector.name
    resourceIdentityResolutionType: contains(fhirdestination, 'resourceIdentityResolutionType') ? fhirdestination.resourceIdentityResolutionType : 'Lookup'
    fhirServiceResourceId: fhirdestination.fhirServiceResourceId
    destinationMapping: contains(fhirdestination, 'destinationMapping') ? fhirdestination.destinationMapping : {
      templateType: 'CollectionFhir'
      template: []
    }
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    workspaceName: workspaceName
  }
}

@description('The name of the medtech service.')
output name string = iotConnector.name

@description('The resource ID of the medtech service.')
output resourceId string = iotConnector.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(iotConnector.identity, 'principalId') ? iotConnector.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = iotConnector.location

@description('The name of the medtech workspace.')
output workspaceName string = workspace.name
