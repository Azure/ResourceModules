@description('Required. The connection name.')
param name string

@description('Required. The virtual hub name.')
param virtualHubName string

@description('Optional. Enable internet security.')
param enableInternetSecurity bool = true

@description('Required. Resource ID of the virtual network to link to')
param remoteVirtualNetworkId string

@description('Optional. Routing Configuration indicating the associated and propagated route tables for this connection.')
param routingConfiguration object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualHub 'Microsoft.Network/virtualHubs@2021-05-01' existing = {
  name: virtualHubName
}

resource hubVirtualNetworkConnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-05-01' = {
  name: name
  parent: virtualHub
  properties: {
    enableInternetSecurity: enableInternetSecurity
    remoteVirtualNetwork: {
      id: remoteVirtualNetworkId
    }
    routingConfiguration: !empty(routingConfiguration) ? routingConfiguration : null
  }
}

@description('The resource group the virtual hub connection was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual hub connection')
output resourceId string = hubVirtualNetworkConnection.id

@description('The name of the virtual hub connection')
output name string = hubVirtualNetworkConnection.name
