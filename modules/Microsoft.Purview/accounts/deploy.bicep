@description('Required. Name of the Purview Account.')
param name string

@description('Optional. Location for all resources.)
param location string = resourceGroup().location
param location string = resourceGroup().location

@description('Required. Name of the Purview Account.')
param name string

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Required. The Managed Resource Group Name.')
param managedResourceGroupName string

@description('Optional. Enable or disable resource provider inbound network traffic from public clients. default is Disabled.')
@allowed([
  'Enabled'
  'Disabled'
  'NotSpecified'
])
param publicNetworkAccess string = 'Disabled'

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

@description('Conditional. Existing Subnet Resource ID to assign to the Private Endpoint. Required if Private Endpoints are required.')
param subnetId string = ''

@description('Conditional. Name of the Purview Account Private Endpoint. Required if the Purview account Private Endpoint is required.')
param accountPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the Purview Account private endpoint.')
param accountPrivateEndpointNicName string = ''

@description('Optional. The static privavte IP address for the Purview Account private endpoint.')
param accountPrivateEndpointIP string = ''

@description('Conditional. Name of the Purview Portal Private Endpoint. Required if the Purview portal Private Endpoint is required.')
param portalPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the Purview Portal private endpoint.')
param portalPrivateEndpointNicName string = ''

@description('Optional. The static privavte IP address for the Purview Portal private endpoint.')
param portalPrivateEndpointIP string = ''

@description('Conditional. Name of the managed Storage Account blob Private Endpoint. Required if the managed storage account blob private endpoint is required.')
param storageAccountBlobPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the managed Storage Account blob private endpoint.')
param storageAccountBlobPrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the managed Storage Account blob private endpoint.')
param storageAccountBlobPrivateEndpointIP string = ''

@description('Conditional. Name of the managed Storage Account queue Private Endpoint. Required if the managed storage account queue private endpoint is required.')
param storageAccountQueuePrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the managed Storage Account queue private endpoint.')
param storageAccountQueuePrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the managed Storage Account blob private endpoint.')
param storageAccountQueuePrivateEndpointIP string = ''

@description('Conditional. Name of the managed Event Hub Namespace Private Endpoint. Required if the managed Event Hub Namespace private endpoint is required.')
param eventHubPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the managed Event Hub Namespace private endpoint.')
param eventHubPrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the managed Event Hub Namespace private endpoint.')
param eventHubPrivateEndpointIP string = ''

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

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

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

var deploymentNameSuffix = last(split(deployment().name, '-'))

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

resource purviewAccount 'Microsoft.Purview/accounts@2021-07-01' = {
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
  name: '${purviewAccount.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: purviewAccount
}

resource purview_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: purviewAccount
}

module purviewAccountPE '../../Microsoft.Network/privateEndpoints/deploy.bicep' = if (!empty(accountPrivateEndpointName)) {
  name: take('purview-account-pe-${name}-${deploymentNameSuffix}', 64)
  params: {
    name: accountPrivateEndpointName
    tags: tags
    subnetResourceId: subnetId
    serviceResourceId: purviewAccount.id
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    groupIds: [
      'account'
    ]
    ipConfigurations: !empty(accountPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'account'
          memberName: 'default'
          privateIPAddress: accountPrivateEndpointIP
        }
      }
    ] : []
    customNetworkInterfaceName: accountPrivateEndpointNicName
    lock: lock
  }
}

module purviewPortalPE '../../Microsoft.Network/privateEndpoints/deploy.bicep' = if (!empty(portalPrivateEndpointName)) {
  name: take('purview-portal-pe-${name}-${deploymentNameSuffix}', 64)
  params: {
    name: portalPrivateEndpointName
    tags: tags
    subnetResourceId: subnetId
    serviceResourceId: purviewAccount.id
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    groupIds: [
      'portal'
    ]
    ipConfigurations: !empty(accountPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'portal'
          memberName: 'default'
          privateIPAddress: portalPrivateEndpointIP
        }
      }
    ] : []
    customNetworkInterfaceName: portalPrivateEndpointNicName
  }
}

