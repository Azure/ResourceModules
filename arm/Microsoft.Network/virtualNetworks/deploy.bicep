@description('Required. The Virtual Network (vNet) Name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param addressPrefixes array

@description('Required. An Array of subnets to deploy to the Virual Network.')
@minLength(1)
param subnets array

@description('Optional. Resource Group where NSGs are deployed, if different than VNET Resource Group.')
@minLength(1)
param nsgResourceGroup string = resourceGroup().name

@description('Optional. DNS Servers associated to the Virtual Network.')
param dnsServers array = []

@description('Optional. Resource ID of the DDoS protection plan to assign the VNET to. If it\'s left blank, DDoS protection will not be configured. If it\'s provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription.')
param ddosProtectionPlanId string = ''

@description('Optional. Virtual Network Peerings configurations')
param virtualNetworkPeerings array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of log analytics.')
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

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'VMProtectionAlerts'
])
param logsToEnable array = [
  'VMProtectionAlerts'
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

var dnsServers_var = {
  dnsServers: array(dnsServers)
}
var ddosProtectionPlan = {
  id: ddosProtectionPlanId
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    ddosProtectionPlan: !empty(ddosProtectionPlanId) ? ddosProtectionPlan : null
    dhcpOptions: !empty(dnsServers) ? dnsServers_var : null
    enableDdosProtection: !empty(ddosProtectionPlanId)
    subnets: [for item in subnets: {
      name: item.name
      properties: {
        addressPrefix: item.addressPrefix
        networkSecurityGroup: contains(item, 'networkSecurityGroupName') ? (empty(item.networkSecurityGroupName) ? null : json('{"id": "${resourceId(nsgResourceGroup, 'Microsoft.Network/networkSecurityGroups', item.networkSecurityGroupName)}"}')) : null
        routeTable: contains(item, 'routeTableName') ? (empty(item.routeTableName) ? null : json('{"id": "${resourceId('Microsoft.Network/routeTables', item.routeTableName)}"}')) : null
        serviceEndpoints: contains(item, 'serviceEndpoints') ? (empty(item.serviceEndpoints) ? null : item.serviceEndpoints) : null
        delegations: contains(item, 'delegations') ? (empty(item.delegations) ? null : item.delegations) : null
        natGateway: contains(item, 'natGatewayName') ? (empty(item.natGatewayName) ? null : json('{"id": "${resourceId('Microsoft.Network/natGateways', item.natGatewayName)}"}')) : null
        privateEndpointNetworkPolicies: contains(item, 'privateEndpointNetworkPolicies') ? (empty(item.privateEndpointNetworkPolicies) ? null : item.privateEndpointNetworkPolicies) : null
        privateLinkServiceNetworkPolicies: contains(item, 'privateLinkServiceNetworkPolicies') ? (empty(item.privateLinkServiceNetworkPolicies) ? null : item.privateLinkServiceNetworkPolicies) : null
      }
    }]
  }
}

module virtualNetworkPeerings_resource 'virtualNetworkPeerings/deploy.bicep' = [for (virtualNetworkPeering, index) in virtualNetworkPeerings: {
  name: '${uniqueString(deployment().name, location)}-VNet-VNetPeering-${index}'
  params: {
    localVnetName: name
    remoteVirtualNetworkId: virtualNetworkPeering.remoteVirtualNetworkId
    name: contains(virtualNetworkPeering, 'name') ? virtualNetworkPeering.name : '${name}-${last(split(virtualNetworkPeering.remoteVirtualNetworkId, '/'))}'
    allowForwardedTraffic: contains(virtualNetworkPeering, 'allowForwardedTraffic') ? virtualNetworkPeering.allowForwardedTraffic : true
    allowGatewayTransit: contains(virtualNetworkPeering, 'allowGatewayTransit') ? virtualNetworkPeering.allowGatewayTransit : false
    allowVirtualNetworkAccess: contains(virtualNetworkPeering, 'allowVirtualNetworkAccess') ? virtualNetworkPeering.allowVirtualNetworkAccess : true
    doNotVerifyRemoteGateways: contains(virtualNetworkPeering, 'doNotVerifyRemoteGateways') ? virtualNetworkPeering.doNotVerifyRemoteGateways : true
    useRemoteGateways: contains(virtualNetworkPeering, 'useRemoteGateways') ? virtualNetworkPeering.useRemoteGateways : false
  }
}]

resource virtualNetwork_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${virtualNetwork.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualNetwork
}

resource appServiceEnvironment_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName)) {
  name: '${virtualNetwork.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(workspaceId) ? null : workspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsLogs
  }
  scope: virtualNetwork
}

module virtualNetwork_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VNet-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: virtualNetwork.id
  }
}]

@description('The resource group the virtual network was deployed into')
output virtualNetworkResourceGroup string = resourceGroup().name

@description('The resource ID of the virtual network')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The name of the virtual network')
output virtualNetworkName string = virtualNetwork.name

@description('The names of the deployed subnets')
output subnetNames array = [for subnet in subnets: subnet.name]

@description('The resource IDs of the deployed subnets')
output subnetResourceIds array = [for subnet in subnets: resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnet.name)]
