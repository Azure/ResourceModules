targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - MG.COMMON
module mg_common 'mg.common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-mg.common-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - MG.MIN
module mg_min 'mg.min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-mg.min-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - SUB.COMMON
module sub_common 'sub.common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sub.common-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 4 - SUB.MIN
module sub_min 'sub.min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sub.min-test'
  params: {
    namePrefix: namePrefix
  }
}
