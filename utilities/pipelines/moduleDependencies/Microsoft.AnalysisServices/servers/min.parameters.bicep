targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
param resourceGroupName string

// Shared
// var deploymentPrefix = 'analysisServicesServersParameters'
var location = deployment().location

// =========== //
// Deployments //
// =========== //

// Resource Group
module resourceGroup '../../../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  // scope: subscription()
  params: {
    name: resourceGroupName
    location: location
  }
}

@description('The name of the resource group the resources are deployed into')
output resourceGroupName string = resourceGroup.outputs.resourceGroupName
