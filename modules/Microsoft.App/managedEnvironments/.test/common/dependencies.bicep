@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

var managedEnvironmentsubnet = 'environmentSubnet'

var addressPrefix = '10.0.0.0/16'

var subnetAddressPrefix = '10.0.0.0/23'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: managedEnvironmentsubnet
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }

}

@description('The principal ID of the created Managed Environment.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name

@description('Virtual network resource ID')
output virtualNetworkResourceId string = virtualNetwork.id

@description('Subnet resource ID')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id
