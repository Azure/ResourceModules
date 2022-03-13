targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string

// Shared
@description('Optional. The location to deploy resources to')
param location string = deployment().location

// =========== //
// Deployments //
// =========== //

// Resource Group
module resourceGroup '../../../Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

@description('The resource ID of the resource group')
output resourceGroupResourceId string = resourceGroup.outputs.resourceId
