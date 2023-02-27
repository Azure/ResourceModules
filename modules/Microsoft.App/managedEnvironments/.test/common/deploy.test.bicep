targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.app.managedenvironments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'amecom'

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
    logAnalyticsWorkspaceName: 'dep-skhan-law-${serviceShort}'
    virtualNetworkName: 'dep-skhan-vnet-${serviceShort}'
    //logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    //virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
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
    //name: '<<namePrefix>>${serviceShort}001'
    name: 'skhan${serviceShort}001'
    logAnalyticsWorkspaceName: nestedDependencies.outputs.logAnalyticsWorkspaceName
    resourceGroupLAWorkspace: resourceGroup.name
    location: location
    skuName: 'Consumption'
    infrastructureSubnetId: nestedDependencies.outputs.subnetResourceId
  }
}
