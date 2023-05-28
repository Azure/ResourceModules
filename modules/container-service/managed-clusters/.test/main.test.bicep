targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - AZURE
module azure 'azure/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-azure-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - KUBENET
module kubenet 'kubenet/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-kubenet-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}
