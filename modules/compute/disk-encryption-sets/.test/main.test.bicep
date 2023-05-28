targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - ACCESSPOLICIES
module accessPolicies 'accessPolicies/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-accessPolicies-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: namePrefix
  }
}
