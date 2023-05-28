targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - ADDPIP
module addpip 'addpip/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-addpip-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - CUSTOMPIP
module custompip 'custompip/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-custompip-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - HUBCOMMON
module hubcommon 'hubcommon/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-hubcommon-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 5 - HUBMIN
module hubmin 'hubmin/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-hubmin-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 6 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}
