targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - ASEV2
module asev2 'asev2/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-asev2-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - ASEV3
module asev3 'asev3/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-asev3-test'
  params: {
    namePrefix: namePrefix
  }
}
