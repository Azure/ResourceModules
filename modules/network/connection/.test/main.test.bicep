targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - VNET2VNET
module vnet2vnet 'vnet2vnet/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-vnet2vnet-test'
  params: {
    namePrefix: namePrefix
  }
}
