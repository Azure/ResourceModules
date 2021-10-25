@description('Required. This is the name of the ExpressRoute circuit')
param circuitName string

@description('Required. This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call.')
param serviceProviderName string

@description('Required. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.')
param peeringLocation string

@description('Required. This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.')
param bandwidthInMbps int

@description('Required. Chosen SKU Tier of ExpressRoute circuit. Choose from Premium or Standard SKU tiers.')
@allowed([
  'Standard'
  'Premium'
])
param skuTier string = 'Standard'

@description('Required. Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.')
@allowed([
  'MeteredData'
  'UnlimitedData'
])
param skuFamily string = 'MeteredData'

@description('Optional. Enabled BGP peering type for the Circuit.')
@allowed([
  true
  false
])
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

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'PeeringRouteLog'
])
param logsToEnable array = [
  'PeeringRouteLog'
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
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource expressRouteCircuits 'Microsoft.Network/expressRouteCircuits@2021-02-01' = {
  name: circuitName
  location: location
  tags: tags
  sku: {
    name: '${skuTier}_${skuFamily}'
    tier: skuTier
    family: skuFamily
  }
  properties: {
    serviceProviderProperties: {
      serviceProviderName: serviceProviderName
      peeringLocation: peeringLocation
      bandwidthInMbps: bandwidthInMbps
    }
    peerings: (peering ? peeringConfiguration : json('null'))
  }
}

resource expressRouteCircuits_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${expressRouteCircuits.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: expressRouteCircuits
}

resource expressRouteCircuits_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${expressRouteCircuits.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: expressRouteCircuits
}

module expressRouteCircuits_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: expressRouteCircuits.name
  }
}]

output expressRouteCircuitResourceId string = expressRouteCircuits.id
output expressRouteCircuitResourceGroup string = resourceGroup().name
output expressRouteCircuitName string = expressRouteCircuits.name
output expressRouteCircuitServiceKey string = reference(expressRouteCircuits.id, '2020-05-01').serviceKey
