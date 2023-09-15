metadata name = 'Redis Cache Enterprise Databases'
metadata description = 'This module deploys a Redis Cache Enterprise Database.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Redis Cache Enterprise Cluster. Required if the template is used in a standalone deployment.')
param redisCacheEnterpriseName string

@allowed([
  'Encrypted'
  'Plaintext'
])
@description('Optional. Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols. Default is TLS-encrypted.')
param clientProtocol string = 'Encrypted'

@allowed([
  'EnterpriseCluster'
  'OSSCluster'
])
@description('Optional. Clustering policy - default is OSSCluster. Specified at create time.')
param clusteringPolicy string = 'OSSCluster'

@allowed([
  'AllKeysLFU'
  'AllKeysLRU'
  'AllKeysRandom'
  'NoEviction'
  'VolatileLFU'
  'VolatileLRU'
  'VolatileRandom'
  'VolatileTTL'
])
@description('Optional. Redis eviction policy - default is VolatileLRU.')
param evictionPolicy string = 'VolatileLRU'

@description('Optional. Optional set of properties to configure geo replication for this database.')
param geoReplication object = {}

@description('Optional. Optional set of redis modules to enable in this database - modules can only be added at creation time.')
param modules array = []

@description('Conditional. Sets whether AOF is enabled. Required if setting AOF frequency. AOF and RDB cannot be enabled at the same time.')
param persistenceAofEnabled bool = false

@allowed([
  ''
  '1s'
  'always'
])
@description('Optional. Sets the frequency at which data is written to disk. Can be set when AOF is enabled.')
param persistenceAofFrequency string = ''

@description('Conditional. Sets whether RDB is enabled. Required if setting RDB frequency. AOF and RDB cannot be enabled at the same time.')
param persistenceRdbEnabled bool = false

@allowed([
  ''
  '12h'
  '1h'
  '6h'
])
@description('Optional. Sets the frequency at which a snapshot of the database is created. Can be set when RDB is enabled.')
param persistenceRdbFrequency string = ''

@description('Optional. TCP port of the database endpoint. Specified at create time. Default is (-1) meaning value is not set and defaults to an available port. Current supported port is 10000.')
param port int = -1

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource redisCacheEnterprise 'Microsoft.Cache/redisEnterprise@2022-01-01' existing = {
  name: redisCacheEnterpriseName
}

resource database 'Microsoft.Cache/redisEnterprise/databases@2022-01-01' = {
  name: 'default'
  parent: redisCacheEnterprise
  properties: {
    clientProtocol: !empty(clientProtocol) ? clientProtocol : null
    clusteringPolicy: !empty(clusteringPolicy) ? clusteringPolicy : null
    evictionPolicy: !empty(evictionPolicy) ? evictionPolicy : null
    geoReplication: !empty(geoReplication) ? geoReplication : null
    modules: !empty(modules) ? modules : null
    persistence: {
      aofEnabled: persistenceAofEnabled
      aofFrequency: !empty(persistenceAofFrequency) ? persistenceAofFrequency : null
      rdbEnabled: persistenceRdbEnabled
      rdbFrequency: !empty(persistenceRdbFrequency) ? persistenceRdbFrequency : null
    }
    port: port != -1 ? port : null
  }
}

@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output resourceId string = database.id

@description('The resource group of the deployed database.')
output resourceGroupName string = resourceGroup().name
