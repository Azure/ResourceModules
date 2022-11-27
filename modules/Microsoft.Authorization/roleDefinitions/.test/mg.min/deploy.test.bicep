targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //
@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ardmgmin'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../managementGroup/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    roleName: '<<namePrefix>>-testRole-${serviceShort}'
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
  }
}
