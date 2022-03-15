targetScope = 'subscription'
var rgname = 'scenario1-rg'

module rg '../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: rgname
  params: {
    name: 'scenario1-rg'
    // location: 'centralus'
  }
}

module vnet '../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario1-vnet'
  params: {
    addressPrefixes: [
      '172.16.0.0/16'
    ]
    name: 'scenario1-vnet'
    subnets: [
      {
        name: 'app-subnet'
        addressPrefix: '172.16.0.0/24'
        delegations: [
          {
            name: 'appSvcDel'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }
          }
        ]
      }
      {
        name: 'vm-subnet'
        addressPrefix: '172.16.1.0/24'
      }
    ]
  }
}
