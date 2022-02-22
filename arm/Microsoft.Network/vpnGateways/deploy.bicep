@description('Required. Name of the VPN gateway')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The connections to create in the VPN gateway')
param connections array = []

@description('Optional. List of all the NAT Rules to associate with the gateway.')
param natRules array = []

@description('Optional. The resource ID of a virtual Hub to connect to')
param virtualHubResourceId string = ''

@description('Optional. BGP settings details.')
param bgpSettings object = {}

@description('Optional. Enable BGP routes translation for NAT on this VpnGateway.')
param enableBgpRouteTranslationForNat bool

@description('Optional. Enable Routing Preference property for the Public IP Interface of the VpnGateway.')
param isRoutingPreferenceInternet bool

@description('Optional. The scale unit for this vpn gateway.')
param vpnGatewayScaleUnit int

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    bgpSettings: bgpSettings
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    isRoutingPreferenceInternet: isRoutingPreferenceInternet
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    virtualHub: !empty(virtualHubResourceId) ? {
      id: virtualHubResourceId
    } : null
    // connections: connections
    // natRules: natRules
  }
}

module vpnGateway_natRules 'natRules/deploy.bicep' = [for (natRule, index) in natRules: {
  name: '${deployment().name}-NATRule-${index}'
  params: {
    name: natRule.name
    vpnGatewayName: vpnGateway.name
    externalMappings: contains(natRule, 'externalMappings') ? natRule.externalMappings : []
    internalMappings: contains(natRule, 'internalMappings') ? natRule.internalMappings : []
    ipConfigurationId: contains(natRule, 'ipConfigurationId') ? natRule.ipConfigurationId : ''
    mode: contains(natRule, 'mode') ? natRule.mode : ''
    type: contains(natRule, 'type') ? natRule.type : ''
  }
}]

module vpnGateway_connections 'connections/deploy.bicep' = [for (connection, index) in connections: {
  name: '${deployment().name}-Connection-${index}'
  params: {
    name: connection.name
    vpnGatewayName: vpnGateway.name
    connectionBandwidth:
    dpdTimeoutSeconds:
    enableBgp:
    enableInternetSecurity:
    enableRateLimiting:
    remoteVpnSiteResourceId:
    routingConfiguration: {
    }
    routingWeight:
    sharedKey:
    useLocalAzureIpAddress:
    usePolicyBasedTrafficSelectors:
    vpnConnectionProtocolType:
  }
}]

@description('The name of the VPN gateway')
output name string = vpnGateway.name

@description('The resource ID of the VPN gateway')
output resourceId string = vpnGateway.id

@description('The name of the resource group the VPN gateway was deployed into')
output resourceGroupName string = resourceGroup().name
