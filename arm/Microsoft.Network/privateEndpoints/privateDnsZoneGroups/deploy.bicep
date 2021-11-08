

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = if (!empty(privateDNSId)) {
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateEndpoint.name
        properties: {
          privateDnsZoneId: privateDNSId
        }
      }
    ]
  }
}
