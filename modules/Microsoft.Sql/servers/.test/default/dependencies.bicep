@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
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

@description('The principal ID of the created managed identity')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created managed identity')
output managedIdentitResourceId string = managedIdentity.id

@description('The resource ID of the created virtual network subnet')
output privateEndpointSubnetResourceId string = vnet.properties.subnets[0].id
