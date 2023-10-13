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
| `name` | string | The name of the Redis Cache Enterprise resource. |

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
