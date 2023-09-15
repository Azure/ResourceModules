# Redis Cache Enterprise Databases `[Microsoft.Cache/redisEnterprise/databases]`

This module deploys a Redis Cache Enterprise Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redisEnterprise/databases` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/redisEnterprise) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the database. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `persistenceAofEnabled` | bool | `False` | Sets whether AOF is enabled. Required if setting AOF frequency. |
| `persistenceRdbEnabled` | bool | `False` | Sets whether RDB is enabled. Required if setting RDB frequency. |
| `redisCacheEnterpriseName` | string |  | The name of the parent Redis Cache Enterprise Cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `clientProtocol` | string | `'Encrypted'` | `[Encrypted, Plaintext]` | Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols. Default is TLS-encrypted. |
| `clusteringPolicy` | string | `'OSSCluster'` | `[EnterpriseCluster, OSSCluster]` | Clustering policy - default is OSSCluster. Specified at create time. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `evictionPolicy` | string | `'VolatileLRU'` | `[AllKeysLFU, AllKeysLRU, AllKeysRandom, NoEviction, VolatileLFU, VolatileLRU, VolatileRandom, VolatileTTL]` | Redis eviction policy - default is VolatileLRU. |
| `geoReplication` | object | `{object}` |  | Optional set of properties to configure geo replication for this database. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `modules` | array | `[]` |  | Optional set of redis modules to enable in this database - modules can only be added at creation time. |
| `persistenceAofFrequency` | string | `''` | `['', 1s, always]` | Sets the frequency at which data is written to disk. Can be set when AOF is enabled. |
| `persistenceRdbFrequency` | string | `''` | `['', 12h, 1h, 6h]` | Sets the frequency at which a snapshot of the database is created. Can be set when RDB is enabled. |
| `port` | int | `-1` |  | TCP port of the database endpoint. Specified at create time. Default is (-1) meaning value is not set and defaults to an available port. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_
