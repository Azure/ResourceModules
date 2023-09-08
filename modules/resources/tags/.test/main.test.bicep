targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {}
}

// TEST 2 - RG
module rg 'rg/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-rg-test'
  params: {}
}

// TEST 3 - SUB
module sub 'sub/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sub-test'
  params: {}
}
