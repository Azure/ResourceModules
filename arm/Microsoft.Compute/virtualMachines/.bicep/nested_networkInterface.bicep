param networkInterfaceName string
param virtualMachineName string
param location string
param tags object
param enableIPForwarding bool = false
param enableAcceleratedNetworking bool = false
param dnsServers array = []
param networkSecurityGroupId string = ''
param ipConfigurationArray array
param lock string
param diagnosticStorageAccountId string
param diagnosticLogsRetentionInDays int
param workspaceId string
param eventHubAuthorizationRuleId string
param eventHubName string
param pipMetricsToEnable array
param pipLogsToEnable array
param metricsToEnable array
param roleAssignments array

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var dnsServersValues = {
  dnsServers: dnsServers
}

var networkSecurityGroup = {
  id: networkSecurityGroupId
}

module networkInterface_publicIPConfigurations 'nested_networkInterface_publicIPAddress.bicep' = [for (ipConfiguration, index) in ipConfigurationArray: if (contains(ipConfiguration, 'pipconfiguration')) {
  name: '${deployment().name}-PIP-${index}'
  params: {
    publicIPAddressName: '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}'
    publicIPPrefixId: (contains(ipConfiguration.pipconfiguration, 'publicIPPrefixId') ? (!(empty(ipConfiguration.pipconfiguration.publicIPPrefixId)) ? ipConfiguration.pipconfiguration.publicIPPrefixId : '') : '')
    publicIPAllocationMethod: (contains(ipConfiguration.pipconfiguration, 'publicIPAllocationMethod') ? (!(empty(ipConfiguration.pipconfiguration.publicIPAllocationMethod)) ? ipConfiguration.pipconfiguration.publicIPAllocationMethod : 'Static') : 'Static')
    skuName: (contains(ipConfiguration.pipconfiguration, 'skuName') ? (!(empty(ipConfiguration.pipconfiguration.skuName)) ? ipConfiguration.pipconfiguration.skuName : 'Standard') : 'Standard')
    skuTier: (contains(ipConfiguration.pipconfiguration, 'skuTier') ? (!(empty(ipConfiguration.pipconfiguration.skuTier)) ? ipConfiguration.pipconfiguration.skuTier : 'Regional') : 'Regional')
    location: location
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    metricsToEnable: pipMetricsToEnable
    logsToEnable: pipLogsToEnable
    lock: lock
    roleAssignments: contains(ipConfiguration.pipconfiguration, 'roleAssignments') ? (!empty(ipConfiguration.pipconfiguration.roleAssignments) ? ipConfiguration.pipconfiguration.roleAssignments : []) : []
    tags: tags
  }
}]

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: networkInterfaceName
  location: location
  tags: tags
  properties: {
    enableIPForwarding: enableIPForwarding
    enableAcceleratedNetworking: enableAcceleratedNetworking
    dnsSettings: !empty(dnsServers) ? dnsServersValues : null
    networkSecurityGroup: !empty(networkSecurityGroupId) ? networkSecurityGroup : null
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurationArray: {
      name: !empty(ipConfiguration.name) ? ipConfiguration.name : null
      properties: {
        primary: ((index == 0) ? true : false)
        privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null) : null
        privateIPAddress: contains(ipConfiguration, 'vmIPAddress') ? (!empty(ipConfiguration.vmIPAddress) ? ipConfiguration.vmIPAddress : null) : null
        publicIPAddress: contains(ipConfiguration, 'pipconfiguration') ? json('{"id":"${resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}')}"}') : null
        subnet: {
          id: ipConfiguration.subnetId
        }
      }
    }]
  }
  dependsOn: [
    networkInterface_publicIPConfigurations
  ]
}

resource networkInterface_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${networkInterface.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkInterface
}

resource networkInterface_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${networkInterface.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(workspaceId) ? workspaceId : null
    eventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : null
    eventHubName: !empty(eventHubName) ? eventHubName : null
    metrics: !empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName) ? diagnosticsMetrics : null
  }
  scope: networkInterface
}

module networkInterface_rbac 'nested_networkInterface_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: networkInterface.id
  }
}]
