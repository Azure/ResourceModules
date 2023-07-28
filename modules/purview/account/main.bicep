@description('Required. Name of the Purview Account.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. The Managed Resource Group Name. A managed Storage Account, and an Event Hubs will be created in the selected subscription for catalog ingestion scenarios. Default is \'managed-rg-<purview-account-name>\'.')
param managedResourceGroupName string = 'managed-rg-${name}'

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  'Enabled'
  'Disabled'
  'NotSpecified'
])
param publicNetworkAccess string = 'NotSpecified'

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Configuration details for Purview Account private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'account\'.')
param accountPrivateEndpoints array = []

@description('Optional. Configuration details for Purview Portal private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'portal\'.')
param portalPrivateEndpoints array = []

@description('Optional. Configuration details for Purview Managed Storage Account blob private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'blob\'.')
param storageBlobPrivateEndpoints array = []

@description('Optional. Configuration details for Purview Managed Storage Account queue private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'queue\'.')
param storageQueuePrivateEndpoints array = []

@description('Optional. Configuration details for Purview Managed Event Hub namespace private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to \'namespace\'.')
param eventHubPrivateEndpoints array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'ScanStatus'
  'DataSensitivity'
  'PurviewAccountAuditEvents'
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

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

// =========== //
// Variables   //
// =========== //

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

var identityType = !empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

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

resource account 'Microsoft.Purview/accounts@2021-07-01' = {
  name: name
  location: location
  tags: tags
  identity: any(identity)
  properties: {
    cloudConnectors: {}
    managedResourceGroupName: managedResourceGroupName
    publicNetworkAccess: publicNetworkAccess
  }
}

resource purview_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${account.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: account
}

resource purview_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: account
}

module account_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in accountPrivateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Account-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(account.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: account.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module portal_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in portalPrivateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Portal-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(account.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: account.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module blob_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in storageBlobPrivateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Storage-Blob-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(account.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: account.properties.managedResources.storageAccount
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module queue_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in storageQueuePrivateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Storage-Queue-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(account.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: account.properties.managedResources.storageAccount
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module eventHub_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in eventHubPrivateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Eventhub-Namespace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(account.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: account.properties.managedResources.eventHubNamespace
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module purview_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Account-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: account.id
  }
}]

@description('The name of the Purview Account.')
output name string = account.name

@description('The resource group the Purview Account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Purview Account.')
output resourceId string = account.id

@description('The location the resource was deployed into.')
output location string = account.location

@description('The name of the managed resource group.')
output managedResourceGroupName string = account.properties.managedResourceGroupName

@description('The resource ID of the managed resource group.')
output managedResourceGroupId string = account.properties.managedResources.resourceGroup

@description('The resource ID of the managed storage account.')
output managedStorageAccountId string = account.properties.managedResources.storageAccount

@description('The resource ID of the managed Event Hub Namespace.')
output managedEventHubId string = account.properties.managedResources.eventHubNamespace

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = account.identity.principalId
