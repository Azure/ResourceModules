targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.policyinsights.remediations-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pirrgmin'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'dep-${namePrefix}-psa-${serviceShort}'
  location: location
  properties: {
    displayName: 'Test case assignment'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../resource-group/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  scope: resourceGroup
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    policyAssignmentId: policyAssignment.id
  }
}
