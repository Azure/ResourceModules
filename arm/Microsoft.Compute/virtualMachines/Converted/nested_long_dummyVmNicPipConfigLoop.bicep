// nested_nicConfigurations_1_vmName_nicConfigurations_0_nicSuffix_nicConfigurations_0_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop_dummyVmNicPipConfigLoop
param location string
param tags object
param vmName string
param ipConfiguration object
param lockForDeletion bool
param diagnosticSettingName string
param diagnosticStorageAccountId string
param workspaceId string
param eventHubAuthorizationRuleId string
param eventHubName string
param diagnosticsMetrics array
param diagnosticLogsRetentionInDays int

var pipName_var = (contains(ipConfiguration, 'publicIpNameSuffix') ? concat(vmName, ipConfiguration.publicIpNameSuffix) : 'dummyPipName')
var pipDiagnosticsLogs = [
  {
    category: 'DDoSProtectionNotifications'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'DDoSMitigationFlowLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'DDoSMitigationReports'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]

resource pipName 'Microsoft.Network/publicIPAddresses@2020-08-01' = if (contains(ipConfiguration, 'enablePublicIP') && ipConfiguration.enablePublicIP) {
  name: pipName_var
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPPrefix: (contains(ipConfiguration, 'publicIPPrefixId') ? ((!empty(ipConfiguration.publicIPPrefixId)) ? json('{"id": "${ipConfiguration.publicIPPrefixId}"}') : json('null')) : json('null'))
  }
  zones: json('null')
}

resource pipName_Microsoft_Authorization_publicIpDoNotDelete 'Microsoft.Network/publicIPAddresses/providers/locks@2016-09-01' = if (contains(ipConfiguration, 'enablePublicIP') && ipConfiguration.enablePublicIP) {
  name: '${pipName_var}/Microsoft.Authorization/publicIpDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    pipName
  ]
}

resource pipName_Microsoft_Insights_diagnosticSettingName 'Microsoft.Network/publicIPAddresses/providers/diagnosticSettings@2017-05-01-preview' = if (contains(ipConfiguration, 'enablePublicIP') && ipConfiguration.enablePublicIP) {
  location: location
  tags: tags
  name: '${pipName_var}/Microsoft.Insights/${diagnosticSettingName}'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : pipDiagnosticsLogs)
  }
  dependsOn: [
    pipName
  ]
}
