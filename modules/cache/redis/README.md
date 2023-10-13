# Redis Cache `[Microsoft.Cache/redis]`

This module deploys a Redis Cache.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Cache/redis` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2022-06-01/redis) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Redis cache resource. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `capacity` | int | `1` | `[0, 1, 2, 3, 4, 5, 6]` | The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4). |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, ConnectedClientList]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableNonSslPort` | bool | `False` |  | Specifies whether the non-ssl Redis server port (6379) is enabled. |
| `location` | string | `[resourceGroup().location]` |  | The location to deploy the Redis cache service. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `minimumTlsVersion` | string | `'1.2'` | `[1.0, 1.1, 1.2]` | Requires clients to use a specified TLS version (or higher) to connect. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| `redisConfiguration` | object | `{object}` |  | All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc. |
| `redisVersion` | string | `'6'` | `[4, 6]` | Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6). |
| `replicasPerMaster` | int | `1` |  | The number of replicas to be created per primary. |
| `replicasPerPrimary` | int | `1` |  | The number of replicas to be created per primary. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `shardCount` | int | `1` |  | The number of shards to be created on a Premium Cluster Cache. |
| `skuName` | string | `'Basic'` | `[Basic, Premium, Standard]` | The type of Redis cache to deploy. |
| `staticIP` | string | `''` |  | Static IP address. Optionally, may be specified when deploying a Redis cache inside an existing Azure Virtual Network; auto assigned by default. |
| `subnetId` | string | `''` |  | The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `tenantSettings` | object | `{object}` |  | A dictionary of tenant settings. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `zoneRedundant` | bool | `True` |  | When true, replicas will be provisioned in availability zones specified in the zones parameter. |
| `zones` | array | `[]` |  | If the zoneRedundant parameter is true, replicas will be provisioned in the availability zones specified here. Otherwise, the service will choose where replicas are deployed. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `hostName` | string | Redis hostname. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Redis Cache. |
| `resourceGroupName` | string | The name of the resource group the Redis Cache was created in. |
| `resourceId` | string | The resource ID of the Redis Cache. |
| `sslPort` | int | Redis SSL port. |
| `subnetId` | string | The full resource ID of a subnet in a virtual network where the Redis Cache was deployed in. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoint` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module redis './cache/redis/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crcom'
  params: {
    // Required parameters
    name: 'crcom001'
    // Non-required parameters
    capacity: 2
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticSettingsName: 'redisdiagnostics'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableNonSslPort: true
    lock: 'CanNotDelete'
    minimumTlsVersion: '1.2'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'redisCache'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicNetworkAccess: 'Enabled'
    redisVersion: '6'
    shardCount: 1
    skuName: 'Premium'
    systemAssignedIdentity: true
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Redis Cache'
    }
    zoneRedundant: true
    zones: [
      1
      2
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "crcom001"
    },
    // Non-required parameters
    "capacity": {
      "value": 2
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticSettingsName": {
      "value": "redisdiagnostics"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableNonSslPort": {
      "value": true
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "minimumTlsVersion": {
      "value": "1.2"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "redisCache",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "redisVersion": {
      "value": "6"
    },
    "shardCount": {
      "value": 1
    },
    "skuName": {
      "value": "Premium"
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "Redis Cache"
      }
    },
    "zoneRedundant": {
      "value": true
    },
    "zones": {
      "value": [
        1,
        2
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module redis './cache/redis/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crmin'
  params: {
    // Required parameters
    name: 'crmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "crmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>


## Notes

### Parameter Usage: `redisConfiguration`

All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc..

Name | Description | Value
---------|----------|---------
aof-storage-connection-string-0 | First storage account connection string | string
aof-storage-connection-string-1 | Second storage account connection string | string
maxfragmentationmemory-reserved | Value in megabytes reserved for fragmentation per shard | string
maxmemory-delta | Value in megabytes reserved for non-cache usage per shard e.g. failover. | string
maxmemory-policy | The eviction strategy used when your data won't fit within its memory limit. | string
maxmemory-reserved | Value in megabytes reserved for non-cache usage per shard e.g. failover. | string
rdb-backup-enabled | Specifies whether the rdb backup is enabled | string
rdb-backup-frequency | Specifies the frequency for creating rdb backup | string
rdb-backup-max-snapshot-count | Specifies the maximum number of snapshots for rdb backup | string
rdb-storage-connection-string | The storage account connection string for storing rdb file | string

For more details visit [Microsoft.Cache redis reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.cache/redis?tabs=bicep)

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>
