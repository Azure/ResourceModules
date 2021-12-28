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
  privateDnsZoneResourceIds: (contains(privateEndpoint, 'privateDnsZoneResourceIds') ? privateEndpoint.privateDnsZoneResourceIds : [])
  customDnsConfigs: (contains(privateEndpoint, 'customDnsConfigs') ? (empty(privateEndpoint.customDnsConfigs) ? null : privateEndpoint.customDnsConfigs) : null)
}

resource privateEndpoint_resource 'Microsoft.Network/privateEndpoints@2021-05-01' = {
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

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01' = if (!empty(privateEndpoint_var.privateDnsZoneResourceIds)) {
  name: '${privateEndpoint_resource.name}/default'
  properties: {
    privateDnsZoneConfigs: [for privateDnsZoneResourceId in privateEndpoint_var.privateDnsZoneResourceIds: {
      name: last(split(privateDnsZoneResourceId, '/'))
      properties: {
        privateDnsZoneId: privateDnsZoneResourceId
      }
    }]
  }
}
