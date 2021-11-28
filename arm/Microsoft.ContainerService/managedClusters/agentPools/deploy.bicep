@description('Required. Name of the managed cluster')
@minLength(1)
param managedClusterName string

@description('Required. Name of the agent pool')
param name string

@description('Required. Properties for the container service agent pool profile.')
param agentPoolProperties object

resource managedCluster 'Microsoft.ContainerService/managedClusters@2021-08-01' existing = {
  name: managedClusterName
}

resource agentPool 'Microsoft.ContainerService/managedClusters/agentPools@2021-05-01' = {
  name: name
  parent: managedCluster
  properties: agentPoolProperties
}

@description('The name of the agent pool')
output agentPoolName string = agentPool.name

@description('The resource ID of the agent pool')
output agentPoolResourceId string = agentPool.id

@description('The resource group the agent pool was deployed into.')
output agentPoolResourceGroup string = resourceGroup().name
