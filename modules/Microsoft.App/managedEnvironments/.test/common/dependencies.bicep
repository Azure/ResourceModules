@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the subnet.')
param subnetName string

@description('Required. Virtual network address prefix.')
param virutalNetworkAddressPrefix string

@description('Required. Subnet address prefix.')
param subnetAddressPrefix string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalticsWorkspaceName
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
  name: virutalNetworkname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virutalNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }

}

@description('The principal ID of the created Managed Environment.')
output logAnalticsWorkspaceName string = logAnalyticsWorkspace.name

@description('The principal ID of the created Managed Environment.')
output logAnaltyicsWorkspaceId string = logAnalyticsWorkspace.id

@description('Virtual network resource ID')
output virtualNetworkResourceId string = virtualNetwork.id

@description('Subnet resource ID')
output subnetResourceId string = '${virtualNetwork.id}/subnets/${subnetName}'
