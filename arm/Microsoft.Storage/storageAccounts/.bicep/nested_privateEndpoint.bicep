param privateEndpointResourceId string
param privateEndpointVnetLocation string
param privateEndpoint object
param tags object

var privateEndpointResourceName = last(split(privateEndpointResourceId, '/'))
var privateEndpoint_var = {
  name: (contains(privateEndpoint, 'name') ? (empty(privateEndpoint.name) ? '${privateEndpointResourceName}-${privateEndpoint.service}' : privateEndpoint.name) : '${privateEndpointResourceName}-${privateEndpoint.service}')
  subnetResourceId: privateEndpoint.subnetResourceId
  service: [
    privateEndpoint.service
  ]
  privateDnsZoneResourceIds: (contains(privateEndpoint, 'privateDnsZoneResourceIds') ? ((empty(privateEndpoint.privateDnsZoneResourceIds) ? [] : privateEndpoint.privateDnsZoneResourceIds)) : [])
  customDnsConfigs: (contains(privateEndpoint, 'customDnsConfigs') ? (empty(privateEndpoint.customDnsConfigs) ? json('null') : privateEndpoint.customDnsConfigs) : json('null'))
}

resource privateEndpoint_name 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpoint_var.name
  location: privateEndpointVnetLocation
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoint_var.name
        properties: {
          privateLinkServiceId: privateEndpointResourceId
          groupIds: privateEndpoint_var.service
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpoint_var.subnetResourceId
    }
    customDnsConfigs: privateEndpoint_var.customDnsConfigs
  }
}

resource privateEndpoint_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpoint_var.name}/default'
  properties: {
    privateDnsZoneConfigs: [for privateDnsZoneResourceId in privateEndpoint_var.privateDnsZoneResourceIds: {
      name: last(split(privateDnsZoneResourceId, '/'))
      properties: {
        privateDnsZoneId: privateDnsZoneResourceId
      }
    }]
  }
  dependsOn: [
    privateEndpoint_name
  ]
}
