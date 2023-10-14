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

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `persistenceAofFrequency` | string | `''` | `['', 1s, always]` | Sets the frequency at which data is written to disk. Required if AOF persistence is enabled. |
| `persistenceRdbFrequency` | string | `''` | `['', 12h, 1h, 6h]` | Sets the frequency at which a snapshot of the database is created. Required if RDB persistence is enabled. |
| `redisCacheEnterpriseName` | string |  |  | The name of the parent Redis Cache Enterprise Cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `clientProtocol` | string | `'Encrypted'` | `[Encrypted, Plaintext]` | Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols. Default is TLS-encrypted. |
| `clusteringPolicy` | string | `'OSSCluster'` | `[EnterpriseCluster, OSSCluster]` | Specifies the clustering policy to enable at creation time of the Redis Cache Enterprise Cluster. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `evictionPolicy` | string | `'VolatileLRU'` | `[AllKeysLFU, AllKeysLRU, AllKeysRandom, NoEviction, VolatileLFU, VolatileLRU, VolatileRandom, VolatileTTL]` | Redis eviction policy - default is VolatileLRU. |
| `geoReplication` | object | `{object}` |  | Optional set of properties to configure geo replication for this database. Geo replication prerequisites must be met. See "https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-active-geo-replication#active-geo-replication-prerequisites" for more information. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `modules` | array | `[]` |  | Optional set of redis modules to enable in this database - modules can only be added at creation time. |
| `persistenceAofEnabled` | bool | `False` |  | Sets whether AOF is enabled. Required if setting AOF frequency. AOF and RDB persistence cannot be enabled at the same time. |
| `persistenceRdbEnabled` | bool | `False` |  | Sets whether RDB is enabled. RDB and AOF persistence cannot be enabled at the same time. |
| `port` | int | `-1` |  | TCP port of the database endpoint. Specified at create time. Default is (-1) meaning value is not set and defaults to an available port. Current supported port is 10000. |


## Outputs

| Output Name | Type | Description |
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
