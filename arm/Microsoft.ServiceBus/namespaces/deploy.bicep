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

@description('Optional. The Disaster Recovery configuration name')
param namespaceAlias string = ''

@description('Optional. Authorization Rules for the Service Bus namespace')
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

@description('Optional. IP Filter Rules for the Service Bus namespace')
param ipFilterRules array = []

@description('Optional. The migration configuration.')
param migrationConfigurationObj object = {}

@description('Optional. The disaster recovery configuration.')
param disasterRecoveryConfigObj object = {}

@description('Optional. vNet Rules SubnetIds for the Service Bus namespace.')
param virtualNetworkRules array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow('u')

@description('The queues to create in the service bus namespace')
param queues array = []

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
var serviceBusNamespaceName_var = (empty(name) ? uniqueServiceBusNamespaceName : name)

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Azure Service Bus Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '090c5cfd-751d-490a-894a-3ce6f1109419')
  'Azure Service Bus Data Receiver': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0')
  'Azure Service Bus Data Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: serviceBusNamespaceName_var
  location: location
  tags: (empty(tags) ? json('null') : tags)
  sku: {
    name: skuName
  }
  properties: {
    zoneRedundant: zoneRedundant
  }
}

module serviceBusNamespace_disasterRecoveryConfig 'disasterRecoveryConfigs/deploy.bicep' = if (!empty(disasterRecoveryConfigObj)) {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-DisasterRecoveryConfig'
  params: {
    namespaceName: serviceBusNamespace.name
    name: contains(disasterRecoveryConfigObj, 'name') ? disasterRecoveryConfigObj.name : 'default'
    alternateName: contains(disasterRecoveryConfigObj, 'alternateName') ? disasterRecoveryConfigObj.alternateName : ''
    partnerNamespace: contains(disasterRecoveryConfigObj, 'partnerNamespace') ? disasterRecoveryConfigObj.partnerNamespace : ''
  }
}

module serviceBusNamespace_migrationConfigurations 'migrationConfigurations/deploy.bicep' = if (!empty(migrationConfigurationObj)) {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-MigrationConfigurations'
  params: {
    namespaceName: migrationConfigurationObj.namespaceName
    name: contains(migrationConfigurationObj, 'name') ? migrationConfigurationObj.name : '$default'
    postMigrationName: migrationConfigurationObj.postMigrationName
    targetNamespace: migrationConfigurationObj.targetNamespace
  }
  dependsOn: [
    serviceBusNamespace
  ]
}

module serviceBusNamespace_virtualNetworkRules 'virtualNetworkRules/deploy.bicep' = [for (virtualNetworkRule, index) in virtualNetworkRules: {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-VirtualNetworkRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: last(split(virtualNetworkRule, '/'))
    virtualNetworkSubnetId: virtualNetworkRule
  }
  dependsOn: [
    serviceBusNamespace
  ]
}]

module serviceBusNamespace_authorizationRules 'authorizationRules/deploy.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-AuthorizationRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
  }
  dependsOn: [
    serviceBusNamespace
  ]
}]

module serviceBusNamespace_ipFilterRules 'ipFilterRules/deploy.bicep' = [for (ipFilterRule, index) in ipFilterRules: {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-IpFilterRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: ipFilterRule.name
    action: ipFilterRule.action
    filterName: ipFilterRule.filterName
    ipMask: ipFilterRule.ipMask
  }
  dependsOn: [
    serviceBusNamespace
  ]
}]

module serviceBusNamespace_queues 'queues/deploy.bicep' = [for (queue, index) in queues: {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-Queue-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: queue.name
    authorizationRules: contains(queue, 'authorizationRules') ? queue.authorizationRules : [
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
  dependsOn: [
    serviceBusNamespace
  ]
}]

resource serviceBusNamespace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${serviceBusNamespace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: serviceBusNamespace
}

resource serviceBusNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${serviceBusNamespace.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: serviceBusNamespace
}

module serviceBusNamespace_privateEndpoints './.bicep/nested_privateEndpoints.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-ServiceBusNamespaces-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: serviceBusNamespace.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpoint: privateEndpoint
    tags: tags
  }
}]

module serviceBusNamespace_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: serviceBusNamespace.name
  }
}]

output serviceBusNamespaceResourceId string = serviceBusNamespace.id
output serviceBusNamespaceResourceGroup string = resourceGroup().name
output serviceBusNamespaceName string = serviceBusNamespace.name
output serviceBusConnectionString string = 'Endpoint=sb://${serviceBusNamespaceName_var}.servicebus.windows.net/;SharedAccessKeyName=${listkeys(resourceId('Microsoft.ServiceBus/namespaces/authorizationRules', serviceBusNamespaceName_var, 'RootManageSharedAccessKey'), '2017-04-01').primaryKey}'
