@description('Required. The name of the agent pool')
param name string

@description('Required. Properties for the container service agent pool profile.')
param properties object

resource agentPool 'Microsoft.ContainerService/managedClusters/agentPools@2021-05-01' = {
  name: name
  properties: properties
}

@description('The name of the Resource Group the agent pool was created in.')
output agentPoolResourceGroup string = resourceGroup().name
@description('The name of the agent pool')
output agentPoolName string = agentPool.name
@description('The ResourceId of the agent pool')
output agentPoolId string = agentPool.id
