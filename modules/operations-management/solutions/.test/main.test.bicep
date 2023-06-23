targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - MS
module ms 'ms/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-ms-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - NONMS
module nonms 'nonms/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-nonms-test'
  params: {
    namePrefix: namePrefix
  }
}
