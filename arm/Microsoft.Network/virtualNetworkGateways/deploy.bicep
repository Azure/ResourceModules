@description('Required. Specifies the Virtual Network Gateway name.')
param virtualNetworkGatewayName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the name of the Public IP used by the Virtual Network Gateway. If it\'s not provided, a \'-pip\' suffix will be appended to the gateway\'s name.')
param gatewayPipName array = []

@description('Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIPPrefixId string = ''

@description('Optional. Specifies the zones of the Public IP address.')
param publicIpZones array = [
  '1'
]

@description('Optional. DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com')
param domainNameLabel array = []

@description('Required. Specifies the gateway type. E.g. VPN, ExpressRoute')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param virtualNetworkGatewayType string

@description('Required. The Sku of the Gateway.')
@allowed([
  'Basic'
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'ErGw1AZ'
  'ErGw2AZ'
  'ErGw3AZ'
])
param virtualNetworkGatewaySku string

@description('Required. Specifies the VPN type')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param vpnType string = 'RouteBased'

@description('Required. Virtual Network resource Id')
param vNetId string

@description('Optional. Value to specify if the Gateway should be deployed in active-active or active-passive configuration')
param activeActive bool = true

@description('Optional. Value to specify if BGP is enabled or not')
param enableBgp bool = true

@description('Optional. ASN value')
param asn int = 65815

@description('Optional. The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network.')
param vpnClientAddressPoolPrefix string = ''

@description('Optional. Client root certificate data used to authenticate VPN clients.')
param clientRootCertData string = ''

@description('Optional. Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet.')
param clientRevokedCertThumbprint string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Required. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Required. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Switch to lock Virtual Network Gateway from deletion.')
param lockForDeletion bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var zoneRedundantSkus = [
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'ErGw1AZ'
  'ErGw2AZ'
  'ErGw3AZ'
]
var gatewayPipSku = contains(zoneRedundantSkus, virtualNetworkGatewaySku) ? 'Standard' : 'Basic'
var gatewayPipAllocationMethod = contains(zoneRedundantSkus, virtualNetworkGatewaySku) ? 'Static' : 'Dynamic'
var gatewaySubnetId = '${vNetId}/subnets/GatewaySubnet'
var activeActive_var = (virtualNetworkGatewayType == 'ExpressRoute') ? bool('false') : activeActive

// Public IP variables
var gatewayPipName1 = (length(gatewayPipName) == 0) ? '${virtualNetworkGatewayName}-pip1' : gatewayPipName[0]
var gatewayPipName2 = activeActive_var ? ((length(gatewayPipName) == 1) ? '${virtualNetworkGatewayName}-pip2' : gatewayPipName[1]) : ''

var gatewayMultiPipArray = [
  gatewayPipName1
  gatewayPipName2
]
var gatewaySinglePipArray = [
  gatewayPipName1
]
var gatewayPipName_var = (!empty(gatewayPipName2)) ? gatewayMultiPipArray : gatewaySinglePipArray
var gatewayPipId1 = resourceId('Microsoft.Network/publicIPAddresses', gatewayPipName1)
var gatewayPipId2 = activeActive_var ? resourceId('Microsoft.Network/publicIPAddresses', gatewayPipName2) : resourceId('Microsoft.Network/publicIPAddresses', gatewayPipName1)

var enableBgp_var = (virtualNetworkGatewayType == 'ExpressRoute') ? bool('false') : enableBgp
var vpnType_var = (virtualNetworkGatewayType == 'ExpressRoute') ? 'PolicyBased' : vpnType
var bgpSettings = {
  asn: asn
}
var publicIPPrefix = {
  id: publicIPPrefixId
}
var activePassiveIpConfiguration = [
  {
    properties: {
      privateIPAllocationMethod: 'Dynamic'
      subnet: {
        id: gatewaySubnetId
      }
      publicIPAddress: {
        id: gatewayPipId1
      }
    }
    name: 'vNetGatewayConfig1'
  }
]
var activeActiveIpConfiguration = [
  {
    properties: {
      privateIPAllocationMethod: 'Dynamic'
      subnet: {
        id: gatewaySubnetId
      }
      publicIPAddress: {
        id: gatewayPipId1
      }
    }
    name: 'vNetGatewayConfig1'
  }
  {
    properties: {
      privateIPAllocationMethod: 'Dynamic'
      subnet: {
        id: gatewaySubnetId
      }
      publicIPAddress: {
        id: gatewayPipId2
      }
    }
    name: 'vNetGatewayConfig2'
  }
]
var vpnClientRootCertificates = [
  {
    name: 'RootCert1'
    properties: {
      PublicCertData: clientRootCertData
    }
  }
]
var vpmClientRevokedCertificates = [
  {
    name: 'RevokedCert1'
    properties: {
      Thumbprint: clientRevokedCertThumbprint
    }
  }
]
var vpnClientConfiguration = {
  vpnClientAddressPool: {
    addressPrefixes: [
      vpnClientAddressPoolPrefix
    ]
  }
  vpnClientRootCertificates: (empty(clientRootCertData) ? json('null') : vpnClientRootCertificates)
  vpnClientRevokedCertificates: (empty(clientRevokedCertThumbprint) ? json('null') : vpmClientRevokedCertificates)
}
var diagnosticsMetrics = [
  {
    category: 'AllMetrics'
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var publicIpDiagnosticsLogs = [
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
var virtualNetworkGatewayDiagnosticsLogs = [
  {
    category: 'GatewayDiagnosticLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'TunnelDiagnosticLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'RouteDiagnosticLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'IKEDiagnosticLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'P2SDiagnosticLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

// Public IPs
// ==========
@batchSize(1)
resource virtualGatewayPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = [for (item, i) in gatewayPipName_var: {
  name: item
  location: location
  tags: tags
  sku: {
    name: gatewayPipSku
  }
  properties: {
    publicIPAllocationMethod: gatewayPipAllocationMethod
    publicIPPrefix: ((!empty(publicIPPrefixId)) ? publicIPPrefix : json('null'))
    dnsSettings: ((length(gatewayPipName_var) == length(domainNameLabel)) ? json('{"domainNameLabel": "${domainNameLabel[i]}"}') : json('null'))
  }
  zones: publicIpZones
}]

@batchSize(1)
resource virtualNetworkGatewayPublicIp_lock 'Microsoft.Network/publicIPAddresses/providers/locks@2016-09-01' = [for virtualGatewayPublicIpName in gatewayPipName_var: if (lockForDeletion) {
  name: '${virtualGatewayPublicIpName}/Microsoft.Authorization/virtualNetworkGatewayPublicIpDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  dependsOn: [
    virtualGatewayPublicIP
  ]
}]

@batchSize(1)
resource virtualNetworkGatewayPublicIp_diagnosticSettings 'Microsoft.Network/publicIPAddresses/providers/diagnosticsettings@2017-05-01-preview' = [for virtualGatewayPublicIpName in gatewayPipName_var: if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${virtualGatewayPublicIpName}/Microsoft.Insights/diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : publicIpDiagnosticsLogs)
  }
  dependsOn: [
    virtualGatewayPublicIP
  ]
}]

// VNET Gateway
// ============
resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2021-02-01' = {
  name: virtualNetworkGatewayName
  location: location
  tags: tags
  properties: {
    ipConfigurations: (activeActive_var ? activeActiveIpConfiguration : activePassiveIpConfiguration)
    activeActive: activeActive_var
    enableBgp: enableBgp_var
    bgpSettings: ((virtualNetworkGatewayType == 'ExpressRoute') ? json('null') : bgpSettings)
    sku: {
      name: virtualNetworkGatewaySku
      tier: virtualNetworkGatewaySku
    }
    gatewayType: virtualNetworkGatewayType
    vpnType: vpnType_var
    vpnClientConfiguration: (empty(vpnClientAddressPoolPrefix) ? json('null') : vpnClientConfiguration)
  }
  dependsOn: [
    virtualGatewayPublicIP
  ]
}

resource virtualNetworkGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${virtualNetworkGatewayName}-virtualNetworkGatewayDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: virtualNetworkGateway
}

resource virtualNetworkGateway_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${virtualNetworkGatewayName}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : virtualNetworkGatewayDiagnosticsLogs)
  }
  scope: virtualNetworkGateway
}

module virtualNetworkGateway_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: virtualNetworkGateway.name
  }
}]

output virtualNetworkGatewayResourceGroup string = resourceGroup().name
output virtualNetworkGatewayName string = virtualNetworkGateway.name
output virtualNetworkGatewayResourceId string = virtualNetworkGateway.id
output activeActive bool = virtualNetworkGateway.properties.activeActive
