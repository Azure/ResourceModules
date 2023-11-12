targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pirmgmin'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
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

@batchSize(1)
module testDeployment '../../../management-group/main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    policyAssignmentId: policyAssignment.id
  }
}]
