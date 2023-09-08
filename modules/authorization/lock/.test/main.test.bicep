targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {}
}
