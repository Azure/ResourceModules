targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - LINUX
module linux 'linux/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-linux-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - LINUX.ATMG
module linux_atmg 'linux.atmg/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-linux.atmg-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - LINUX.MIN
module linux_min 'linux.min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-linux.min-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - WINDOWS
module windows 'windows/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-windows-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 5 - WINDOWS.ATMG
module windows_atmg 'windows.atmg/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-windows.atmg-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 6 - WINDOWS.MIN
module windows_min 'windows.min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-windows.min-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 7 - WINDOWS.SSECMK
module windows_ssecmk 'windows.ssecmk/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-windows.ssecmk-test'
  params: {
    namePrefix: 'crml'
  }
}
