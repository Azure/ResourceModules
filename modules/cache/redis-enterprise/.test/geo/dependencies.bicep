@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Cache Enterprise to create.')
param redisCacheEnterpriseName string

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
      evictionPolicy: 'AllKeysLFU'
      modules: [
        {
          name: 'RediSearch'
        }
        {
          name: 'RedisJSON'
        }
      ]
    }
  }
}

@description('The resource ID of the created Redis Cache Enterprise database.')
output redisCacheEnterpriseDatabaseResourceId string = redisCacheEnterprise::database.id
