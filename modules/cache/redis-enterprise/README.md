# Redis Cache Enterprise `[Microsoft.Cache/redisEnterprise]`

This module deploys a Redis Cache Enterprise.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Cache/redisEnterprise` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2022-01-01/redisEnterprise) |
| `Microsoft.Cache/redisEnterprise/databases` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2022-01-01/redisEnterprise/databases) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Redis Cache Enerprise resource. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `capacity` | int | `2` |  | The size of the Redis Enterprise Cluster. Defaults to 2. Valid values are (2, 4, 6, ...) for Enterprise SKUs and (3, 9, 15, ...) for Flash SKUs. |
| `databases` | array | `[]` |  | The databases to create in the Redis Cache Enterprise Cluster. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[]` | `['', audit, ConnectionEvents]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource, but currently not supported for Redis Cache Enterprise. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | The geo-location where the resource lives. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `minimumTlsVersion` | string | `'1.2'` | `[1.0, 1.1, 1.2]` | Requires clients to use a specified TLS version (or higher) to connect. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `skuName` | string | `'Enterprise_E10'` | `[Enterprise_E10, Enterprise_E100, Enterprise_E20, Enterprise_E50, EnterpriseFlash_F1500, EnterpriseFlash_F300, EnterpriseFlash_F700]` | The type of Redis Enterprise Cluster to deploy. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `zoneRedundant` | bool | `True` |  | When true, the cluster will be deployed across availability zones. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

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

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "ipConfigurations":[
                {
                    "name": "myIPconfigTest02",
                    "properties": {
                        "groupId": "blob",
                        "memberName": "blob",
                        "privateIPAddress": "10.0.0.30"
                    }
                }
            ],
            "customDnsConfigs": [
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>" // e.g. vault, registry, blob
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroup: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
        ipConfigurations:[
          {
            name: 'myIPconfigTest02'
            properties: {
              groupId: 'blob'
              memberName: 'blob'
              privateIPAddress: '10.0.0.30'
            }
          }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `hostName` | string | Redis hostname. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the redis cache enterprise. |
| `resourceGroupName` | string | The name of the resource group the redis cache enterprise was created in. |
| `resourceId` | string | The resource ID of the redis cache enterprise. |

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
module redisEnterprise './cache/redis-enterprise/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crecom'
  params: {
    // Required parameters
    name: 'crecom001'
    // Non-required parameters
    capacity: 2
    databases: [
      {
        clusteringPolicy: 'EnterpriseCluster'
        evictionPolicy: 'AllKeysLFU'
        modules: [
          {
            args: 'ERROR_RATE 1.00 INITIAL_SIZE 400'
            name: 'RedisBloom'
          }
          {
            args: 'RETENTION_POLICY 20'
            name: 'RedisTimeSeries'
          }
        ]
        persistenceAofEnabled: true
        persistenceAofFrequency: '1s'
        persistenceRdbEnabled: false
        port: 10000
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticSettingsName: 'redisdiagnostics'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    minimumTlsVersion: '1.2'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'redisEnterprise'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Redis Cache Enterprise'
    }
    zoneRedundant: true
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
      "value": "crecom001"
    },
    // Non-required parameters
    "capacity": {
      "value": 2
    },
    "databases": {
      "value": [
        {
          "clusteringPolicy": "EnterpriseCluster",
          "evictionPolicy": "AllKeysLFU",
          "modules": [
            {
              "args": "ERROR_RATE 1.00 INITIAL_SIZE 400",
              "name": "RedisBloom"
            },
            {
              "args": "RETENTION_POLICY 20",
              "name": "RedisTimeSeries"
            }
          ],
          "persistenceAofEnabled": true,
          "persistenceAofFrequency": "1s",
          "persistenceRdbEnabled": false,
          "port": 10000
        }
      ]
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
          "service": "redisEnterprise",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "Redis Cache Enterprise"
      }
    },
    "zoneRedundant": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 2: Geo</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise './cache/redis-enterprise/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cregeo'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    capacity: 2
    databases: [
      {
        clusteringPolicy: 'EnterpriseCluster'
        evictionPolicy: 'NoEviction'
        geoReplication: {
          groupNickname: '<groupNickname>'
          linkedDatabases: [
            {
              id: '<id>'
            }
            {
              id: '<id>'
            }
          ]
        }
        modules: [
          {
            name: 'RediSearch'
          }
          {
            name: 'RedisJSON'
          }
        ]
        persistenceAofEnabled: false
        persistenceRdbEnabled: false
        port: 10000
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Redis Cache Enterprise'
    }
    zoneRedundant: true
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
      "value": "<name>"
    },
    // Non-required parameters
    "capacity": {
      "value": 2
    },
    "databases": {
      "value": [
        {
          "clusteringPolicy": "EnterpriseCluster",
          "evictionPolicy": "NoEviction",
          "geoReplication": {
            "groupNickname": "<groupNickname>",
            "linkedDatabases": [
              {
                "id": "<id>"
              },
              {
                "id": "<id>"
              }
            ]
          },
          "modules": [
            {
              "name": "RediSearch"
            },
            {
              "name": "RedisJSON"
            }
          ],
          "persistenceAofEnabled": false,
          "persistenceRdbEnabled": false,
          "port": 10000
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "Redis Cache Enterprise"
      }
    },
    "zoneRedundant": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise './cache/redis-enterprise/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cremin'
  params: {
    // Required parameters
    name: 'cremin001'
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
      "value": "cremin001"
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
