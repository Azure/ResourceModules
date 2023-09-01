targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'crml'

// TEST 1 - GREMLINDB
module gremlindb 'gremlindb/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-gremlindb-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - MONGODB
module mongodb 'mongodb/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-mongodb-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - PLAIN
module plain 'plain/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-plain-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 4 - SQLDB
module sqldb 'sqldb/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sqldb-test'
  params: {
    namePrefix: namePrefix
  }
}
