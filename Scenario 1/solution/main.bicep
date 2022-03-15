targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@allowed([
  'dev'
  'test'
  'prod'
])
param env string = 'dev'

param appName string = 'Scenario1App'

param location string = deployment().location

var rgName = 'rg${appName}${env}'

var namePattern = '${appName}-${env}'

var deployID = '${uniqueString(deployment().name, location)}'

// =========== //
// Deployments //
// =========== //

module rg '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: 'rg-${deployID}'
  scope: subscription()
  params: {
    name: rgName
    location: location
    tags: {
      environment: env
      app: appName
    }
  }
}

module virtualNetwork '../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: 'vnet-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'vnet'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    location: location
    subnets: [
      {
        name: 'snet-vm'
        addressPrefix: '10.0.0.0/25'
      }
      {
        name: 'snet-ase'
        addressPrefix: '10.0.1.0/24'
        ServiceEndpoints: [
          'Microsoft.EventHub'
          'Microsoft.Sql'
          'Microsoft.Storage'
        ]
      }
      {
        name: 'snet-pe'
        addressPrefix: '10.0.2.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
    diagnosticWorkspaceId: logAnalytics.outputs.resourceId
  }
  dependsOn: [
    rg
  ]
}

module appServiceEnvironment '../../arm/Microsoft.Web/hostingEnvironments/deploy.bicep' = {
  name: 'ase-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'ase-${namePattern}'
    location: location
    subnetResourceId: '${virtualNetwork.outputs.subnetResourceIds[1]}'
    diagnosticWorkspaceId: logAnalytics.outputs.resourceId
  }
}

module webApp '../../arm/Microsoft.Web/sites/deploy.bicep' = {
  name: 'app-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'web-${namePattern}'
    location: location
    kind: 'app'
    appServicePlanObject: {
      name: '${appName}${env}asp'
      serverOS: 'Windows'
      skuName: 'P1v2'
      skuCapacity: 2
      skuTier: 'PremiumV2'
      skuSize: 'P1v2'
      skuFamily: 'Pv2'
    }
    appInsightId: appInsights.outputs.resourceId
    siteConfig: {
      alwaysOn: true
    }
    functionsWorkerRuntime: 'dotnet'
    systemAssignedIdentity: true
    diagnosticWorkspaceId: logAnalytics.outputs.resourceId
  }
}

module vm '../../arm/Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: 'vm-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'vm-${namePattern}'
    location: location
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2016-Datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    encryptionAtHost: false
    adminUsername: 'localAdminUser'
    adminPassword: 'Azure1234!@#$' //Placeholder only! Team should deploy KV first, the add secret, and then Deploy VM/SQL
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '${virtualNetwork.outputs.subnetResourceIds[0]}'
          }
        ]
      }
    ]
  }
}

module keyVault '../../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: 'kv-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'kv-${namePattern}'
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: []
      ipRules: []
    }
    accessPolicies: [
      {
        objectId: webApp.outputs.systemAssignedPrincipalId
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'get'
            'list'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
    privateEndpoints: [
      {
        name: 'pe-kv-${namePattern}'
        subnetResourceId: '${virtualNetwork.outputs.subnetResourceIds[2]}'
        service: 'vault'
        privateDnsZoneResourceIds: [
          '${kvDNSZone.outputs.resourceId}'
        ]
      }
    ]
    diagnosticWorkspaceId: logAnalytics.outputs.resourceId
  }
}

module logAnalytics '../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: 'la-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'kv-${namePattern}'
    location: location
  }
  dependsOn: [
    rg
  ]
}

module appInsights '../../arm/Microsoft.Insights/components/deploy.bicep' = {
  name: 'ic-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'ic${appName}${env}'
    location: location
    workspaceResourceId: logAnalytics.outputs.resourceId
  }
}

module sql '../../arm/Microsoft.SQL/servers/deploy.bicep' = {
  name: 'sql-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'sql-serv-${namePattern}'
    location: location
    administratorLogin: 'localAdminUser'
    administratorLoginPassword: 'Azure1234!@#$' //Placeholder only! Team should deploy KV first, the add secret, and then Deploy VM/SQL
    databases: [
      {
        name: 'sql-db-${namePattern}'
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        tier: 'GeneralPurpose'
        skuName: 'GP_Gen5_2'
        maxSizeBytes: 34359738368
        licenseType: 'LicenseIncluded'
        workspaceId: logAnalytics.outputs.resourceId
      }
    ]
    firewallRules: [
      {
        name: 'AllowAllWindowsAzureIps'
        endIpAddress: '0.0.0.0'
        startIpAddress: '0.0.0.0'
      }
    ]
  }
}

module sqlPrivateEndpoint '../../arm/Microsoft.Network/privateEndpoints/deploy.bicep' = {
  name: 'sqlPrivateEndpoint-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'pe-sql-serv-${namePattern}'
    location: location
    targetSubnetResourceId: '${virtualNetwork.outputs.subnetResourceIds[2]}'
    serviceResourceId: sql.outputs.resourceId
    groupId: [
      'sqlServer'
    ]
    privateDnsZoneGroups: [
      {
        privateDNSResourceIds: [
          '${sqlDNSZone.outputs.resourceId}'
        ]
      }
    ]
  }
}

module sqlDNSZone '../../arm/Microsoft.Network/privateDnsZones/deploy.bicep' = {
  name: 'sqldnszone-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'privatelink.database.windows.net'
    location: 'global'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
      }
    ]
  }
}

module kvDNSZone '../../arm/Microsoft.Network/privateDnsZones/deploy.bicep' = {
  name: 'kvdnszone-${deployID}'
  scope: resourceGroup(rgName)
  params: {
    name: 'privatelink.vaultcore.azure.net'
    location: 'global'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
      }
    ]
  }
}


