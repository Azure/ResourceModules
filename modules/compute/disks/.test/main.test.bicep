targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - COMMON
module common 'common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-common-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - IMAGE
module image 'image/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-image-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - IMPORT
module import 'import/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-import-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}
