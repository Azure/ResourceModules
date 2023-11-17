@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Cache Enterprise to create.')
param redisCacheEnterpriseName string

var redisCacheEnterpriseExpectedResourceID = '${resourceGroup().id}/providers/Microsoft.Cache/redisEnterprise/${redisCacheEnterpriseName}'

resource redisCacheEnterprise 'Microsoft.Cache/redisEnterprise@2022-01-01' = {
  name: redisCacheEnterpriseName
  location: location
  sku: {
    name: 'Enterprise_E10'
    capacity: 2
  }
  properties: {
    minimumTlsVersion: '1.2'
  }
  zones: [
    '1'
    '2'
    '3'
  ]

  resource database 'databases@2022-01-01' = {
    name: 'default'
    properties: {
      clusteringPolicy: 'EnterpriseCluster'
      evictionPolicy: 'NoEviction'
      persistence: {
        aofEnabled: false
        rdbEnabled: false
      }
      modules: [
        {
          name: 'RedisJSON'
        }
        {
          name: 'RediSearch'
        }
      ]
      geoReplication: {
        groupNickname: '${redisCacheEnterpriseName}-geo-group'
        linkedDatabases: [
          {
            id: '${redisCacheEnterpriseExpectedResourceID}/databases/default'
          }
        ]
      }
      port: 10000
    }
  }
}

@description('The resource ID of the created Redis Cache Enterprise database.')
output redisCacheEnterpriseDatabaseResourceId string = redisCacheEnterprise::database.id

@description('The geo replication group nickname of the created Redis Cache Enterprise database.')
output redisCacheEnterpriseDatabaseGeoReplicationGroupNickname string = redisCacheEnterprise::database.properties.geoReplication.groupNickname
