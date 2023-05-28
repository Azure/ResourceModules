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

// TEST 2 - ENCRWSAI
module encrwsai 'encrwsai/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-encrwsai-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - ENCRWUAI
module encrwuai 'encrwuai/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-encrwuai-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 4 - MANAGEDVNET
module managedvnet 'managedvnet/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-managedvnet-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 5 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: namePrefix
  }
}
