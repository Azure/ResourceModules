@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

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

resource privateDNSZone_account 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.purview.azure.com'
  location: 'global'
}

resource privateDNSZone_portal 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.purviewstudio.azure.com'
  location: 'global'
}

resource privateDNSZone_blob 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.core.windows.net'
  location: 'global'
}

resource privateDNSZone_queue 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.queue.core.windows.net'
  location: 'global'
}

resource privateDNSZone_eh 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.servicebus.windows.net'
  location: 'global'
}
@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Private DNS Zone for Purview Account.')
output purviewAccountPrivateDNSResourceId string = privateDNSZone_account.id

@description('The resource ID of the created Private DNS Zone for Purview Portal.')
output purviewPortalPrivateDNSResourceId string = privateDNSZone_portal.id

@description('The resource ID of the created Private DNS Zone for Storage Account Blob.')
output storageBlobPrivateDNSResourceId string = privateDNSZone_blob.id

@description('The resource ID of the created Private DNS Zone for Storage Account Queue.')
output storageQueuePrivateDNSResourceId string = privateDNSZone_queue.id

@description('The resource ID of the created Private DNS Zone for Event Hub Namespace.')
output eventHubPrivateDNSResourceId string = privateDNSZone_eh.id
