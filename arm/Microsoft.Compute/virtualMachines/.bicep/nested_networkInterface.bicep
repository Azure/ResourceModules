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
  name: '${deployment().name}-pip-${index}'
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
    roleAssignments: (contains(ipConfiguration.pipconfiguration, 'roleAssignments') ? (!(empty(ipConfiguration.pipconfiguration.roleAssignments)) ? ipConfiguration.pipconfiguration.roleAssignments : json('[]')) : json('[]'))
    tags: tags
  }
}]

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: networkInterfaceName
  location: location
  tags: tags
  properties: {
    enableIPForwarding: enableIPForwarding
    enableAcceleratedNetworking: enableAcceleratedNetworking
    dnsSettings: (!empty(dnsServers) ? dnsServersValues : json('null'))
    networkSecurityGroup: (!empty(networkSecurityGroupId) ? networkSecurityGroup : json('null'))
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurationArray: {
      name: (!empty(ipConfiguration.name) ? ipConfiguration.name : json('null'))
      properties: {
        primary: ((index == 0) ? true : false)
        privateIPAllocationMethod: (contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : json('null')) : json('null'))
        privateIPAddress: (contains(ipConfiguration, 'vmIPAddress') ? (empty(ipConfiguration.vmIPAddress) ? json('null') : ipConfiguration.vmIPAddress) : json('null'))
        publicIPAddress: ((contains(ipConfiguration, 'pipconfiguration')) ? json('{"id":"${resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}')}"}') : json('null'))
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
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkInterface
}

resource networkInterface_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${networkInterface.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
  }
  scope: networkInterface
}

module networkInterface_rbac 'nested_networkInterface_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: networkInterface.name
  }
}]
