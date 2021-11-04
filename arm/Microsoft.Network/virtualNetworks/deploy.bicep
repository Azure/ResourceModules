@description('Required. The Virtual Network (vNet) Name.')
param vNetName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array

@description('Required. An Array of subnets to deploy to the Virual Network.')
@minLength(1)
param subnets array

@description('Optional. DNS Servers associated to the Virtual Network.')
param dnsServers array = []

@description('Optional. Resource Id of the DDoS protection plan to assign the VNET to. If it\'s left blank, DDoS protection will not be configured. If it\'s provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription.')
param ddosProtectionPlanId string = ''

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
  name: vNetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vNetAddressPrefixes
    }
    ddosProtectionPlan: ((!empty(ddosProtectionPlanId)) ? ddosProtectionPlan : json('null'))
    dhcpOptions: (empty(dnsServers) ? json('null') : dnsServers_var)
    enableDdosProtection: (!empty(ddosProtectionPlanId))
    subnets: [for item in subnets: {
      name: item.name
      properties: {
        addressPrefix: item.addressPrefix
        networkSecurityGroup: (contains(item, 'networkSecurityGroupName') ? (empty(item.networkSecurityGroupName) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/networkSecurityGroups', item.networkSecurityGroupName)}"}')) : json('null'))
        routeTable: (contains(item, 'routeTableName') ? (empty(item.routeTableName) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/routeTables', item.routeTableName)}"}')) : json('null'))
        serviceEndpoints: (contains(item, 'serviceEndpoints') ? (empty(item.serviceEndpoints) ? json('null') : item.serviceEndpoints) : json('null'))
        delegations: (contains(item, 'delegations') ? (empty(item.delegations) ? json('null') : item.delegations) : json('null'))
        natGateway: (contains(item, 'natGatewayName') ? (empty(item.natGatewayName) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/natGateways', item.natGatewayName)}"}')) : json('null'))
        privateEndpointNetworkPolicies: (contains(item, 'privateEndpointNetworkPolicies') ? (empty(item.privateEndpointNetworkPolicies) ? json('null') : item.privateEndpointNetworkPolicies) : json('null'))
        privateLinkServiceNetworkPolicies: (contains(item, 'privateLinkServiceNetworkPolicies') ? (empty(item.privateLinkServiceNetworkPolicies) ? json('null') : item.privateLinkServiceNetworkPolicies) : json('null'))
      }
    }]
  }
}

resource virtualNetwork_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${virtualNetwork.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualNetwork
}

resource appServiceEnvironment_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${vNetName}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: virtualNetwork
}

module virtualNetwork_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Vnet-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: virtualNetwork.name
  }
}]

output virtualNetworkResourceGroup string = resourceGroup().name
output virtualNetworkResourceId string = virtualNetwork.id
output virtualNetworkName string = virtualNetwork.name
output subnetNames array = [for subnet in subnets: subnet.name]
output subnetIds array = [for subnet in subnets: resourceId('Microsoft.Network/virtualNetworks/subnets', vNetName, subnet.name)]
