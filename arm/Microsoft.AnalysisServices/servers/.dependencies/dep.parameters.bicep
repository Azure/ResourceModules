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

@description('Optional. A short identifier for the kind of deployment. E.g. "aspar". Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'aspar'

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

module diagnosticDependencies '../../../.global/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-diagDep'
  params: {
    resourceGroupName: resourceGroupName
    storageAccountName: 'adpsxxazsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'adp-sxx-law-${serviceShort}-01'
    eventHubNamespaceEventHubName: 'adp-sxx-evh-${serviceShort}-01'
    eventHubNamespaceName: 'adp-sxx-evhns-${serviceShort}-01'
    location: location
  }
}

output resourceGroupResourceId string = resourceGroup.outputs.resourceId
output storageAccountResourceId string = diagnosticDependencies.outputs.storageAccountResourceId
output logAnalyticsWorkspaceResourceId string = diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
output eventHubNamespaceResourceId string = diagnosticDependencies.outputs.eventHubNamespaceResourceId
