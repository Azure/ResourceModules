targetScope = 'subscription'
var rgname = 'scenario1-rg'
var sqlname = 'seklnfkldjrgklj'

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
module sql '../arm/Microsoft.Sql/servers/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'sql-deploy'
  params: {
    name: sqlname
    databases: [
      {
        name: 'mydb'
        skuName: 'GP_Gen5_2'
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        tier: 'GeneralPurpose'
        maxSizeBytes: 1073741824
      }
    ]
    administratorLogin: 'team3'
    administratorLoginPassword: 'P@ssw0rd234o23409'
  }
}

module sqlpec '../arm/Microsoft.Network/privateEndpoints/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'sql-pec-deploy'
  params: {
    groupId: [
      'sqlServer'
    ]
    privateDnsZoneGroups: [
      {
        privateDnsResourceId: sqlpdns.outputs.resourceId
        privateEndpointName: 'sql-pec-deploy'
      }
    ]
    name: 'sqlpec'
    serviceResourceId: sql.outputs.resourceId
    targetSubnetResourceId: vnet.outputs.subnetResourceIds[1].id
  }
}

module sqlpdns '../arm/Microsoft.Network/privateDnsZones/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'sqlpdns-deploy'
  params: {
    name: 'privatelink.database.windows.net'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnet.outputs.resourceId
      }
    ]
  }
}
