@description('Required. Name of the VPN gateway')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The connections to create in the VPN gateway')
param connections array = []

@description('Optional. The resource ID of a virtual Hub to connect to')
param virtualHubResourceId string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-03-01' = {
  name: name
  location: location
  properties: {
    connections: connections
    virtualHub: !empty(virtualHubResourceId) ? {
      id: virtualHubResourceId
    } : null
  }
}
