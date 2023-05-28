targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - ACCESSPOLICIES
module accessPolicies 'accessPolicies/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-accessPolicies-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: 'crml'
  }
}
