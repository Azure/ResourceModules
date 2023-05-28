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

// TEST 2 - ENCRWSAI
module encrwsai 'encrwsai/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-encrwsai-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - ENCRWUAI
module encrwuai 'encrwuai/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-encrwuai-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - MANAGEDVNET
module managedvnet 'managedvnet/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-managedvnet-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 5 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}
