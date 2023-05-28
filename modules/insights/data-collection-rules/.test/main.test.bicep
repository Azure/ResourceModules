targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - CUSTOMADV
module customadv 'customadv/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-customadv-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - CUSTOMBASIC
module custombasic 'custombasic/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-custombasic-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - CUSTOMIIS
module customiis 'customiis/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-customiis-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - LINUX
module linux 'linux/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-linux-test'
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

// TEST 6 - WINDOWS
module windows 'windows/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-windows-test'
  params: {
    namePrefix: 'crml'
  }
}
