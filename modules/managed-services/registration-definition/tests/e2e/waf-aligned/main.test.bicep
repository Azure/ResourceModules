targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msrdwaf'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}-${iteration}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: 'Component Validation - ${namePrefix}${serviceShort} Subscription assignment'
    authorizations: [
      {
        principalId: '<< SET YOUR PRINCIPAL ID 1 HERE >>'
        principalIdDisplayName: 'ResourceModules-Reader'
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 2 HERE >>'
        principalIdDisplayName: 'ResourceModules-Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 3 HERE >>'
        principalIdDisplayName: 'ResourceModules-LHManagement'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<< SET YOUR TENANT ID HERE >>'
    registrationDescription: 'Managed by Lighthouse'
  }
}]
