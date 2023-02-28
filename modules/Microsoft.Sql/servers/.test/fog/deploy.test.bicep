targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. The location to deploy failover resources to.')
param secondaryLocation string = 'northeurope'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlfog'


// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    primaryLocation: location
    secondaryLocation: secondaryLocation
    serviceShort: serviceShort
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../failoverGroups/deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: '${nestedDependencies.outputs.primaryServerName}-fog'
    serverName: nestedDependencies.outputs.primaryServerName
    partnerServerId: [{ id: nestedDependencies.outputs.failoverServerId }]
    databases: [ nestedDependencies.outputs.databaseId ]
    failoverPolicy: 'Manual'
    failoverWithDataLossGracePeriodMinutes: 60
  }
}
