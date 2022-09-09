targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = 'ms.machinelearningservices.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'mlswmin'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    applicationInsightsName: 'dep-<<namePrefix>>-appI-${serviceShort}'
    storageAccountName: 'dep<<namePrefix>>st${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    associatedApplicationInsightsResourceId: resourceGroupResources.outputs.applicationInsightsResourceId
    associatedKeyVaultResourceId: resourceGroupResources.outputs.keyVaultResourceId
    associatedStorageAccountResourceId: resourceGroupResources.outputs.storageAccountResourceId
    sku: 'Basic'
    systemAssignedIdentity: true
  }
}
