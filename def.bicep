resource symbolicname 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    flushConnection: bool
    securityRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          access: 'string'
          description: 'string'
          destinationAddressPrefix: 'string'
          destinationAddressPrefixes: [
            'string'
          ]
          destinationApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {}
            }
          ]
          destinationPortRange: 'string'
          destinationPortRanges: [
            'string'
          ]
          direction: 'string'
          priority: int
          protocol: 'string'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'string'
          ]
          sourceApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {}
            }
          ]
          sourcePortRange: 'string'
          sourcePortRanges: [
            'string'
          ]
        }
        type: 'string'
      }
    ]
  }
}
