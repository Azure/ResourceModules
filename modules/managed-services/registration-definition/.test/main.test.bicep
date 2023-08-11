targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - RG
module rg 'rg/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-rg-test'
  params: {
    namePrefix: namePrefix
  }
}
