metadata name = 'ExpressRoute Circuits'
metadata description = 'This module deploys an Express Route Circuit.'
metadata owner = 'Azure/module-maintainers'

@description('Required. This is the name of the ExpressRoute circuit.')
param name string

@description('Required. This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call.')
param serviceProviderName string

@description('Required. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.')
param peeringLocation string

@description('Required. This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.')
param bandwidthInMbps int

@description('Optional. Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers.')
@allowed([
  'Local'
  'Standard'
  'Premium'
])
param skuTier string = 'Standard'

@description('Optional. Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.')
@allowed([
  'MeteredData'
  'UnlimitedData'
])
param skuFamily string = 'MeteredData'

@description('Optional. Enabled BGP peering type for the Circuit.')
param peering bool = false

@description('Optional. BGP peering type for the Circuit. Choose from AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering.')
@allowed([
  'AzurePrivatePeering'
  'MicrosoftPeering'
])
param peeringType string = 'AzurePrivatePeering'

@description('Optional. The shared key for peering configuration. Router does MD5 hash comparison to validate the packets sent by BGP connection. This parameter is optional and can be removed from peering configuration if not required.')
param sharedKey string = ''

@description('Optional. The autonomous system number of the customer/connectivity provider.')
param peerASN int = 0

@description('Optional. A /30 subnet used to configure IP addresses for interfaces on Link1.')
param primaryPeerAddressPrefix string = ''

@description('Optional. A /30 subnet used to configure IP addresses for interfaces on Link2.')
param secondaryPeerAddressPrefix string = ''

@description('Optional. Specifies the identifier that is used to identify the customer.')
param vlanId int = 0

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true.')
param allowClassicOperations bool = false

@description('Optional. The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null.')
param bandwidthInGbps int = 0

@description('Optional. The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct.')
param expressRoutePortResourceId string = ''

@description('Optional. Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU.')
param globalReachEnabled bool = false

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'PeeringRouteLog'
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

var peeringConfiguration = [
  {
    name: peeringType
    properties: {
      peeringType: peeringType
      sharedKey: sharedKey
      peerASN: peerASN
      primaryPeerAddressPrefix: primaryPeerAddressPrefix
      secondaryPeerAddressPrefix: secondaryPeerAddressPrefix
      vlanId: vlanId
    }
  }
]

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
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

resource expressRouteCircuits 'Microsoft.Network/expressRouteCircuits@2023-04-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: '${skuTier}_${skuFamily}'
    tier: skuTier
    family: skuTier == 'Local' ? 'UnlimitedData' : skuFamily
  }
  properties: {
    allowClassicOperations: allowClassicOperations
    globalReachEnabled: globalReachEnabled
    bandwidthInGbps: bandwidthInGbps != 0 ? bandwidthInGbps : null
    expressRoutePort: !empty(expressRoutePortResourceId) ? {
      id: expressRoutePortResourceId
    } : null
    serviceProviderProperties: {
      serviceProviderName: serviceProviderName
      peeringLocation: peeringLocation
      bandwidthInMbps: bandwidthInMbps
    }
    peerings: peering ? peeringConfiguration : null
  }
}

resource expressRouteCircuits_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: expressRouteCircuits
}

resource expressRouteCircuits_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: expressRouteCircuits
}

resource expressRouteCircuits_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(expressRouteCircuits.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: expressRouteCircuits
}]

@description('The resource ID of express route curcuit.')
output resourceId string = expressRouteCircuits.id

@description('The resource group the express route curcuit was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of express route curcuit.')
output name string = expressRouteCircuits.name

@description('The service key of the express route circuit.')
output serviceKey string = reference(expressRouteCircuits.id, '2021-02-01').serviceKey

@description('The location the resource was deployed into.')
output location string = expressRouteCircuits.location

// =============== //
//   Definitions   //
// =============== //

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
