# Redis Cache Enterprise `[Microsoft.Cache/redisEnterprise]`

This module deploys a Redis Cache Enterprise.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

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

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/cache.redis-enterprise:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Geo](#example-2-geo)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br:bicep/modules/cache.redis-enterprise:1.0.0' = {
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

### Example 2: _Geo_

<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br:bicep/modules/cache.redis-enterprise:1.0.0' = {
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

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br:bicep/modules/cache.redis-enterprise:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cremax'
  params: {
    // Required parameters
    name: 'cremax001'
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
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    minimumTlsVersion: '1.2'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
        principalId: '<principalId>'
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
      "value": "cremax001"
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
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "minimumTlsVersion": {
      "value": "1.2"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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
          "principalId": "<principalId>",
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br:bicep/modules/cache.redis-enterprise:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-crewaf'
  params: {
    // Required parameters
    name: 'crewaf001'
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
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    minimumTlsVersion: '1.2'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
        principalId: '<principalId>'
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
      "value": "crewaf001"
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
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "minimumTlsVersion": {
      "value": "1.2"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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
          "principalId": "<principalId>",
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Redis Cache Enterprise resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-capacity) | int | The size of the Redis Enterprise Cluster. Defaults to 2. Valid values are (2, 4, 6, ...) for Enterprise SKUs and (3, 9, 15, ...) for Flash SKUs. |
| [`databases`](#parameter-databases) | array | The databases to create in the Redis Cache Enterprise Cluster. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | The geo-location where the resource lives. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | Requires clients to use a specified TLS version (or higher) to connect. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`skuName`](#parameter-skuname) | string | The type of Redis Enterprise Cluster to deploy. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | When true, the cluster will be deployed across availability zones. |

### Parameter: `capacity`

The size of the Redis Enterprise Cluster. Defaults to 2. Valid values are (2, 4, 6, ...) for Enterprise SKUs and (3, 9, 15, ...) for Flash SKUs.
- Required: No
- Type: int
- Default: `2`

### Parameter: `databases`

The databases to create in the Redis Cache Enterprise Cluster.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics. |

### Parameter: `diagnosticSettings.metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics.

- Required: Yes
- Type: string


### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The geo-location where the resource lives.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `minimumTlsVersion`

Requires clients to use a specified TLS version (or higher) to connect.
- Required: No
- Type: string
- Default: `'1.2'`
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
  ]
  ```

### Parameter: `name`

The name of the Redis Cache Enterprise resource.
- Required: Yes
- Type: string

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | No | array | Optional. Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | No | array | Optional. Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | No | string | Optional. The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | No | bool | Optional. Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | No | array | Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | No | string | Optional. The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | No | object | Optional. Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | No | array | Optional. Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | No | string | Optional. The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | No | string | Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | No | array | Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | No | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`service`](#parameter-privateendpointsservice) | No | string | Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | Yes | string | Required. Resource ID of the subnet where the endpoint needs to be created. |
| [`tags`](#parameter-privateendpointstags) | No | object | Optional. Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Optional. Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Optional. Custom DNS configurations.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | No | string | Required. Fqdn that resolves to private endpoint ip address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | Yes | array | Required. A list of private ip addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Required. Fqdn that resolves to private endpoint ip address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

Required. A list of private ip addresses of the private endpoint.

- Required: Yes
- Type: array


### Parameter: `privateEndpoints.customNetworkInterfaceName`

Optional. The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Optional. Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | Yes | string | Required. The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | Yes | object | Required. Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

Required. The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Required. Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | Yes | string | Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | Yes | string | Required. The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | Yes | string | Required. A private ip address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

Required. A private ip address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string



### Parameter: `privateEndpoints.location`

Optional. The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Optional. Specify the type of lock.

- Required: No
- Type: object

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Optional. Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

Optional. The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.roleAssignments`

Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

### Parameter: `privateEndpoints.service`

Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: No
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Required. Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.tags`

Optional. Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `skuName`

The type of Redis Enterprise Cluster to deploy.
- Required: No
- Type: string
- Default: `'Enterprise_E10'`
- Allowed:
  ```Bicep
  [
    'Enterprise_E10'
    'Enterprise_E100'
    'Enterprise_E20'
    'Enterprise_E50'
    'EnterpriseFlash_F1500'
    'EnterpriseFlash_F300'
    'EnterpriseFlash_F700'
  ]
  ```

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `zoneRedundant`

When true, the cluster will be deployed across availability zones.
- Required: No
- Type: bool
- Default: `True`


## Outputs

| Output | Type | Description |
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
| `modules/network/private-endpoint` | Local reference |
