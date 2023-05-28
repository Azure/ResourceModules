targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - CLI
module cli 'cli/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-cli-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - PS
module ps 'ps/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-ps-test'
  params: {
    namePrefix: 'crml'
  }
}
