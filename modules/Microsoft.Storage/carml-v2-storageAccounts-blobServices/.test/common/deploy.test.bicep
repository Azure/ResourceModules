targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.storage.storageaccounts-${serviceShort}-blobServices-containers-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cssabscom2'

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

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    storageAccountName: 'dep<<namePrefix>>sa${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    location: location
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}'
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
    name: 'default'
    storageAccountName: resourceGroupResources.outputs.storageAccountName
    // diagnosticLogsRetentionInDays: 7
    // diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    // diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    // diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    // diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    enableDefaultTelemetry: enableDefaultTelemetry
    containers: [
      {
        name: '<<namePrefix>>sac${serviceShort}01'
        publicAccess: 'None'
        immutabilityPolicyProperties: {
          name: 'default'
          allowProtectedAppendWrites: true
          immutabilityPeriodSinceCreationInDays: 365
        }
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              resourceGroupResources.outputs.managedIdentityPrincipalId
            ]
            principalType: 'ServicePrincipal'
          }
        ]
      }
    ]
  }
}
