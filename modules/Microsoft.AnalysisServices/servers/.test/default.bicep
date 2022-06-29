targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Required. The name prefix to inject into all resource names')
param namePrefix string

@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = '${serviceShort}-ms.analysisservices-servers-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment .Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'aspar'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'nestedTemplates/default.nested.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-${namePrefix}-az-msi-${serviceShort}-01'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../.global/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagDep'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}-01'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}-01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}-01'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-servers-${serviceShort}'
  params: {
    name: '${namePrefix}azas${serviceShort}001'
    lock: 'CanNotDelete'
    skuName: 'S0'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
  }
}
