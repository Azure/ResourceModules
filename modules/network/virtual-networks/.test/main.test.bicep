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

// TEST 2 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - VNETPEERING
module vnetPeering 'vnetPeering/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-vnetPeering-test'
  params: {
    namePrefix: namePrefix
  }
}
