targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - SUB.COMMON
module sub_common 'sub.common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sub.common-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - SUB.MIN
module sub_min 'sub.min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sub.min-test'
  params: {
    namePrefix: namePrefix
  }
}
