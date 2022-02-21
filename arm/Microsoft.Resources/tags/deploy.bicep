targetScope = 'subscription'

@description('Optional. Tags for the resource group. If not provided, removes existing tags')
param tags object = {}

@description('Optional. Instead of overwriting the existing tags, combine them with the new tags')
param onlyUpdate bool = false

@description('Optional. Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.')
param resourceGroupName string = ''

@description('Optional. Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.')
param subscriptionId string = ''

module tags_sub 'subscriptions/deploy.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${deployment().name}-Tags-Sub'
  scope: subscription(subscriptionId)
  params: {
    onlyUpdate: onlyUpdate
    tags: tags
  }
}

module tags_rg 'resourceGroups/deploy.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${deployment().name}-Tags-RG'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    onlyUpdate: onlyUpdate
    tags: tags
  }
}

@description('The name of the tags resource')
output name string = (!empty(resourceGroupName) && !empty(subscriptionId)) ? tags_rg.outputs.name : tags_sub.outputs.name

@description('The resource ID of the tags resource')
output resourceId string = (!empty(resourceGroupName) && !empty(subscriptionId)) ? tags_rg.outputs.resourceId : tags_sub.outputs.resourceId
