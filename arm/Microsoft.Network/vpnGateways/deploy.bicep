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
    connections: connections
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    isRoutingPreferenceInternet: isRoutingPreferenceInternet
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    natRules: natRules
    virtualHub: !empty(virtualHubResourceId) ? {
      id: virtualHubResourceId
    } : null
  }
}
