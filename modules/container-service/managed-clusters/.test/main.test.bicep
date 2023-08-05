targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - AZURE
module azure 'azure/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-azure-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - KUBENET
module kubenet 'kubenet/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-kubenet-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 4 - Private AKS Cluster
module priv 'priv/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-priv-test'
  params: {
    namePrefix: namePrefix
  }
}
