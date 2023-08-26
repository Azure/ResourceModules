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

// TEST 2 - PRIVATE
module private 'private/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-private-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - PUBLIC
module public 'public/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-public-test'
  params: {
    namePrefix: namePrefix
  }
}
