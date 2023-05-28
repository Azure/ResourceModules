targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - RG
module rg 'rg/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-rg-test'
  params: {
    namePrefix: 'crml'
  }
}
