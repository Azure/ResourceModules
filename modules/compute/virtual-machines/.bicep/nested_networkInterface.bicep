param networkInterfaceName string
param virtualMachineName string
param location string
param tags object
param enableIPForwarding bool = false
param enableAcceleratedNetworking bool = false
param dnsServers array = []

@description('Optional. The network security group (NSG) to attach to the network interface.')
param networkSecurityGroupResourceId string = ''

param ipConfigurations array
param lock string = ''
param diagnosticStorageAccountId string
param diagnosticLogsRetentionInDays int
param diagnosticWorkspaceId string
param diagnosticEventHubAuthorizationRuleId string
param diagnosticEventHubName string
param pipdiagnosticMetricsToEnable array
param pipdiagnosticLogCategoriesToEnable array
param nicDiagnosticMetricsToEnable array

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The name of the PIP diagnostic setting, if deployed.')
param pipDiagnosticSettingsName string = '${virtualMachineName}-diagnosticSettings'

@description('Optional. The name of the NIC diagnostic setting, if deployed.')
param nicDiagnosticSettingsName string = '${virtualMachineName}-diagnosticSettings'

var enableReferencedModulesTelemetry = false

module networkInterface_publicIPAddresses '../../../network/public-ip-addresses/main.bicep' = [for (ipConfiguration, index) in ipConfigurations: if (contains(ipConfiguration, 'pipconfiguration')) {
  name: '${deployment().name}-publicIP-${index}'
  params: {
    name: '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}'
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    diagnosticLogCategoriesToEnable: pipdiagnosticLogCategoriesToEnable
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    diagnosticMetricsToEnable: pipdiagnosticMetricsToEnable
    diagnosticSettingsName: pipDiagnosticSettingsName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticWorkspaceId: diagnosticWorkspaceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    lock: lock
    publicIPAddressVersion: contains(ipConfiguration, 'publicIPAddressVersion') ? ipConfiguration.publicIPAddressVersion : 'IPv4'
    publicIPAllocationMethod: contains(ipConfiguration, 'publicIPAllocationMethod') ? ipConfiguration.publicIPAllocationMethod : 'Static'
    publicIPPrefixResourceId: contains(ipConfiguration, 'publicIPPrefixResourceId') ? ipConfiguration.publicIPPrefixResourceId : ''
    roleAssignments: contains(ipConfiguration, 'roleAssignments') ? ipConfiguration.roleAssignments : []
    skuName: contains(ipConfiguration, 'skuName') ? ipConfiguration.skuName : 'Standard'
    skuTier: contains(ipConfiguration, 'skuTier') ? ipConfiguration.skuTier : 'Regional'
    tags: tags
    zones: contains(ipConfiguration, 'zones') ? ipConfiguration.zones : []
  }
}]

module networkInterface '../../../network/network-interfaces/main.bicep' = {
  name: '${deployment().name}-NetworkInterface'
  params: {
    name: networkInterfaceName
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurations: {
      name: !empty(ipConfiguration.name) ? ipConfiguration.name : null
      primary: index == 0
      privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null) : null
      privateIPAddress: contains(ipConfiguration, 'privateIPAddress') ? (!empty(ipConfiguration.privateIPAddress) ? ipConfiguration.privateIPAddress : null) : null
      publicIPAddressResourceId: contains(ipConfiguration, 'pipconfiguration') ? resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}') : null
      subnetResourceId: ipConfiguration.subnetResourceId
      loadBalancerBackendAddressPools: contains(ipConfiguration, 'loadBalancerBackendAddressPools') ? ipConfiguration.loadBalancerBackendAddressPools : null
      applicationSecurityGroups: contains(ipConfiguration, 'applicationSecurityGroups') ? ipConfiguration.applicationSecurityGroups : null
      applicationGatewayBackendAddressPools: contains(ipConfiguration, 'applicationGatewayBackendAddressPools') ? ipConfiguration.applicationGatewayBackendAddressPools : null
      gatewayLoadBalancer: contains(ipConfiguration, 'gatewayLoadBalancer') ? ipConfiguration.gatewayLoadBalancer : null
      loadBalancerInboundNatRules: contains(ipConfiguration, 'loadBalancerInboundNatRules') ? ipConfiguration.loadBalancerInboundNatRules : null
      privateIPAddressVersion: contains(ipConfiguration, 'privateIPAddressVersion') ? ipConfiguration.privateIPAddressVersion : null
      virtualNetworkTaps: contains(ipConfiguration, 'virtualNetworkTaps') ? ipConfiguration.virtualNetworkTaps : null
    }]
    location: location
    tags: tags
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticMetricsToEnable: nicDiagnosticMetricsToEnable
    diagnosticSettingsName: nicDiagnosticSettingsName
    diagnosticWorkspaceId: diagnosticWorkspaceId
    dnsServers: !empty(dnsServers) ? dnsServers : []
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    enableIPForwarding: enableIPForwarding
    lock: lock
    networkSecurityGroupResourceId: !empty(networkSecurityGroupResourceId) ? networkSecurityGroupResourceId : ''
    roleAssignments: !empty(roleAssignments) ? roleAssignments : []
  }
  dependsOn: [
    networkInterface_publicIPAddresses
  ]
}
