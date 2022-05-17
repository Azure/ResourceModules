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
param diagnosticWorkspaceId string
param diagnosticEventHubAuthorizationRuleId string
param diagnosticEventHubName string
param pipdiagnosticMetricsToEnable array
param pipdiagnosticLogCategoriesToEnable array
param nicDiagnosticMetricsToEnable array
param roleAssignments array

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of the PIP diagnostic setting, if deployed.')
param pipDiagnosticSettingsName string = '${virtualMachineName}-diagnosticSettings'

@description('Optional. The name of the NIC diagnostic setting, if deployed.')
param nicDiagnosticSettingsName string = '${virtualMachineName}-diagnosticSettings'

var nicDiagnosticsMetrics = [for metric in nicDiagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

module networkInterface_publicIPAddresses '../../../Microsoft.Network/publicIPAddresses/deploy.bicep' = [for (ipConfiguration, index) in ipConfigurationArray: if (contains(ipConfiguration, 'pipconfiguration')) {
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
    enableDefaultTelemetry: enableDefaultTelemetry
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

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = {
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
        privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null) : null
        privateIPAddress: contains(ipConfiguration, 'vmIPAddress') ? (!empty(ipConfiguration.vmIPAddress) ? ipConfiguration.vmIPAddress : null) : null
        publicIPAddress: contains(ipConfiguration, 'pipconfiguration') ? {
          id: resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}')
        } : null
        subnet: {
          id: ipConfiguration.subnetId
        }
        loadBalancerBackendAddressPools: contains(ipConfiguration, 'loadBalancerBackendAddressPools') ? ipConfiguration.loadBalancerBackendAddressPools : null
        applicationSecurityGroups: contains(ipConfiguration, 'applicationSecurityGroups') ? ipConfiguration.applicationSecurityGroups : null
      }
    }]
  }
  dependsOn: [
    networkInterface_publicIPAddresses
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
  name: nicDiagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: nicDiagnosticsMetrics
  }
  scope: networkInterface
}

module networkInterface_rbac 'nested_networkInterface_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: networkInterface.id
  }
}]
