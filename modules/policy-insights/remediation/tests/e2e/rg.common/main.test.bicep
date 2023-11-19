targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-policyinsights.remediations-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pirrgcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'dep-${namePrefix}-polDef-AuditKvlt-${serviceShort}'
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
  name: 'dep-${namePrefix}-polSet-${serviceShort}'
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
  name: 'dep-${namePrefix}-psa-${serviceShort}'
  location: location
  properties: {
    displayName: 'Test case assignment'
    policyDefinitionId: policySet.id
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../resource-group/main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    location: location
    policyAssignmentId: policySetAssignment.id
    policyDefinitionReferenceId: policySet.properties.policyDefinitions[0].policyDefinitionReferenceId
    filtersLocations: [
      'australiaeast'
    ]
    resourceCount: 10
    resourceDiscoveryMode: 'ExistingNonCompliant'
    parallelDeployments: 1
    failureThresholdPercentage: '0.5'
  }
}]
