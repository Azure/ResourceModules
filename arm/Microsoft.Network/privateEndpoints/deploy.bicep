@description('Required. Name of the private endpoint resource to create.')
param privateEndpointName string

@description('Required. Resource Id of the subnet where the endpoint needs to be created.')
param targetSubnetId string

@description('Required. Resource Id of the resource that needs to be connected to the network.')
param serviceResourceId string

@description('Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to.')
param groupId array

@description('Optional. Resource id of the private DNS zone.')
param privateDNSId string = ''

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_pid.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: privateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: groupId
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: targetSubnetId
    }
    customDnsConfigs: []
  }

  resource privateDnsZoneGroup 'privateDnsZoneGroups@2021-02-01' = if (!empty(privateDNSId)) {
    name: 'default'
    properties: {
      privateDnsZoneConfigs: [
        {
          name: privateEndpointName
          properties: {
            privateDnsZoneId: privateDNSId
          }
        }
      ]
    }
  }
}


output privateEndpointResourceGroup string = resourceGroup().name
output privateEndpointResourceId string = privateEndpoint.id
output privateEndpointName string = privateEndpointName
