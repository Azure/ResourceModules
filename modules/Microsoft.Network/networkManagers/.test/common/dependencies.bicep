@description('Required. The name of the Hub Virtual Network to create.')
param virtualNetworkHubName string

@description('Required. The name of the Spoke 1 Virtual Network to create.')
param virtualNetworkSpoke1Name string

@description('Required. The name of the Spoke 2 Virtual Network to create.')
param virtualNetworkSpoke2Name string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualNetworkHub 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkHubName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource virtualNetworkSpoke1 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkSpoke1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/12'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
    ]
  }
}

resource virtualNetworkSpoke2 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkSpoke2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '192.168.0.0/24'
        }
      }
    ]
  }
}

@description('The resource ID of the created Hub Virtual Network.')
output virtualNetworkHubId string = virtualNetworkHub.id

@description('The resource ID of the created Spoke 1 Virtual Network.')
output virtualNetworkSpoke1Id string = virtualNetworkSpoke1.id

@description('The resource ID of the created Spoke 2 Virtual Network.')
output virtualNetworkSpoke2Id string = virtualNetworkSpoke2.id
