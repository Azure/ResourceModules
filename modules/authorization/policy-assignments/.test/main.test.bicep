targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - RG.COMMON
module rg_common 'rg.common/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-rg.common-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - RG.MIN
module rg_min 'rg.min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-rg.min-test'
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
