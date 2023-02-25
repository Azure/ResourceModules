targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.managedEnvironments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mcappcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    logAnalticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    location: location
    virutalNetworkAddressPrefix: '10.0.0.0/16'
    virutalNetworkname: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    subnetName: 'dep-<<namePrefix>>-subnet-${serviceShort}'
    subnetAddressPrefix: '10.0.0.0/23'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: 'dep-<<namePrefix>>-menv-${serviceShort}001'
    logAnalticsWorkspaceName: nestedDependencies.outputs.logAnalticsWorkspaceName
    resourceGroupLAWorkspace: resourceGroup.name
    location: location
    skuName: 'Consumption'
    infrastructureSubnetId: nestedDependencies.outputs.subnetResourceId
  }
}
