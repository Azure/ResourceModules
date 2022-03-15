targetScope = 'subscription'

param webApp string = 'scenario1-webapp'
param webAppServerPlan string = 'scenario1-webappplan'

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
      }
      {
        name: 'vm-subnet'
        addressPrefix: '172.16.1.0/24'
      }
    ]
  }
}

module appServicePlan '../arm/Microsoft.Web/serverfarms/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario1-webappplan'
  params: {
    name: webAppServerPlan
    sku: {
      value: {
        name: 'P1v2'
        tier: 'PremiumV2'
        size: 'P1v2'
        family: 'Pv2'
        capacity: 1
      }
    }
  }
}

module appService '../arm/Microsoft.Web/sites/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario1-webapp'
  params: {
    kind: 'app'
    name: webApp
    appServicePlanId: appServicePlan.outputs.name
    sdsd: vnet.outputs.subnetNames
  }
}
