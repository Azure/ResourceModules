targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'msrdcom'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: 'Component Validation - <<namePrefix>>${serviceShort} Subscription assignment'
    authorizations: [
      {
        principalId: 'e87a249c-b53b-4685-94fe-863af522e4ee'
        principalIdDisplayName: 'ResourceModules-Reader'
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      }
      {
        principalId: 'e2f126a7-136e-443f-b39f-f73ddfd146b1'
        principalIdDisplayName: 'ResourceModules-Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '87813317-fb25-4c76-91fe-783af429d109'
        principalIdDisplayName: 'ResourceModules-LHManagement'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '195ee85d-2f10-4764-8352-a3c99aa772fb'
    registrationDescription: 'Managed by Lighthouse'
  }
}
