@description('Required. Specifies the Virtual Network Gateway name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the name of the Public IP used by the Virtual Network Gateway. If it\'s not provided, a \'-pip\' suffix will be appended to the gateway\'s name.')
param gatewayPipName string = '${name}-pip1'

@description('Optional. Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it\'s not provided, a \'-pip\' suffix will be appended to the gateway\'s name.')
param activeGatewayPipName string = '${name}-pip2'

@description('Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIPPrefixResourceId string = ''

@description('Optional. Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones.')
param publicIpZones array = []

@description('Optional. DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.')
param domainNameLabel array = []

@description('Required. Specifies the gateway type. E.g. VPN, ExpressRoute.')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string

@description('Optional. The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN.')
@allowed([
  'Generation1'
  'Generation2'
  'None'
])
param vpnGatewayGeneration string = 'None'

@description('Required. The SKU of the Gateway.')
@allowed([
  'Basic'
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw4'
  'VpnGw5'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'VpnGw4AZ'
  'VpnGw5AZ'
  'Standard'
  'HighPerformance'
  'UltraPerformance'
  'ErGw1AZ'
  'ErGw2AZ'
  'ErGw3AZ'
])
param skuName string

@description('Optional. Specifies the VPN type.')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param vpnType string = 'RouteBased'

@description('Required. Virtual Network resource ID.')
param vNetResourceId string

@description('Optional. Value to specify if the Gateway should be deployed in active-active or active-passive configuration.')
param activeActive bool = true

@description('Optional. Value to specify if BGP is enabled or not.')
param enableBgp bool = true

@description('Optional. ASN value.')
param asn int = 65815

@description('Optional. The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network.')
param vpnClientAddressPoolPrefix string = ''

@description('Optional. Configures this gateway to accept traffic from remote Virtual WAN networks.')
param allowVirtualWanTraffic bool = false

@description('Optional. Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN.')
param allowRemoteVnetTraffic bool = false

@description('Optional. disableIPSecReplayProtection flag. Used for VPN Gateways.')
param disableIPSecReplayProtection bool = false

@description('Optional. Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription.')
param enableDnsForwarding bool = false

@description('Optional. Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering.')
param enablePrivateIpAddress bool = false

@description('Optional. The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting.')
param gatewayDefaultSiteLocalNetworkGatewayId string = ''

@description('Optional. NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only.')
param natRules array = []

@description('Optional. EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided.')
param clientRootCertData string = ''

@description('Optional. Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet.')
param clientRevokedCertThumbprint string = ''

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
])
param publicIpdiagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'GatewayDiagnosticLog'
  'TunnelDiagnosticLog'
  'RouteDiagnosticLog'
  'IKEDiagnosticLog'
  'P2SDiagnosticLog'
])
param virtualNetworkGatewaydiagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided.')
param vpnClientAadConfiguration object = {}

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@description('Optional. The name of the public IP diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param publicIpDiagnosticSettingsName string = ''

// ================//
// Variables       //
// ================//

// Diagnostic Variables
var virtualNetworkGatewayDiagnosticsLogsSpecified = [for category in filter(virtualNetworkGatewaydiagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var virtualNetworkGatewayDiagnosticsLogs = contains(virtualNetworkGatewaydiagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : virtualNetworkGatewayDiagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

// Other Variables
var zoneRedundantSkus = [
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'VpnGw4AZ'
  'VpnGw5AZ'
  'ErGw1AZ'
  'ErGw2AZ'
  'ErGw3AZ'
]
var gatewayPipSku = contains(zoneRedundantSkus, skuName) ? 'Standard' : 'Basic'
var gatewayPipAllocationMethod = contains(zoneRedundantSkus, skuName) ? 'Static' : 'Dynamic'

var isActiveActiveValid = gatewayType != 'ExpressRoute' ? activeActive : false
var virtualGatewayPipNameVar = isActiveActiveValid ? [
  gatewayPipName
  activeGatewayPipName
] : [
  gatewayPipName
]

var vpnTypeVar = gatewayType != 'ExpressRoute' ? vpnType : 'PolicyBased'

var isBgpValid = gatewayType != 'ExpressRoute' ? enableBgp : false
var bgpSettings = {
  asn: asn
}

// Potential configurations (active-active vs active-passive)
var ipConfiguration = isActiveActiveValid ? [
  {
    properties: {
      privateIPAllocationMethod: 'Dynamic'
      subnet: {
        id: '${vNetResourceId}/subnets/GatewaySubnet'
      }
      publicIPAddress: {
        id: az.resourceId('Microsoft.Network/publicIPAddresses', gatewayPipName)
      }
    }
    name: 'vNetGatewayConfig1'
  }
  {
    properties: {
      privateIPAllocationMethod: 'Dynamic'
      subnet: {
        id: '${vNetResourceId}/subnets/GatewaySubnet'
      }
      publicIPAddress: {
        id: isActiveActiveValid ? az.resourceId('Microsoft.Network/publicIPAddresses', activeGatewayPipName) : az.resourceId('Microsoft.Network/publicIPAddresses', gatewayPipName)
      }
    }
    name: 'vNetGatewayConfig2'
  }
] : [
  {
    properties: {
      privateIPAllocationMethod: 'Dynamic'
      subnet: {
        id: '${vNetResourceId}/subnets/GatewaySubnet'
      }
      publicIPAddress: {
        id: az.resourceId('Microsoft.Network/publicIPAddresses', gatewayPipName)
      }
    }
    name: 'vNetGatewayConfig1'
  }
]

var vpnClientConfiguration = !empty(clientRootCertData) ? {
  vpnClientAddressPool: {
    addressPrefixes: [
      vpnClientAddressPoolPrefix
    ]
  }
  vpnClientRootCertificates: [
    {
      name: 'RootCert1'
      properties: {
        PublicCertData: clientRootCertData
      }
    }
  ]
  vpnClientRevokedCertificates: !empty(clientRevokedCertThumbprint) ? [
    {
      name: 'RevokedCert1'
      properties: {
        Thumbprint: clientRevokedCertThumbprint
      }
    }
  ] : null
} : !empty(vpnClientAadConfiguration) ? {
  vpnClientAddressPool: {
    addressPrefixes: [
      vpnClientAddressPoolPrefix
    ]
  }
  aadTenant: vpnClientAadConfiguration.aadTenant
  aadAudience: vpnClientAadConfiguration.aadAudience
  aadIssuer: vpnClientAadConfiguration.aadIssuer
  vpnAuthenticationTypes: vpnClientAadConfiguration.vpnAuthenticationTypes
  vpnClientProtocols: vpnClientAadConfiguration.vpnClientProtocols
} : null

var enableReferencedModulesTelemetry = false

// ================//
// Deployments     //
// ================//
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

// Public IPs
@batchSize(1)
module publicIPAddress '../public-ip-addresses/main.bicep' = [for (virtualGatewayPublicIpName, index) in virtualGatewayPipNameVar: {
  name: virtualGatewayPublicIpName
  params: {
    name: virtualGatewayPublicIpName
    diagnosticLogCategoriesToEnable: publicIpdiagnosticLogCategoriesToEnable
    diagnosticMetricsToEnable: diagnosticMetricsToEnable
    diagnosticSettingsName: !empty(publicIpDiagnosticSettingsName) ? publicIpDiagnosticSettingsName : '${virtualGatewayPublicIpName}-diagnosticSettings'
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    domainNameLabel: length(virtualGatewayPipNameVar) == length(domainNameLabel) ? domainNameLabel[index] : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    lock: lock
    publicIPAllocationMethod: gatewayPipAllocationMethod
    publicIPPrefixResourceId: !empty(publicIPPrefixResourceId) ? publicIPPrefixResourceId : ''
    tags: tags
    skuName: gatewayPipSku
    zones: contains(zoneRedundantSkus, skuName) ? publicIpZones : []
  }
}]

// VNET Gateway
// ============
resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    ipConfigurations: ipConfiguration
    activeActive: isActiveActiveValid
    allowRemoteVnetTraffic: allowRemoteVnetTraffic
    allowVirtualWanTraffic: allowVirtualWanTraffic
    enableBgp: isBgpValid
    bgpSettings: isBgpValid ? bgpSettings : null
    disableIPSecReplayProtection: disableIPSecReplayProtection
    enableDnsForwarding: gatewayType == 'ExpressRoute' ? enableDnsForwarding : null
    enablePrivateIpAddress: enablePrivateIpAddress
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    gatewayType: gatewayType
    gatewayDefaultSite: !empty(gatewayDefaultSiteLocalNetworkGatewayId) ? {
      id: gatewayDefaultSiteLocalNetworkGatewayId
    } : null
    sku: {
      name: skuName
      tier: skuName
    }
    vpnType: vpnTypeVar
    vpnClientConfiguration: !empty(vpnClientAddressPoolPrefix) ? vpnClientConfiguration : null
    vpnGatewayGeneration: gatewayType == 'Vpn' ? vpnGatewayGeneration : 'None'
  }
  dependsOn: [
    publicIPAddress
  ]
}

module virtualNetworkGateway_natRules 'nat-rules/main.bicep' = [for (natRule, index) in natRules: {
  name: '${deployment().name}-NATRule-${index}'
  params: {
    name: natRule.name
    virtualNetworkGatewayName: virtualNetworkGateway.name
    externalMappings: contains(natRule, 'externalMappings') ? natRule.externalMappings : []
    internalMappings: contains(natRule, 'internalMappings') ? natRule.internalMappings : []
    ipConfigurationId: contains(natRule, 'ipConfigurationId') ? natRule.ipConfigurationId : ''
    mode: contains(natRule, 'mode') ? natRule.mode : ''
    type: contains(natRule, 'type') ? natRule.type : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource virtualNetworkGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${virtualNetworkGateway.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualNetworkGateway
}

resource virtualNetworkGateway_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: virtualNetworkGatewayDiagnosticsLogs
  }
  scope: virtualNetworkGateway
}

module virtualNetworkGateway_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VNetGateway-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: virtualNetworkGateway.id
  }
}]

// ================//
// Outputs         //
// ================//
@description('The resource group the virtual network gateway was deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual network gateway.')
output name string = virtualNetworkGateway.name

@description('The resource ID of the virtual network gateway.')
output resourceId string = virtualNetworkGateway.id

@description('Shows if the virtual network gateway is configured in active-active mode.')
output activeActive bool = virtualNetworkGateway.properties.activeActive

@description('The location the resource was deployed into.')
output location string = virtualNetworkGateway.location
