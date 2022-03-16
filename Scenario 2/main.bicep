targetScope = 'subscription'
var rgname = 'scenario2-rg'
var sqlname = 'scen2fkldjrgklj'

module scenario2rg '../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: rgname
  params: {
    name: 'scenario2-rg'
    // location: 'centralus'
  }
}

module vnet '../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario2-vnet'
  params: {
    addressPrefixes: [
      '172.16.0.0/16'
    ]
    name: 'scenario2-vnet'
    subnets: [
      {
        name: 'aks-subnet'
        addressPrefix: '172.16.0.0/24'
      }
      {
        name: 'vm-subnet'
        addressPrefix: '172.16.1.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
  }
  dependsOn: [
    scenario2rg
  ]
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
        privateDnsResourceIds: [
          sqlpdns.outputs.resourceId
        ]
        privateEndpointName: 'sql-pec-deploy'
      }
    ]
    name: 'sqlpec'
    serviceResourceId: sql.outputs.resourceId
    targetSubnetResourceId: vnet.outputs.subnetResourceIds[1]
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

module aks '../arm/Microsoft.ContainerService/managedClusters/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'aks-deploy'
  params: {
    name: 'group3aks'
    systemAssignedIdentity: true
    primaryAgentPoolProfile: [
      {
        name: 'akspoolname'
        vmSize: 'standard_d4ads_v5'
        osDiskSizeGB: 128
        count: 2
        osType: 'Linux'
        maxCount: 5
        minCount: 1
        enableAutoScaling: true
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        nodeLabels: {}
        type: 'VirtualMachineScaleSets'
        maxPods: 30
        storageProfile: 'ManagedDisks'
        mode: 'System'
        vnetSubnetID: vnet.outputs.subnetResourceIds[0]
      }
    ]
  }
}

module containerRegistry '../arm/Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario2-cr'
  params: {
    name: 'scenario2cr'
    acrAdminUserEnabled: true
    acrSku: 'Basic'
  }
}
