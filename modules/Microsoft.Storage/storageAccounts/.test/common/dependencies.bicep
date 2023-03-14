@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The name of the policy assignment.')
param policyAssignmentName string = 'Configure your Storage account public access to be disallowed'

@description('Optional. The policy definition Id to be assigned.')
param policyDefinitionId string = '/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab'

var addressPrefix = '10.0.0.0/16'

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
                name: 'defaultSubnet'
                properties: {
                    addressPrefix: addressPrefix
                    serviceEndpoints: [
                        {
                            service: 'Microsoft.Storage'
                        }
                    ]
                }
            }
        ]
    }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
    name: 'privatelink.blob.${environment().suffixes.storage}'
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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: policyAssignmentName
    scope: resourceGroup()
    properties: {
        policyDefinitionId: policyDefinitionId
    }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The resource ID of the Policy Assignment.')
output policyAssignmentId string = policyAssignment.id
