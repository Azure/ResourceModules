? /* TODO: User defined functions are not supported and have not been decompiled */
param location string
param tags object
param vmName string
param vmLoopIndex int
param nicConfiguration object
param lockForDeletion bool
param diagnosticSettingName string
param diagnosticStorageAccountId string
param workspaceId string
param eventHubAuthorizationRuleId string
param eventHubName string
param diagnosticsMetrics array
param diagnosticLogsRetentionInDays int

var nicName_var = concat(vmName, nicConfiguration.nicSuffix)
var dnsServersValues = {
  dnsServers: (contains(nicConfiguration, 'dnsServers') ? nicConfiguration.dnsServers : json('[]'))
}

module vmName_nicConfiguration_nicSuffix_nicConfiguration_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop './nested_vmName_nicConfiguration_nicSuffix_nicConfiguration_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop.bicep' = [for i in range(0, length(nicConfiguration.ipConfigurations)): {
  name: '${vmName}${nicConfiguration.nicSuffix}-${nicConfiguration.ipConfigurations[i].name}-vmNicPipConfigLoop'
  params: {
    location: location
    tags: tags
    vmName: vmName
    ipConfiguration: nicConfiguration.ipConfigurations[i]
    lockForDeletion: lockForDeletion
    diagnosticSettingName: diagnosticSettingName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    diagnosticsMetrics: diagnosticsMetrics
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
  }
  dependsOn: []
}]

resource nicName 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  location: location
  tags: tags
  name: nicName_var
  properties: {
    enableIPForwarding: (contains(nicConfiguration, 'enableIPForwarding') ? nicConfiguration.enableIPForwarding : 'false')
    enableAcceleratedNetworking: (contains(nicConfiguration, 'enableAcceleratedNetworking') ? nicConfiguration.enableAcceleratedNetworking : 'false')
    dnsSettings: (contains(nicConfiguration, 'dnsServers') ? (empty(nicConfiguration.dnsServers) ? json('null') : dnsServersValues) : json('null'))
    ipConfigurations: [for j in range(0, length(nicConfiguration.ipConfigurations)): {
      name: (contains(nicConfiguration.ipConfigurations[j], 'name') ? nicConfiguration.ipConfigurations[j].name : 'ipconfig${(j + 1)}')
      properties: {
        primary: ((j == 0) ? 'true' : 'false')
        privateIPAllocationMethod: (contains(nicConfiguration.ipConfigurations[j], 'vmIPAddress') ? (empty(nicConfiguration.ipConfigurations[j].vmIPAddress) ? 'Dynamic' : 'Static') : 'Dynamic')
        publicIPAddress: (contains(nicConfiguration.ipConfigurations[j], 'enablePublicIP') ? (nicConfiguration.ipConfigurations[j].enablePublicIP ? json('{"id":"${resourceId('Microsoft.Network/publicIPAddresses', concat(vmName, nicConfiguration.ipConfigurations[j].publicIpNameSuffix))}"}') : json('null')) : json('null'))
        privateIPAddress: (contains(nicConfiguration.ipConfigurations[j], 'vmIPAddress') ? (empty(nicConfiguration.ipConfigurations[j].vmIPAddress) ? json('null') : iacs.nextIP(nicConfiguration.ipConfigurations[j].vmIPAddress, vmLoopIndex)) : json('null'))
        subnet: {
          id: nicConfiguration.ipConfigurations[j].subnetId
        }
        loadBalancerBackendAddressPools: (contains(nicConfiguration.ipConfigurations[j], 'loadBalancerBackendAddressPools') ? nicConfiguration.ipConfigurations[j].loadBalancerBackendAddressPools : '')
        applicationSecurityGroups: (contains(nicConfiguration.ipConfigurations[j], 'applicationSecurityGroups') ? nicConfiguration.ipConfigurations[j].applicationSecurityGroups : '')
      }
    }]
  }
  dependsOn: [
    vmName_nicConfiguration_nicSuffix_nicConfiguration_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop
  ]
}

resource nicName_Microsoft_Authorization_networkInterfaceDoNotDelete 'Microsoft.Network/networkInterfaces/providers/locks@2016-09-01' = if (lockForDeletion) {
  name: '${nicName_var}/Microsoft.Authorization/networkInterfaceDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    nicName
  ]
}

resource nicName_Microsoft_Insights_diagnosticSettingName 'Microsoft.Network/networkInterfaces/providers/diagnosticSettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  location: location
  tags: tags
  name: '${nicName_var}/Microsoft.Insights/${diagnosticSettingName}'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
  }
  dependsOn: [
    nicName
  ]
}