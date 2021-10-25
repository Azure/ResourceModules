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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'Cosmos DB Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '230815da-be43-4aae-9cb4-875f7bd000aa')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
  'DocumentDB Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5bd9cd88-fe45-4216-938b-f97437e15450')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Private DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b12aa53e-6015-4669-85d0-8515ebb3ae7f')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'SQL Managed Instance Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d')
  'SQL Security Manager': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '056cd41c-7e88-42e1-933e-88ba6a50c9c3')
  'Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c0163c0-47e6-4577-8991-ea5c82e286e4')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Virtual Machine User Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb879df8-f326-4884-b1cf-06f3ad86be52')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
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

module virtualNetwork_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Vnet-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: virtualNetwork.name
  }
}]

output virtualNetworkResourceGroup string = resourceGroup().name
output virtualNetworkResourceId string = virtualNetwork.id
output virtualNetworkName string = virtualNetwork.name
output subnetNames array = [for subnet in subnets: subnet.name]
output subnetIds array = [for subnet in subnets: resourceId('Microsoft.Network/virtualNetworks/subnets', vNetName, subnet.name)]
