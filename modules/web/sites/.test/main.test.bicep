targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - FUNCTIONAPPCOMMON
module functionAppCommon 'functionAppCommon/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-functionAppCommon-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - FUNCTIONAPPMIN
module functionAppMin 'functionAppMin/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-functionAppMin-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - WEBAPPCOMMON
module webAppCommon 'webAppCommon/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-webAppCommon-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 4 - WEBAPPMIN
module webAppMin 'webAppMin/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-webAppMin-test'
  params: {
    namePrefix: namePrefix
  }
}
