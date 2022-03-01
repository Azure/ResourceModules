param networkInterfaceName string
param virtualMachineName string
param location string
param tags object
param enableIPForwarding bool = false
param enableAcceleratedNetworking bool = false
param dnsServers array = []
param networkSecurityGroupId string = ''
param applicationSecurityGroupId string = ''
param ipConfigurationArray array
param lock string
param diagnosticStorageAccountId string
param diagnosticLogsRetentionInDays int
param diagnosticWorkspaceId string
param diagnosticEventHubAuthorizationRuleId string
param diagnosticEventHubName string
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
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
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
    dnsSettings: !empty(dnsServers) ? {
      dnsServers: dnsServers
    } : null
    networkSecurityGroup: !empty(networkSecurityGroupId) ? {
      id: networkSecurityGroupId
    } : null
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurationArray: {
      name: !empty(ipConfiguration.name) ? ipConfiguration.name : null
      properties: {
        primary: ((index == 0) ? true : false)
        applicationSecurityGroups: !empty(applicationSecurityGroupId) ? [
          {
            id: applicationSecurityGroupId
          }
        ] : null
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

resource networkInterface_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${networkInterface.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
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
