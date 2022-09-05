targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. A short identifier for the kind of deployment .Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'cbmin'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    amount: 500
    contactEmails: [
      'dummy@contoso.com'
    ]
  }
}
