targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - CLI
module cli 'cli/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-cli-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - PS
module ps 'ps/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-ps-test'
  params: {
    namePrefix: namePrefix
  }
}
