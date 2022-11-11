targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apesubcom'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'dep-<<namePrefix>>-${serviceShort}-rgloc'
  location: location
  properties: {
    displayName: '[Depedency] Audit resource location matches resource group location (management group scope)'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../subscription/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    policyAssignmentId: policyAssignment.id
    displayName: '[Display Name] policy exempt (subscription scope)'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    subscriptionId: subscription().subscriptionId
    assignmentScopeValidation: 'Default'
    description: 'My description'
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            kind: 'resourceLocation'
            in: [
              'westcentralus'
            ]
          }
        ]
      }
    ]
    policyDefinitionReferenceIds: [
      'StorageAccountNetworkACLs'
    ]
  }
}
