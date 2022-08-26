@description('Optional. The location to deploy to')
param location string = resourceGroup().location

@description('Optional. The name of the Virtual Hub to create')
param virtualHubName string

@description('Optional. The name of the VPN Site to create')
param vpnSiteName string

@description('Required. The name of the virtual WAN to create')
param virtualWANName string

resource virtualWan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: virtualWANName
  location: location
}

resource virtualHub 'Microsoft.Network/virtualHubs@2022-01-01' = {
  name: virtualHubName
  location: location
  properties: {
    virtualWan: {
      id: virtualWan.id
    }
    addressPrefix: '10.1.0.0/16'
  }
}

resource vpnSite 'Microsoft.Network/vpnSites@2022-01-01' = {
  name: vpnSiteName
  location: location
  properties: {
    virtualWan: {
      id: virtualWan.id
    }
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    vpnSiteLinks: [
      {
        name: '${vpnSiteName}-vSite-link'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
    ]
  }
}

@description('The resource ID of the created Virtual Hub')
output virtualHubResourceId string = virtualHub.id

@description('The resource ID of the created VPN site')
output vpnSiteResourceId string = vpnSite.id
