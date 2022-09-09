@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'sxx-subnet-pe-01'
        properties: {

          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azure-automation.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

@description('The resource ID of the created virtual network subnet')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Virtual Network Subnet.')
output privateDNSResourceId string = privateDNSZone.id
