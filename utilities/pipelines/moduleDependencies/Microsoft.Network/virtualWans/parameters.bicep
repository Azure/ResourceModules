targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string

// Shared
var location = deployment().location

// =========== //
// Deployments //
// =========== //

// Resource Group
module resourceGroup '../../../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

@description('The name of the resource group')
output resourceGroupName string = resourceGroup.outputs.resourceGroupName

@description('The resource ID of the resource group')
output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
