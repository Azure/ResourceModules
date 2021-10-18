param networkInterfaceName string
param virtualMachineName string
param location string
param tags object
param nicConfiguration object
// param lockForDeletion bool
// param diagnosticSettingName string
// param diagnosticStorageAccountId string
// param workspaceId string
// param eventHubAuthorizationRuleId string
// param eventHubName string
// param diagnosticsMetrics array
// param diagnosticLogsRetentionInDays int

// var networkInterfaceName = '${virtualMachineName}${nicConfiguration.nicSuffix}'

var dnsServersValues = {
  dnsServers: (contains(nicConfiguration, 'dnsServers') ? nicConfiguration.dnsServers : json('[]'))
}

// var enablePublicIPObj = [for (ipConfiguration, index) in nicConfiguration.ipConfigurations: {
//   ipConfigName: ipConfiguration.name
//   enablePublicIP: contains(ipConfiguration, 'enablePublicIP') ? (ipConfiguration.enablePublicIP ? 'true' : 'false ') : 'false'
// }]

module networkInterface_publicIPConfigurations './nested_networkInterface_publicIPAddress.bicep' = [for (ipConfiguration, index) in nicConfiguration.ipConfigurations: if ([contains(ipConfiguration, 'pipconfiguration') || !empty(ipConfiguration.pipconfiguration)]) {
name: '${networkInterfaceName}-publicIPConfiguration-${index}'
params: {
publicIPAddressName: '${virtualMachineName}${ipConfiguration.publicIpNameSuffix}'
// publicIPPrefixId: (contains(ipConfiguration, 'publicIPPrefixId') ? (!(empty(ipConfiguration.publicIPPrefixId)) ? ipConfiguration.publicIPPrefixId : json('null')) : json('null'))
publicIPPrefixId: (contains(ipConfiguration, 'publicIPPrefixId') ? ipConfiguration.publicIPPrefixId : '')
publicIPAllocationMethod: 'Static'
skuName: 'Standard'
// skuTier: ipConfiguration.skuTier
location: location
// diagnosticLogsRetentionInDays: ipConfiguration.diagnosticLogsRetentionInDays
// diagnosticStorageAccountId: ipConfiguration.diagnosticStorageAccountId
// workspaceId: ipConfiguration.workspaceId
// eventHubAuthorizationRuleId: ipConfiguration.eventHubAuthorizationRuleId
// eventHubName: ipConfiguration.eventHubName
// lockForDeletion: ipConfiguration.lockForDeletion
// roleAssignments: ipConfiguration.roleAssignments
tags: tags
}
}]

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: networkInterfaceName
  location: location
  tags: tags
  properties: {
    enableIPForwarding: (contains(nicConfiguration, 'enableIPForwarding') ? nicConfiguration.enableIPForwarding : 'false')
    enableAcceleratedNetworking: (contains(nicConfiguration, 'enableAcceleratedNetworking') ? nicConfiguration.enableAcceleratedNetworking : 'false')
    dnsSettings: (contains(nicConfiguration, 'dnsServers') ? (empty(nicConfiguration.dnsServers) ? json('null') : dnsServersValues) : json('null'))
    ipConfigurations: [for (ipConfiguration, index) in nicConfiguration.ipConfigurations: {
      // j in range(0, length(nicConfiguration.ipConfigurations))
      name: (!empty(ipConfiguration.name) ? ipConfiguration.name : json('null'))
      // (contains(nicConfiguration.ipConfigurations[j], 'name') ? nicConfiguration.ipConfigurations[j].name : 'ipconfig${(j + 1)}')
      properties: {
        primary: ((index == 0) ? 'true' : 'false')
        privateIPAllocationMethod: (contains(ipConfiguration, 'vmIPAddress') ? (!empty(ipConfiguration.vmIPAddress) ? ipConfiguration.vmIPAddress : json('null')) : json('null'))
        publicIPAddress: (ipConfiguration.enablePublicIP ? json('{"id":"${resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.publicIpNameSuffix}')}"}') : json('null'))

        // privateIPAllocationMethod: (contains(nicConfiguration.ipConfigurations[j], 'vmIPAddress') ? (empty(nicConfiguration.ipConfigurations[j].vmIPAddress) ? 'Dynamic' : 'Static') : 'Dynamic')
        // publicIPAddress: (contains(nicConfiguration.ipConfigurations[j], 'enablePublicIP') ? (nicConfiguration.ipConfigurations[j].enablePublicIP ? json('{"id":"${resourceId('Microsoft.Network/publicIPAddresses', concat(vmName, nicConfiguration.ipConfigurations[j].publicIpNameSuffix))}"}') : json('null')) : json('null'))
        // privateIPAddress: (contains(nicConfiguration.ipConfigurations[j], 'vmIPAddress') ? (empty(nicConfiguration.ipConfigurations[j].vmIPAddress) ? json('null') : iacs.nextIP(nicConfiguration.ipConfigurations[j].vmIPAddress, vmLoopIndex)) : json('null'))
        subnet: {
          id: ipConfiguration.subnetId
        }
        // loadBalancerBackendAddressPools: (contains(nicConfiguration.ipConfigurations[j], 'loadBalancerBackendAddressPools') ? nicConfiguration.ipConfigurations[j].loadBalancerBackendAddressPools : '')
        // applicationSecurityGroups: (contains(nicConfiguration.ipConfigurations[j], 'applicationSecurityGroups') ? nicConfiguration.ipConfigurations[j].applicationSecurityGroups : '')

        // loadBalancerBackendAddressPools: (contains(nicConfiguration.ipConfigurations[j], 'loadBalancerBackendAddressPools') ? nicConfiguration.ipConfigurations[j].loadBalancerBackendAddressPools : '')
        // applicationSecurityGroups: (contains(nicConfiguration.ipConfigurations[j], 'applicationSecurityGroups') ? nicConfiguration.ipConfigurations[j].applicationSecurityGroups : '')
      }
    }]
  }
  dependsOn: [
    networkInterface_publicIPConfigurations
  ]
}

// resource nicName_Microsoft_Authorization_networkInterfaceDoNotDelete 'Microsoft.Network/networkInterfaces/providers/locks@2016-09-01' = if (lockForDeletion) {
//   name: '${nicName_var}/Microsoft.Authorization/networkInterfaceDoNotDelete'
//   properties: {
//     level: 'CannotDelete'
//   }
//   dependsOn: [
//     nicName
//   ]
// }

// resource nicName_Microsoft_Insights_diagnosticSettingName 'Microsoft.Network/networkInterfaces/providers/diagnosticSettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
//   location: location
//   tags: tags
//   name: '${nicName_var}/Microsoft.Insights/${diagnosticSettingName}'
//   properties: {
//     storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
//     workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
//     eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
//     eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
//     metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
//   }
//   dependsOn: [
//     nicName
//   ]
// }
