@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the DNS Resolver to create.')
param dnsResolverName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'
var pdnsinSnetAddressPrefix = '10.10.100.0/25'
var pdnsoutSnetAddressPrefix = '10.10.100.128/25'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'pdnsin'
        properties: {
          addressPrefix: pdnsinSnetAddressPrefix
          delegations: [
            {
              name: 'dnsdel'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
      {
        name: 'pdnsout'
        properties: {
          addressPrefix: pdnsoutSnetAddressPrefix
          delegations: [
            {
              name: 'dnsdel'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
    ]
  }
}

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: dnsResolverName
  location: location
  properties: {
    virtualNetwork: {
      id: virtualNetwork.id
    }

  }
}

resource outboundEndpoints 'Microsoft.Network/dnsResolvers/outboundEndpoints@2022-07-01' = {
  name: 'pdnsout'
  location: location
  parent: dnsResolver
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[1].id
    }
  }
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkId string = virtualNetwork.id

@description('The resource ID of the created inbound endpoint Virtual Network Subnet.')
output subnetResourceId_dnsIn string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created outbound endpoint Virtual Network Subnet.')
output subnetResourceId_dnsOut string = virtualNetwork.properties.subnets[1].id

@description('The resource ID of the created DNS Resolver.')
output dnsResolverOutboundEndpointsId string = outboundEndpoints.id
