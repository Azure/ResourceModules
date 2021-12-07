@description('Required. The Proximity Placement Groups Name')
param name string

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
    subnet: !empty(frontendIPConfiguration.properties.subnetId) ? frontendsObj.subnets[index] : null
    publicIPAddress: !empty(frontendIPConfiguration.properties.publicIPAddressId) ? frontendsObj.publicIPAddresses[index] : null
    privateIPAddress: !empty(frontendIPConfiguration.properties.privateIPAddress) ? frontendIPConfiguration.properties.privateIPAddress : null
    privateIPAllocationMethod: !empty(frontendIPConfiguration.properties.subnetId) ? (empty(frontendIPConfiguration.properties.privateIPAddress) ? 'Dynamic' : 'Static') : null
  }
}]

var loadBalancingRules_var = [for loadBalancingRule in loadBalancingRules: {
  name: loadBalancingRule.name
  properties: {
    backendAddressPool: {
      id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, loadBalancingRule.properties.backendAddressPoolName)
    }
    backendPort: loadBalancingRule.properties.backendPort
    disableOutboundSnat: contains(loadBalancingRule.properties, 'disableOutboundSnat') ? loadBalancingRule.properties.disableOutboundSnat : 'false'
    enableFloatingIP: loadBalancingRule.properties.enableFloatingIP
    enableTcpReset: contains(loadBalancingRule.properties, 'enableTcpReset') ? loadBalancingRule.properties.enableTcpReset : 'false'
    frontendIPConfiguration: {
      id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', name, loadBalancingRule.properties.frontendIPConfigurationName)
    }
    frontendPort: loadBalancingRule.properties.frontendPort
    idleTimeoutInMinutes: loadBalancingRule.properties.idleTimeoutInMinutes
    loadDistribution: contains(loadBalancingRule.properties, 'loadDistribution') ? loadBalancingRule.properties.loadDistribution : 'Default'
    probe: {
      id: '${resourceId('Microsoft.Network/loadBalancers', name)}/probes/${loadBalancingRule.properties.probeName}'
    }
    protocol: loadBalancingRule.properties.protocol
  }
}]

var probes_var = [for probe in probes: {
  name: probe.name
  properties: {
    protocol: probe.properties.protocol
    requestPath: toLower(probe.properties.protocol) == 'tcp' ? null : probe.properties.requestPath
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

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-02-01' = {
  name: name
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
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: loadBalancer
}

resource loadBalancer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName)) {
  name: '${loadBalancer.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(workspaceId) ? null : workspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsMetrics
  }
  scope: loadBalancer
}

module loadBalancer_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-LoadBalancer-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: loadBalancer.id
  }
}]

@description('The name of the load balancer')
output loadBalancerName string = loadBalancer.name

@description('The resource ID of the load balancer')
output loadBalancerResourceId string = loadBalancer.id

@description('The resource group the load balancer was deployed into')
output loadBalancerResourceGroup string = resourceGroup().name
