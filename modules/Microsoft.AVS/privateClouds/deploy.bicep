targetScope = 'resourceGroup'

// ============== //
//   Parameters   //
// ============== //

@description('Optional. The identity of the private cloud, if configured.')
param identity object

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Name of the private cloud')
param name string

@description('Required. The private cloud SKU')
param sku object

@description('Optional. Resource tags')
param tags object

@description('Optional. Properties describing how the cloud is distributed across availability zones')
param availability object

@description('Optional. An ExpressRoute Circuit')
param circuit object

@description('Optional. Customer managed key encryption, can be enabled or disabled')
param encryption object

@description('Optional. vCenter Single Sign On Identity Sources')
param identitySources array

@description('Optional. Connectivity to internet is enabled or disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param internet string = 'Disabled'

@description('Optional. The default cluster used for management')
param managementCluster object

@description('Optional. The block of addresses should be unique across VNet in your subscription as well as on-premise. Make sure the CIDR format is conformed to (A.B.C.D/X) where A,B,C,D are between 0 and 255, and X is between 0 and 22')
param networkBlock string

@description('Optional. Optionally, set the NSX-T Manager password when the private cloud is created')
@secure()
param nsxtPassword string

@description('Optional. A secondary expressRoute circuit from a separate AZ. Only present in a stretched private cloud')
param secondaryCircuit object

@description('Optional. Optionally, set the vCenter admin password when the private cloud is created')
@secure()
param vcenterPassword string

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticStorageAccountId string

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'CapacityLatest'
  'DiskUsedPercentage'
  'EffectiveCpuAverage'
  'EffectiveMemAverage'
  'OverheadAverage'
  'TotalMbAverage'
  'UsageAverage'
  'UsedLatest'
])
param diagnosticLogCategoriesToEnable array = [
  'CapacityLatest'
  'DiskUsedPercentage'
  'EffectiveCpuAverage'
  'EffectiveMemAverage'
  'OverheadAverage'
  'TotalMbAverage'
  'UsageAverage'
  'UsedLatest'
]

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array

@description('Optional. Specify the type of lock.')
@allowed([
  'CanNotDelete'
  'ReadOnly'
])
param lock string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'
var enableReferencedModulesTelemetry = false


// =============== //
//   Deployments   //
// =============== //

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

resource privateCloud 'Microsoft.AVS/privateClouds@2021-12-01' = {
  identity: identity
  location: location
  name: name
  sku: sku
  tags: tags
  properties: {
    availability: availability
    circuit: circuit
    encryption: encryption
    identitySources: identitySources
    internet: internet
    managementCluster: managementCluster
    networkBlock: networkBlock
    nsxtPassword: nsxtPassword
    secondaryCircuit: secondaryCircuit
    vcenterPassword: vcenterPassword
  }
}

resource privateCloud_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: privateCloud
}

module privateCloud_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment,index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-privateCloud-Rbac-${index}'
  params: {
    description: contains(roleAssignment,'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment,'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment,'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment,'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: privateCloud.id
  }
}]

resource keyVault_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${privateCloud.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: privateCloud
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the privateCloud.')
output name string = privateCloud.name

@description('The resource ID of the privateCloud.')
output resourceId string = privateCloud.id

@description('The name of the resource group the privateCloud was created in.')
output resourceGroupName string = resourceGroup().name

