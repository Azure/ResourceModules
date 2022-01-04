@description('Required. The name of the Private Link Hub.')
param name string

@description('Required. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

resource synapse_privateLinkHub 'Microsoft.Synapse/privateLinkHubs@2021-06-01' = {
  name: name
  location: location
  tags: tags
}

@description('The resource ID of the deployed Synapse Private Link Hub.')
output SynapsePrivateLinkHubResourceId string = synapse_privateLinkHub.id

@description('The name of the deployed Synapse Private Link Hub.')
output SynapsePrivateLinkHubName string = synapse_privateLinkHub.name
