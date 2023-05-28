targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - ADDPIP
module addpip 'addpip/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-addpip-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - CUSTOMPIP
module custompip 'custompip/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-custompip-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 4 - HUBCOMMON
module hubcommon 'hubcommon/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-hubcommon-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 5 - HUBMIN
module hubmin 'hubmin/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-hubmin-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 6 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: namePrefix
  }
}
