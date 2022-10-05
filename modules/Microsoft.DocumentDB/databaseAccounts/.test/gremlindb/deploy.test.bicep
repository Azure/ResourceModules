targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddagrm'

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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
    location: location
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
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: 'West Europe'
      }
      {
        failoverPriority: 1
        isZoneRedundant: false
        locationName: 'North Europe'
      }
    ]
    capabilitiesToAdd: [
      'EnableGremlin'
    ]
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    diagnosticLogsRetentionInDays: 7
    gremlinDatabases: [
      {
        graphs: [
          {
            automaticIndexing: true
            name: 'car_collection'
            partitionKeyPaths: [
              '/car_id'
            ]
          }
          {
            automaticIndexing: true
            name: 'truck_collection'
            partitionKeyPaths: [
              '/truck_id'
            ]
          }
        ]
        name: '<<namePrefix>>-gdb-${serviceShort}-001'
      }
      {
        collections: [
          {
            automaticIndexing: true
            name: 'bike_collection'
            partitionKeyPaths: [
              '/bike_id'
            ]
          }
          {
            automaticIndexing: true
            name: 'bicycle_collection'
            partitionKeyPaths: [
              '/bicycle_id'
            ]
          }
        ]
        name: '<<namePrefix>>-gdb-${serviceShort}-002'
      }
    ]
    location: location
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
  }
}
