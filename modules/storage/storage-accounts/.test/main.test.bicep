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

// TEST 2 - ENCR
module encr 'encr/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-encr-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - MIN
module min 'min/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-min-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - NFS
module nfs 'nfs/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-nfs-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 5 - V1
module v1 'v1/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-v1-test'
  params: {
    namePrefix: 'crml'
  }
}
