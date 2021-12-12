targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name of the resource group to deploy for a testing purposes')
param resourceGroupName string

@description('Optional. The location to deploy to')
param location string = deployment().location

// ========= //
// Variables //
// ========= //

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

// ======= //
// Outputs //
// ======= //

output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
