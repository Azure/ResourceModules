targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(80)
param resourceGroupName string = 'ms.authorization.locks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment .Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'aldef'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    level: 'CanNotDelete'
    resourceGroupName: resourceGroup.name
    subscriptionId: subscription().subscriptionId
  }
}
