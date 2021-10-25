@description('Optional. The name of the EventHub namespace. If no name is provided, then unique name will be created.')
@maxLength(50)
param namespaceName string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. EventHub Plan sku name')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Optional. Event Hub Plan scale-out capacity of the resource')
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

@description('Optional. ARM Id of the Primary/Secondary eventhub namespace name, which is part of GEO DR pairing')
param partnerNamespaceId string = ''

@description('Optional. The Disaster Recovery configuration name')
param namespaceAlias string = ''

@description('Optional. Authorization Rules for the Event Hub namespace')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
]

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Service endpoint object information')
param networkAcls object = {}

@description('Optional. Virtual Network Id to lock down the Event Hub.')
param vNetId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow('u')

var maxNameLength = 50
var uniqueEventHubNamespaceUntrim = '${uniqueString('EventHub Namespace${baseTime}')}'
var uniqueEventHubNamespace = ((length(uniqueEventHubNamespaceUntrim) > maxNameLength) ? substring(uniqueEventHubNamespaceUntrim, 0, maxNameLength) : uniqueEventHubNamespaceUntrim)
var constructedNamespaceName = (empty(namespaceName) ? uniqueEventHubNamespace : namespaceName)
var defaultAuthorizationRuleId = resourceId('Microsoft.EventHub/namespaces/AuthorizationRules', constructedNamespaceName, 'RootManageSharedAccessKey')
var defaultSASKeyName = 'RootManageSharedAccessKey'
var authRuleResourceId = resourceId('Microsoft.EventHub/namespaces/authorizationRules', constructedNamespaceName, defaultSASKeyName)
var maximumThroughputUnits_var = ((!isAutoInflateEnabled) ? 0 : maximumThroughputUnits)
var virtualNetworkRules = [for index in range(0, (empty(networkAcls) ? 0 : length(networkAcls.virtualNetworkRules))): {
  id: '${vNetId}/subnets/${networkAcls.virtualNetworkRules[index].subnet}'
}]
var networkAcls_var = {
  bypass: (empty(networkAcls) ? json('null') : networkAcls.bypass)
  defaultAction: (empty(networkAcls) ? json('null') : networkAcls.defaultAction)
  virtualNetworkRules: (empty(networkAcls) ? json('null') : virtualNetworkRules)
  ipRules: (empty(networkAcls) ? json('null') : ((length(networkAcls.ipRules) == 0) ? json('null') : networkAcls.ipRules))
}
var namespaceAlias_var = (empty(namespaceAlias) ? 'placeholder' : namespaceAlias)

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
param logsToEnable array = [
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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Azure Event Hubs Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f526a384-b230-433a-b45c-95f59c4a2dec')
  'Azure Event Hubs Data Receiver': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a638d3c7-ab3a-418d-83e6-5f17a39d4fde')
  'Azure Event Hubs Data Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2b629674-e913-4c01-ae53-ef4638d8f975')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Schema Registry Contributor (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5dffeca3-4936-4216-b2bc-10343a5abb25')
  'Schema Registry Reader (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2c56ea50-c6b3-40a6-83c0-9d98858bc7d2')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2017-04-01' = {
  name: constructedNamespaceName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuName
    capacity: skuCapacity
  }
  properties: {
    zoneRedundant: zoneRedundant
    isAutoInflateEnabled: isAutoInflateEnabled
    maximumThroughputUnits: maximumThroughputUnits_var
    networkAcls: (empty(networkAcls) ? json('null') : networkAcls_var)
  }
}

resource eventHubNamespace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${eventHubNamespace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: eventHubNamespace
}

resource eventHubNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId))) {
  name: '${eventHubNamespace.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId)) ? json('null') : diagnosticsLogs)
  }
  scope: eventHubNamespace
}

resource eventHubNamespace_diasterRecoveryConfig 'Microsoft.EventHub/namespaces/disasterRecoveryConfigs@2017-04-01' = if (((!empty(partnerNamespaceId)) && (!empty(namespaceAlias))) ? true : false) {
  parent: eventHubNamespace
  name: namespaceAlias_var
  properties: {
    partnerNamespace: partnerNamespaceId
  }
}

resource eventHubNamespace_authorizationRules 'Microsoft.EventHub/namespaces/AuthorizationRules@2017-04-01' = [for authorizationRule in authorizationRules: if (length(authorizationRules) > 0) {
  name: '${eventHubNamespace.name}/${authorizationRule.name}'
  properties: {
    rights: authorizationRule.properties.rights
  }
}]

module eventHubNamespace_privateEndpoints './.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-EventHubNamepace-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: eventHubNamespace.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: endpoint
    tags: tags
  }
}]

module eventHubNamespace_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-EventHubNamespace-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: eventHubNamespace.name
  }
}]

output namespace string = eventHubNamespace.name
output namespaceResourceId string = eventHubNamespace.id
output namespaceResourceGroup string = resourceGroup().name
output namespaceConnectionString string = listkeys(authRuleResourceId, '2017-04-01').primaryConnectionString
output sharedAccessPolicyPrimaryKey string = listkeys(authRuleResourceId, '2017-04-01').primaryKey
