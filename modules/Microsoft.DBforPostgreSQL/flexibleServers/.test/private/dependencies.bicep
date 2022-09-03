@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Private DNS Zone to create.')
param privateDNSZoneName string

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
                name: 'defaultSubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                    delegations: [
                        {
                            name: 'Microsoft.DBforPostgreSQL.flexibleServers'
                            properties: {
                                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
                            }
                        }
                    ]
                }
            }
        ]
    }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
    name: privateDNSZoneName
    location: 'global'

    resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
        name: '${split(privateDNSZoneName, '.')[0]}-vnet-link'
        location: 'global'
        properties: {
            virtualNetwork: {
                id: virtualNetwork.id
            }
            registrationEnabled: false
        }
    }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Virtual Network Subnet.')
output privateDNSResourceId string = privateDNSZone.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
