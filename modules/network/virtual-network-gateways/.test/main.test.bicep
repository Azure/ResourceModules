targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - AADVPN
module aadvpn 'aadvpn/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-aadvpn-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - EXPRESSROUTE
module expressRoute 'expressRoute/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-expressRoute-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - VPN
module vpn 'vpn/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-vpn-test'
  params: {
    namePrefix: 'crml'
  }
}
