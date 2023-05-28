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

// TEST 2 - CUSTOMPIP
module custompip 'custompip/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-custompip-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}
