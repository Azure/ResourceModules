@description('Required. The Proximity Placement Groups Name')
param loadBalancerName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of a load balancer SKU.')
@allowed([
  'Basic'
  'Standard'
])
param loadBalancerSku string = 'Standard'

@description('Required. Array of objects containing all frontend IP configurations')
@minLength(1)
param frontendIPConfigurations array

@description('Required. Collection of backend address pools used by a load balancer.')
@minLength(1)
param backendAddressPools array

@description('Required. Array of objects containing all load balancing rules')
@minLength(1)
param loadBalancingRules array

@description('Required. Array of objects containing all probes, these are references in the load balancing rules')
@minLength(1)
param probes array

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

var frontendsSubnets = [for item in frontendIPConfigurations: {
  id: item.properties.subnetId
}]
var frontendsPublicIPAddresses = [for item in frontendIPConfigurations: {
  id: item.properties.publicIPAddressId
}]
var frontendsObj = {
  subnets: frontendsSubnets
  publicIPAddresses: frontendsPublicIPAddresses
}

var frontendIPConfigurations_var = [for (frontendIPConfiguration, index) in frontendIPConfigurations: {
  name: frontendIPConfiguration.name
  properties: {
    subnet: (empty(frontendIPConfiguration.properties.subnetId) ? json('null') : frontendsObj.subnets[index])
    publicIPAddress: (empty(frontendIPConfiguration.properties.publicIPAddressId) ? json('null') : frontendsObj.publicIPAddresses[index])
    privateIPAddress: (empty(frontendIPConfiguration.properties.privateIPAddress) ? json('null') : frontendIPConfiguration.properties.privateIPAddress)
    privateIPAllocationMethod: (empty(frontendIPConfiguration.properties.subnetId) ? json('null') : (empty(frontendIPConfiguration.properties.privateIPAddress) ? 'Dynamic' : 'Static'))
  }
}]

var loadBalancingRules_var = [for loadBalancingRule in loadBalancingRules: {
  name: loadBalancingRule.name
  properties: {
    backendAddressPool: {
      id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, loadBalancingRule.properties.backendAddressPoolName)
    }
    backendPort: loadBalancingRule.properties.backendPort
    disableOutboundSnat: (contains(loadBalancingRule.properties, 'disableOutboundSnat') ? loadBalancingRule.properties.disableOutboundSnat : 'false')
    enableFloatingIP: loadBalancingRule.properties.enableFloatingIP
    enableTcpReset: (contains(loadBalancingRule.properties, 'enableTcpReset') ? loadBalancingRule.properties.enableTcpReset : 'false')
    frontendIPConfiguration: {
      id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, loadBalancingRule.properties.frontendIPConfigurationName)
    }
    frontendPort: loadBalancingRule.properties.frontendPort
    idleTimeoutInMinutes: loadBalancingRule.properties.idleTimeoutInMinutes
    loadDistribution: (contains(loadBalancingRule.properties, 'loadDistribution') ? loadBalancingRule.properties.loadDistribution : 'Default')
    probe: {
      id: '${resourceId('Microsoft.Network/loadBalancers', loadBalancerName)}/probes/${loadBalancingRule.properties.probeName}'
    }
    protocol: loadBalancingRule.properties.protocol
  }
}]

var probes_var = [for probe in probes: {
  name: probe.name
  properties: {
    protocol: probe.properties.protocol
    requestPath: ((toLower(probe.properties.protocol) == 'tcp') ? json('null') : probe.properties.requestPath)
    port: probe.properties.port
    intervalInSeconds: probe.properties.intervalInSeconds
    numberOfProbes: probe.properties.numberOfProbes
  }
}]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

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
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
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
  'Virtual Machine Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c0163c0-47e6-4577-8991-ea5c82e286e4')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Virtual Machine User Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb879df8-f326-4884-b1cf-06f3ad86be52')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-02-01' = {
  name: loadBalancerName
  location: location
  tags: tags
  sku: {
    name: loadBalancerSku
  }
  properties: {
    frontendIPConfigurations: frontendIPConfigurations_var
    backendAddressPools: backendAddressPools
    loadBalancingRules: loadBalancingRules_var
    probes: probes_var
  }
}

resource loadBalancer_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${loadBalancer.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: loadBalancer
}

resource loadBalancer_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${loadBalancer.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
  }
  scope: loadBalancer
}

module loadBalancer_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: loadBalancer.name
  }
}]

output loadBalancerName string = loadBalancer.name
output loadBalancerResourceId string = loadBalancer.id
output loadBalancerResourceGroup string = resourceGroup().name
