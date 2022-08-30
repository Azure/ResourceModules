targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. A short identifier for the kind of deployment .Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'apsdsubmin'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../subscription/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    policyDefinitions: [
      {
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
      }
    ]
    // Non-required parameters
    subscriptionId: '<<subscriptionId>>'
  }
}
