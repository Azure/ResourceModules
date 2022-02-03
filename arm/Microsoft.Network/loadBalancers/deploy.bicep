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

@description('Optional. Collection of backend address pools used by a load balancer.')
param backendAddressPools array = []

@description('Optional. Array of objects containing all load balancing rules')
param loadBalancingRules array = []

@description('Optional. Array of objects containing all probes, these are references in the load balancing rules')
param probes array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

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

@description('Optional. Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules.')
param inboundNatRules array = []

@description('Optional. The outbound rules.')
param outboundRules array = []

var frontendsSubnets = [for item in frontendIPConfigurations: {
  id: item.subnetId
}]
var frontendsPublicIPAddresses = [for item in frontendIPConfigurations: {
  id: item.publicIPAddressId
}]
var frontendsObj = {
  subnets: frontendsSubnets
  publicIPAddresses: frontendsPublicIPAddresses
}

var frontendIPConfigurations_var = [for (frontendIPConfiguration, index) in frontendIPConfigurations: {
  name: frontendIPConfiguration.name
  properties: {
    subnet: !empty(frontendIPConfiguration.subnetId) ? frontendsObj.subnets[index] : null
    publicIPAddress: !empty(frontendIPConfiguration.publicIPAddressId) ? frontendsObj.publicIPAddresses[index] : null
    privateIPAddress: !empty(frontendIPConfiguration.privateIPAddress) ? frontendIPConfiguration.privateIPAddress : null
    privateIPAllocationMethod: !empty(frontendIPConfiguration.subnetId) ? (empty(frontendIPConfiguration.privateIPAddress) ? 'Dynamic' : 'Static') : null
  }
}]

var loadBalancingRules_var = [for loadBalancingRule in loadBalancingRules: {
  name: loadBalancingRule.name
  properties: {
    backendAddressPool: {
      id: az.resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, loadBalancingRule.backendAddressPoolName)
    }
    backendPort: loadBalancingRule.backendPort
    disableOutboundSnat: contains(loadBalancingRule, 'disableOutboundSnat') ? loadBalancingRule.disableOutboundSnat : true
    enableFloatingIP: contains(loadBalancingRule, 'enableFloatingIP') ? loadBalancingRule.enableFloatingIP : false
    enableTcpReset: contains(loadBalancingRule, 'enableTcpReset') ? loadBalancingRule.enableTcpReset : false
    frontendIPConfiguration: {
      id: az.resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', name, loadBalancingRule.frontendIPConfigurationName)
    }
    frontendPort: loadBalancingRule.frontendPort
    idleTimeoutInMinutes: contains(loadBalancingRule, 'idleTimeoutInMinutes') ? loadBalancingRule.idleTimeoutInMinutes : 4
    loadDistribution: contains(loadBalancingRule, 'loadDistribution') ? loadBalancingRule.loadDistribution : 'Default'
    probe: {
      id: '${az.resourceId('Microsoft.Network/loadBalancers', name)}/probes/${loadBalancingRule.probeName}'
    }
    protocol: contains(loadBalancingRule, 'protocol') ? loadBalancingRule.protocol : 'Tcp'
  }
}]

var outboundRules_var = [for outboundRule in outboundRules: {
  name: outboundRule.name
  properties: {
    frontendIPConfigurations: [
      {
        id: az.resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', name, outboundRule.frontendIPConfigurationName)
      }
    ]
    backendAddressPool: {
      id: az.resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, outboundRule.backendAddressPoolName)
    }
    protocol: contains(outboundRule, 'protocol') ? outboundRule.protocol : 'All'
    allocatedOutboundPorts: contains(outboundRule, 'allocatedOutboundPorts') ? outboundRule.allocatedOutboundPorts : 63984
    enableTcpReset: contains(outboundRule, 'enableTcpReset') ? outboundRule.enableTcpReset : true
    idleTimeoutInMinutes: contains(outboundRule, 'idleTimeoutInMinutes') ? outboundRule.idleTimeoutInMinutes : 4
  }
}]

var probes_var = [for probe in probes: {
  name: probe.name
  properties: {
    protocol: contains(probe, 'protocol') ? probe.protocol : 'Tcp'
    requestPath: (contains(probe, 'protocol') && toLower(probe.protocol) == 'tcp') ? null : probe.requestPath
    port: contains(probe, 'port') ? probe.port : 80
    intervalInSeconds: contains(probe, 'intervalInSeconds') ? probe.intervalInSeconds : 5
    numberOfProbes: contains(probe, 'numberOfProbes') ? probe.numberOfProbes : 2
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

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-05-01' = {
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
    outboundRules: outboundRules_var
    probes: probes_var
  }
}

module loadBalancer_backendAddressPools 'backendAddressPools/deploy.bicep' = [for (backendAddressPool, index) in backendAddressPools: {
  name: '${uniqueString(deployment().name, location)}-LoadBalancer-backendAddressPools-${index}'
  params: {
    loadBalancerName: loadBalancer.name
    name: backendAddressPool.name
    loadBalancerBackendAddresses: contains(backendAddressPool, 'loadBalancerBackendAddresses') ? backendAddressPool.loadBalancerBackendAddresses : []
    tunnelInterfaces: contains(backendAddressPool, 'tunnelInterfaces') ? backendAddressPool.tunnelInterfaces : []
  }
}]

module loadBalancer_inboundNATRules 'inboundNatRules/deploy.bicep' = [for (inboundNATRule, index) in inboundNatRules: {
  name: '${uniqueString(deployment().name, location)}-LoadBalancer-inboundNatRules-${index}'
  params: {
    loadBalancerName: loadBalancer.name
    name: inboundNATRule.name
    frontendIPConfigurationName: inboundNATRule.frontendIPConfigurationName
    frontendPort: inboundNATRule.frontendPort
    backendPort: contains(inboundNATRule, 'backendPort') ? inboundNATRule.backendPort : inboundNATRule.frontendPort
    backendAddressPoolName: contains(inboundNATRule, 'backendAddressPoolName') ? inboundNATRule.backendAddressPoolName : ''
    enableFloatingIP: contains(inboundNATRule, 'enableFloatingIP') ? inboundNATRule.enableFloatingIP : false
    enableTcpReset: contains(inboundNATRule, 'enableTcpReset') ? inboundNATRule.enableTcpReset : false
    frontendPortRangeEnd: contains(inboundNATRule, 'frontendPortRangeEnd') ? inboundNATRule.frontendPortRangeEnd : -1
    frontendPortRangeStart: contains(inboundNATRule, 'frontendPortRangeStart') ? inboundNATRule.frontendPortRangeStart : -1
    idleTimeoutInMinutes: contains(inboundNATRule, 'idleTimeoutInMinutes') ? inboundNATRule.idleTimeoutInMinutes : 4
    protocol: contains(inboundNATRule, 'protocol') ? inboundNATRule.protocol : 'Tcp'
  }
  dependsOn: [
    loadBalancer_backendAddressPools
  ]
}]

resource loadBalancer_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${loadBalancer.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: loadBalancer
}

resource loadBalancer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${loadBalancer.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
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
output name string = loadBalancer.name

@description('The resource ID of the load balancer')
output resourceId string = loadBalancer.id

@description('The resource group the load balancer was deployed into')
output resourceGroupName string = resourceGroup().name
