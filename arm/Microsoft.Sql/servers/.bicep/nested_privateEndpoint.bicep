@description('The resource ID of the service to link to')
param privateEndpointResourceId string

@description('Required. The location of the proviate endpoint')
param privateEndpointVnetLocation string

@description('Optional. Tags to add to the private endpoint.')
param tags object = {}

@description('Optional. The name of the private endpoint')
param name string = '${last(split(privateEndpointResourceId, '/'))}-${service}'

@description('Required. The service/groupId his private endpoint should connect to')
param service string = 'sqlServer'

@description('Required. Subnet in a virtual network resource.')
param subnetResourceId string

@description('Optional. Custom DNS configurations.')
param customDnsConfigs array = []

@description('Optional. A collection of private DNS zone configurations of the private dns zone group.')
param privateDnsZoneResourceIds array = []

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: name
  location: privateEndpointVnetLocation
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: privateEndpointResourceId
          groupIds: [
            service
          ]
        }
      }
    ]
    subnet: {
      id: subnetResourceId
    }
    customDnsConfigs: customDnsConfigs
  }

  resource privateDnsZoneGroups 'privateDnsZoneGroups@2021-02-01' = {
    name: 'default'
    properties: {
      privateDnsZoneConfigs: [for privateDnsZoneResourceId in privateDnsZoneResourceIds: {
        name: last(split(privateDnsZoneResourceId, '/'))
        properties: {
          privateDnsZoneId: privateDnsZoneResourceId
        }
      }]
    }
  }
}
