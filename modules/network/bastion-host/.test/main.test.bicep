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

// TEST 2 - CUSTOMPIP
module custompip 'custompip/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-custompip-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: namePrefix
  }
}
