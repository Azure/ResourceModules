targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(80)
param resourceGroupName string = 'ms.authorization.policyassignments-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apasubcom'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../subscription/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26'
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: location
    metadata: {
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg'
    ]
    parameters: {
      tagName: {
        value: 'env'
      }
      tagValue: {
        value: 'prod'
      }
    }
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: subscription().subscriptionId
    userAssignedIdentityId: resourceGroupResources.outputs.managedIdentityResourceId
  }
}
