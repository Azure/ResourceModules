@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Public IP to create.')
param publicIPName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: virtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.0.0/24'
            ]
        }
        subnets: [
            {
                name: 'AzureFirewallSubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                }
            }
        ]
    }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
    name: publicIPName
    location: location
    sku: {
        name: 'Standard'
        tier: 'Regional'
    }
    properties: {
        publicIPAllocationMethod: 'Static'
    }
    zones: [
        '1'
        '2'
        '3'
    ]
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created Public IP.')
output publicIPResourceId string = publicIP.id
