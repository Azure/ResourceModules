targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //
@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apemgcom'

// =========== //
// Deployments //
// =========== //

// General resources
// =================

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: '${serviceShort}-AuditKeyVaults'
  properties: {
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.KeyVault/vaults'
            field: 'type'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
    parameters: {
      effect: {
        allowedValues: [
          'Audit'
        ]
        defaultValue: 'Audit'
        type: 'String'
      }
    }
  }
}

resource policySet 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'testSet'
  properties: {
    policyDefinitions: [
      {
        parameters: {
          effect: {
            value: 'Audit'
          }
        }
        policyDefinitionId: policyDefinition.id
        policyDefinitionReferenceId: policyDefinition.name
      }
    ]
  }
}

resource policySetAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'dep-<<namePrefix>>-${serviceShort}-rgloc'
  location: location
  properties: {
    displayName: 'Test case assignment'
    policyDefinitionId: policySet.id
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../managementGroup/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    policyAssignmentId: policySetAssignment.id
    displayName: '[Display Name] policy exempt (management group scope)'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    managementGroupId: last(split(managementGroup().id, '/'))
    metadata: {
      category: 'Security'
    }
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
      policySet.properties.policyDefinitions[0].policyDefinitionReferenceId
    ]
  }
}
