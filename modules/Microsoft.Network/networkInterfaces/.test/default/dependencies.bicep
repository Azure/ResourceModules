@description('Optional. The location to deploy to')
param location string = resourceGroup().location

@description('Required. The name of the managed identity to create')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

@description('Required. The name of the Load Balancer Backend Address Pool to create.')
param loadBalancerName string

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
                }
            }
        ]
    }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2022-01-01' = {
    name: applicationSecurityGroupName
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2022-01-01' = {
    name: loadBalancerName

    resource backendPoolName 'backendAddressPools@2022-01-01' = {
        name: 'default'
    }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id

@description('The resource ID of the created Load Balancer Backend Pool Name.')
output loadBalancerBackendPoolResourceId string = loadBalancer::backendPoolName.id
