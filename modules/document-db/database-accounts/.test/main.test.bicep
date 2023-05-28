targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

// TEST 1 - GREMLINDB
module gremlindb 'gremlindb/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-gremlindb-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 2 - MONGODB
module mongodb 'mongodb/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-mongodb-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 3 - PLAIN
module plain 'plain/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-plain-test'
  params: {
    namePrefix: 'crml'
  }
}

// TEST 4 - SQLDB
module sqldb 'sqldb/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-sqldb-test'
  params: {
    namePrefix: 'crml'
  }
}
