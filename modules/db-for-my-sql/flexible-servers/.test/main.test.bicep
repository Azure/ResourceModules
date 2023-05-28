targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - PRIVATE
module private 'private/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-private-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - PUBLIC
module public 'public/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-public-test'
  params: {
    namePrefix: 'crml'
  }
}
