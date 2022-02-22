@description('Required. The name of the VPN connection.')
param name string

@description('Required. The name of the VPN gateway this VPN connection is associated with.')
param vpnGatewayName string

@description('Optional. The IPSec Policies to be considered by this connection.')
param ipsecPolicies array = []

@description('Optional. The Traffic Selector Policies to be considered by this connection.')
param trafficSelectorPolicies array = []

@description('Optional. List of all vpn site link connections to the gateway.')
param vpnLinkConnections array = []

@description('Optional. Routing Configuration indicating the associated and propagated route tables for this connection.')
param routingConfiguration object

@description('Optional. Enable policy-based traffic selectors.')
param usePolicyBasedTrafficSelectors bool = false

@description('Optional. Use local azure ip to initiate connection.')
param useLocalAzureIpAddress bool

@description('Optional. EnableBgp flag.')
param enableRateLimiting bool

@description('Optional. Enable internet security.')
param enableInternetSecurity bool

@description('Optional. Enable internet security.')
param enableBgp bool

@description('Optional. Routing weight for vpn connection.')
param routingWeight int

@description('Optional. DPD timeout in seconds for vpn connection.')
param dpdTimeoutSeconds int

@description('Optional. Expected bandwidth in MBPS.')
param connectionBandwidth int

@description('Optional. Gateway connection protocol.')
@allowed([
  'IKEv1'
  'IKEv2'
])
param vpnConnectionProtocolType string

@description('Optional. SharedKey for the vpn connection.')
param sharedKey string

@description('Optional. Reference to a VPN site to link to')
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
