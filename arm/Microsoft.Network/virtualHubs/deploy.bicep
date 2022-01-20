@description('Required. The virtual hub name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. Address-prefix for this VirtualHub.')
param addressPrefix string

@description('Optional. Flag to control transit for VirtualRouter hub.')
param allowBranchToBranchTraffic bool = true

@description('Optional. Resource ID of the Azure Firewall to link to')
param azureFirewallId string = ''

@description('Optional. Resource ID of the Express Route Gateway to link to')
param expressRouteGatewayId string = ''

@description('Optional. Resource ID of the Point-to-Site VPN Gateway to link to')
param p2SVpnGatewayId string = ''

@description('Optional. The preferred routing gateway types')
@allowed([
  'ExpressRoute'
  'None'
  'VpnGateway'
  ''
])
param preferredRoutingGateway string = ''

@description('Optional. VirtualHub route tables')
param routeTableRoutes array = []

@description('Optional. ID of the Security Partner Provider to link to')
param securityPartnerProviderId string = ''

@description('Optional. The Security Provider name.')
param securityProviderName string = ''

@description('Optional. The sku of this VirtualHub.')
param sku string = 'Standard'

@description('Optional. List of all virtual hub route table v2s associated with this VirtualHub.')
param virtualHubRouteTableV2s array = []

@description('Optional. VirtualRouter ASN.')
param virtualRouterAsn int = -1

@description('Optional. VirtualRouter IPs.')
param virtualRouterIps array = []

@description('Required. Resource ID of the virtual WAN to link to')
param virtualWanId string

@description('Optional. Resource ID of the VPN Gateway to link to')
param vpnGatewayId string = ''

@description('Optional. Route tables to create for the virtual hub.')
param routeTables array = []

@description('Optional. Virtual network connections to create for the virtual hub.')
param virtualNetworkConnections array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualHub 'Microsoft.Network/virtualHubs@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressPrefix: addressPrefix
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    azureFirewall: !empty(azureFirewallId) ? {
      id: azureFirewallId
    } : null
    expressRouteGateway: !empty(expressRouteGatewayId) ? {
      id: expressRouteGatewayId
    } : null
    p2SVpnGateway: !empty(p2SVpnGatewayId) ? {
      id: p2SVpnGatewayId
    } : null
    preferredRoutingGateway: !empty(preferredRoutingGateway) ? any(preferredRoutingGateway) : null
    routeTable: !empty(routeTableRoutes) ? {
      routes: routeTableRoutes
    } : null
    securityPartnerProvider: !empty(securityPartnerProviderId) ? {
      id: securityPartnerProviderId
    } : null
    securityProviderName: securityProviderName
    sku: sku
    virtualHubRouteTableV2s: virtualHubRouteTableV2s
    virtualRouterAsn: !(virtualRouterAsn == -1) ? virtualRouterAsn : null
    virtualRouterIps: !empty(virtualRouterIps) ? virtualRouterIps : null
    virtualWan: !empty(virtualWanId) ? {
      id: virtualWanId
    } : null
    vpnGateway: !empty(vpnGatewayId) ? {
      id: vpnGatewayId
    } : null
  }
}

module virtualHub_routeTables 'hubRouteTables/deploy.bicep' = [for (routeTable, index) in routeTables: {
  name: '${uniqueString(deployment().name, location)}-routeTable-${index}'
  params: {
    virtualHubName: virtualHub.name
    name: routeTable.name
    labels: contains(routeTable, 'labels') ? routeTable.labels : []
    routes: contains(routeTable, 'routes') ? routeTable.routes : []
  }
}]

module virtualHub_hubVirtualNetworkConnections 'hubVirtualNetworkConnections/deploy.bicep' = [for (virtualNetworkConnection, index) in virtualNetworkConnections: {
  name: '${uniqueString(deployment().name, location)}-connection-${index}'
  params: {
    virtualHubName: virtualHub.name
    name: virtualNetworkConnection.name
    enableInternetSecurity: contains(virtualNetworkConnection, 'enableInternetSecurity') ? virtualNetworkConnection.enableInternetSecurity : true
    remoteVirtualNetworkId: virtualNetworkConnection.remoteVirtualNetworkId
    routingConfiguration: contains(virtualNetworkConnection, 'routingConfiguration') ? virtualNetworkConnection.routingConfiguration : {}
  }
  dependsOn: [
    virtualHub_routeTables
  ]
}]

@description('The resource group the virtual hub was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual hub')
output resourceId string = virtualHub.id

@description('The name of the virtual hub')
output name string = virtualHub.name
