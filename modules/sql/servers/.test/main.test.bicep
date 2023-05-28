targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - ADMIN
module admin 'admin/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-admin-test'
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

// TEST 3 - PE
module pe 'pe/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-pe-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - SECONDARY
module secondary 'secondary/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-secondary-test'
  params: {
    namePrefix: 'crml'
  }
}
