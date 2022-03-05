@description('Required. Name of the VPN Site.')
param name string

@description('Required. Resource ID of the virtual WAN to link to')
param virtualWanId string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. An array of IP address ranges that can be used by subnets of the virtual network. Must be provided if no bgpProperties or VPNSiteLinks are configured.')
param addressPrefixes array = []

@description('Optional.	BGP settings details. Must be provided if no addressPrefixes or VPNSiteLinks are configured. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead.')
param bgpProperties object = {}

@description('Optional. List of properties of the device.')
param deviceProperties object = {}

@description('Optional. The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead.')
param ipAddress string = ''

@description('Optional. IsSecuritySite flag')
param isSecuritySite bool = false

@description('Optional. The Office365 breakout policy.')
param o365Policy object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. List of all VPN site links.')
param vpnSiteLinks array = []

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vpnSite 'Microsoft.Network/vpnSites@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: !empty(addressPrefixes) ? {
      addressPrefixes: addressPrefixes
    } : null
    bgpProperties: !empty(bgpProperties) ? bgpProperties : null
    deviceProperties: !empty(deviceProperties) ? deviceProperties : null
    ipAddress: !empty(ipAddress) ? ipAddress : null
    isSecuritySite: isSecuritySite
    o365Policy: !empty(o365Policy) ? o365Policy : null
    virtualWan: {
      id: virtualWanId
    }
    vpnSiteLinks: !empty(vpnSiteLinks) ? vpnSiteLinks : null
  }
}

@description('The name of the VPN site')
output name string = vpnSite.name

@description('The resource ID of the VPN site')
output resourceId string = vpnSite.id

@description('The resource group the VPN site was deployed into')
output resourceGroupName string = resourceGroup().name
