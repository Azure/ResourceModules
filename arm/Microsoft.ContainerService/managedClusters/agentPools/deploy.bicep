@description('Required. Name of the managed cluster')
@minLength(1)
param managedClusterName string

@description('Required. Name of the agent pool')
param name string

@description('Required. Properties for the container service agent pool profile.')
param agentPoolProperties object

resource agentPool 'Microsoft.ContainerService/managedClusters/agentPools@2021-05-01' = {
  name: '${managedClusterName}/${name}'
  properties: agentPoolProperties
}

@description('The name of the Resource Group the agent pool was created in.')
output agentPoolResourceGroup string = resourceGroup().name
@description('The name of the agent pool')
output agentPoolName string = agentPool.name
@description('The ResourceId of the agent pool')
output agentPoolId string = agentPool.id
