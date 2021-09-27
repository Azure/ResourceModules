param privateEndpointResourceId string
param privateEndpointVnetLocation string
param privateEndpointDef object
param tags object

var privateEndpointResourceName = last(split(privateEndpointResourceId, '/'))
var privateEndpoint_var = {
  name: (contains(privateEndpointDef, 'name') ? (empty(privateEndpointDef.name) ? '${privateEndpointResourceName}-${privateEndpointDef.service}' : privateEndpointDef.name) : '${privateEndpointResourceName}-${privateEndpointDef.service}')
  subnetResourceId: privateEndpointDef.subnetResourceId
  service: [
    privateEndpointDef.service
  ]
  privateDnsZoneResourceIds: (contains(privateEndpointDef, 'privateDnsZoneResourceIds') ? (empty(privateEndpointDef.privateDnsZoneResourceIds) ? [] : privateEndpointDef.privateDnsZoneResourceIds) : [])
  customDnsConfigs: (contains(privateEndpointDef, 'customDnsConfigs') ? (empty(privateEndpointDef.customDnsConfigs) ? json('null') : privateEndpointDef.customDnsConfigs) : json('null'))
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2020-05-01' = {
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

resource privateEndpoint_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = if (!empty(privateEndpoint_var.privateDnsZoneResourceIds)) {
  name: '${privateEndpoint_var.name}/default'
  properties: {
    privateDnsZoneConfigs: [for j in range(0, length(privateEndpoint_var.privateDnsZoneResourceIds)): {
      name: last(split(privateEndpoint_var.privateDnsZoneResourceIds[j], '/'))
      properties: {
        privateDnsZoneId: privateEndpoint_var.privateDnsZoneResourceIds[j]
      }
    }]
  }
  dependsOn: [
    privateEndpoint
  ]
}
