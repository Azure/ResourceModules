@description('Required. The name of the VPN connection.')
param name string

@description('Required. The name of the VPN gateway this VPN connection is associated with.')
param vpnGatewayName string

@description('Optional. ')
param ipsecPolicies array = []

param trafficSelectorPolicies array = []

param vpnLinkConnections array = []

param routingConfiguration object

param usePolicyBasedTrafficSelectors bool

param useLocalAzureIpAddress bool

param enableRateLimiting bool

param enableInternetSecurity bool

param enableBgp bool

param routingWeight int

param dpdTimeoutSeconds int

param connectionBandwidth int

param vpnConnectionProtocolType string

param sharedKey string

param remoteVpnSiteResourceId string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-03-01' existing = {
  name: vpnGatewayName
}

resource vpnConnection 'Microsoft.Network/vpnGateways/vpnConnections@2021-05-01' = {
  name: name
  parent: vpnGateway
  properties: {
    connectionBandwidth: connectionBandwidth
    dpdTimeoutSeconds: dpdTimeoutSeconds
    enableBgp: enableBgp
    enableInternetSecurity: enableInternetSecurity
    enableRateLimiting: enableRateLimiting
    ipsecPolicies: ipsecPolicies
    remoteVpnSite: !empty(remoteVpnSiteResourceId) ? {
      id: remoteVpnSiteResourceId
    } : null
    routingConfiguration: routingConfiguration
    routingWeight: routingWeight
    sharedKey: sharedKey
    trafficSelectorPolicies: trafficSelectorPolicies
    useLocalAzureIpAddress: useLocalAzureIpAddress
    usePolicyBasedTrafficSelectors: usePolicyBasedTrafficSelectors
    vpnConnectionProtocolType: vpnConnectionProtocolType
    vpnLinkConnections: vpnLinkConnections
  }
}

@description('The name of the VPN connection')
output name string = vpnConnection.name

@description('The resource ID of the VPN connection')
output resourceId string = vpnConnection.id

@description('The name of the resource group the VPN connection was deployed into')
output resourceGroupName string = resourceGroup().name
