# Redis Cache Enterprise Databases `[Microsoft.Cache/redisEnterprise/databases]`

This module deploys a Redis Cache Enterprise Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redisEnterprise/databases` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2022-01-01/redisEnterprise/databases) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`persistenceAofFrequency`](#parameter-persistenceaoffrequency) | string | Sets the frequency at which data is written to disk. Required if AOF persistence is enabled. |
| [`persistenceRdbFrequency`](#parameter-persistencerdbfrequency) | string | Sets the frequency at which a snapshot of the database is created. Required if RDB persistence is enabled. |
| [`redisCacheEnterpriseName`](#parameter-rediscacheenterprisename) | string | The name of the parent Redis Cache Enterprise Cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientProtocol`](#parameter-clientprotocol) | string | Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols. Default is TLS-encrypted. |
| [`clusteringPolicy`](#parameter-clusteringpolicy) | string | Specifies the clustering policy to enable at creation time of the Redis Cache Enterprise Cluster. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`evictionPolicy`](#parameter-evictionpolicy) | string | Redis eviction policy - default is VolatileLRU. |
| [`geoReplication`](#parameter-georeplication) | object | Optional set of properties to configure geo replication for this database. Geo replication prerequisites must be met. See "https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-active-geo-replication#active-geo-replication-prerequisites" for more information. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`modules`](#parameter-modules) | array | Optional set of redis modules to enable in this database - modules can only be added at creation time. |
| [`persistenceAofEnabled`](#parameter-persistenceaofenabled) | bool | Sets whether AOF is enabled. Required if setting AOF frequency. AOF and RDB persistence cannot be enabled at the same time. |
| [`persistenceRdbEnabled`](#parameter-persistencerdbenabled) | bool | Sets whether RDB is enabled. RDB and AOF persistence cannot be enabled at the same time. |
| [`port`](#parameter-port) | int | TCP port of the database endpoint. Specified at create time. Default is (-1) meaning value is not set and defaults to an available port. Current supported port is 10000. |

### Parameter: `clientProtocol`

Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols. Default is TLS-encrypted.
- Required: No
- Type: string
- Default: `'Encrypted'`
- Allowed:
  ```Bicep
  [
    'Encrypted'
    'Plaintext'
  ]
  ```

### Parameter: `clusteringPolicy`

Specifies the clustering policy to enable at creation time of the Redis Cache Enterprise Cluster.
- Required: No
- Type: string
- Default: `'OSSCluster'`
- Allowed:
  ```Bicep
  [
    'EnterpriseCluster'
    'OSSCluster'
  ]
  ```

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `evictionPolicy`

Redis eviction policy - default is VolatileLRU.
- Required: No
- Type: string
- Default: `'VolatileLRU'`
- Allowed:
  ```Bicep
  [
    'AllKeysLFU'
    'AllKeysLRU'
    'AllKeysRandom'
    'NoEviction'
    'VolatileLFU'
    'VolatileLRU'
    'VolatileRandom'
    'VolatileTTL'
  ]
  ```

### Parameter: `geoReplication`

Optional set of properties to configure geo replication for this database. Geo replication prerequisites must be met. See "https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-active-geo-replication#active-geo-replication-prerequisites" for more information.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `modules`

Optional set of redis modules to enable in this database - modules can only be added at creation time.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `persistenceAofEnabled`

Sets whether AOF is enabled. Required if setting AOF frequency. AOF and RDB persistence cannot be enabled at the same time.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `persistenceAofFrequency`

Sets the frequency at which data is written to disk. Required if AOF persistence is enabled.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    '1s'
    'always'
  ]
  ```

### Parameter: `persistenceRdbEnabled`

Sets whether RDB is enabled. RDB and AOF persistence cannot be enabled at the same time.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `persistenceRdbFrequency`

Sets the frequency at which a snapshot of the database is created. Required if RDB persistence is enabled.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    '12h'
    '1h'
    '6h'
  ]
  ```

### Parameter: `port`

TCP port of the database endpoint. Specified at create time. Default is (-1) meaning value is not set and defaults to an available port. Current supported port is 10000.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `redisCacheEnterpriseName`

The name of the parent Redis Cache Enterprise Cluster. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `modules`

Optional set of Redis modules to enable in this database. Modules can only be added at creation time. Each module requires a name (e.g. 'RedisBloom', 'RediSearch', 'RedisTimeSeries') and optionally an argument (e.g. 'ERROR_RATE 0.01 INITIAL_SIZE 400'). See [Redis Cache modules documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-redis-modules) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"modules": {
    "value": [
      {
        "name": "RedisBloom",
        "args": "ERROR_RATE 0.00 INITIAL_SIZE 400"
      },
      {
        "name": "RedisTimeSeries",
        "args": "RETENTION_POLICY 20"
      },
      {
        "name": "RediSearch"
      }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
modules: [
    {
        name: 'RedisBloom'
        args: 'ERROR_RATE 1.00 INITIAL_SIZE 400'
    }
    {
        name: 'RedisTimeSeries'
        args: 'RETENTION_POLICY 20'
    }
    {
        name: 'RediSearch'
    }
]
```

</details>
<p>
