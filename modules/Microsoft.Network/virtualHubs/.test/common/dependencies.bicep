@description('Required. The name of the Virtual WAN to create.')
param virtualWANName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualWan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: virtualWANName
  location: location
}

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
        name: 'sxx-subnet-01'
        properties: {

          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

@description('The resource ID of the created Virtual WAN.')
output virtualWWANResourceId string = virtualWan.id

@description('The resource ID of the created Virtual Network')
output virtualNetworkResourceId string = virtualNetwork.id