module storageBlobPe '../../Microsoft.Network/privateEndpoints/deploy.bicep' = if (!empty(storageAccountBlobPrivateEndpointName)) {
  name: take('purview-sa-blob-pe-${name}-${deploymentNameSuffix}', 64)
  params: {
    name: storageAccountBlobPrivateEndpointName
    tags: tags
    subnetResourceId: subnetId
    serviceResourceId: purviewAccount.properties.managedResources.storageAccount
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    groupIds: [
      'blob'
    ]
    ipConfigurations: !empty(accountPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'blob'
          memberName: 'default'
          privateIPAddress: storageAccountBlobPrivateEndpointIP
        }
      }
    ] : []
    customNetworkInterfaceName: storageAccountBlobPrivateEndpointNicName
  }
}

module storageQueuePe '../../Microsoft.Network/privateEndpoints/deploy.bicep' = if (!empty(storageAccountQueuePrivateEndpointName)) {
  name: take('purview-sa-queue-pe-${name}-${deploymentNameSuffix}', 64)
  params: {
    name: storageAccountQueuePrivateEndpointName
    tags: tags
    subnetResourceId: subnetId
    serviceResourceId: purviewAccount.properties.managedResources.storageAccount
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    groupIds: [
      'queue'
    ]
    ipConfigurations: !empty(accountPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'queue'
          memberName: 'default'
          privateIPAddress: storageAccountQueuePrivateEndpointIP
        }
      }
    ] : []
    customNetworkInterfaceName: storageAccountQueuePrivateEndpointNicName
  }
}

module eventHubPe '../../Microsoft.Network/privateEndpoints/deploy.bicep' = if (!empty(eventHubPrivateEndpointName)) {
  name: take('purview-eh-pe-${name}-${deploymentNameSuffix}', 64)
  params: {
    name: eventHubPrivateEndpointName
    tags: tags
    subnetResourceId: subnetId
    serviceResourceId: purviewAccount.properties.managedResources.eventHubNamespace
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    groupIds: [
      'namespace'
    ]
    ipConfigurations: !empty(accountPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'namespace'
          memberName: 'default'
          privateIPAddress: eventHubPrivateEndpointIP
        }
      }
    ] : []
    customNetworkInterfaceName: eventHubPrivateEndpointNicName
  }
}

module purview_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-KeyVault-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: purviewAccount.id
  }
}]

@description('The name of the Microsoft Purview Account.')
output name string = purviewAccount.name

@description('The resource group the Microsoft Purview Account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Purview Account.')
output resourceId string = purviewAccount.id

@description('The location the resource was deployed into.')
output location string = purviewAccount.location

@description('The name of the managed resource group.')
output managedResourceGroupName string = purviewAccount.properties.managedResourceGroupName

@description('The resource ID of the managed resource group.')
output managedResourceGroupId string = purviewAccount.properties.managedResources.resourceGroup

@description('The resource ID of the managed storage account.')
output managedStorageAccountId string = purviewAccount.properties.managedResources.storageAccount

@description('The resource ID of the managed Event Hub Namespace.')
output managedEventHubId string = purviewAccount.properties.managedResources.eventHubNamespace

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = purviewAccount.identity.principalId

@description('The resource ID of the Purview Account private endpoint.')
output accountPrivateEndpointId string = !empty(accountPrivateEndpointName) ? purviewAccountPE.outputs.resourceId : ''

@description('The resource ID of the Purview portal private endpoint.')
output portalPrivateEndpointId string = !empty(portalPrivateEndpointName) ? purviewPortalPE.outputs.resourceId : ''

@description('The resource ID of the Purview Managed Storage Account Blob private endpoint.')
output storageAccountBlobPrivateEndpointId string = !empty(storageAccountBlobPrivateEndpointName) ? storageBlobPe.outputs.resourceId : ''

@description('The resource ID of the Purview Managed Storage Account Queue private endpoint.')
output storageAccountQueuePrivateEndpointId string = !empty(storageAccountQueuePrivateEndpointName) ? storageQueuePe.outputs.resourceId : ''

@description('The resource ID of the Purview Managed Event Hub Namepsace private endpoint.')
output eventHubPrivateEndpointId string = !empty(eventHubPrivateEndpointName) ? eventHubPe.outputs.resourceId : ''
