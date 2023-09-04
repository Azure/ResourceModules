targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - AADVPN
module aadvpn 'aadvpn/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-aadvpn-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - EXPRESSROUTE
module expressRoute 'expressRoute/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-expressRoute-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - VPN
module vpn 'vpn/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-vpn-test'
  params: {
    namePrefix: namePrefix
  }
}
