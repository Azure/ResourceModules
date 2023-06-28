# DocumentDB Database Accounts `[Microsoft.DocumentDB/databaseAccounts]`

This module deploys a DocumentDB Database Account.

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
| `Microsoft.DocumentDB/databaseAccounts` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `locations` | array | Locations enabled for the Cosmos DB account. |
| `name` | string | Name of the Database Account. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automaticFailover` | bool | `True` |  | Enable automatic failover for regions. |
| `backupIntervalInMinutes` | int | `240` |  | An integer representing the interval in minutes between two backups. Only applies to periodic backup type. |
| `backupPolicyContinuousTier` | string | `'Continuous30Days'` | `[Continuous30Days, Continuous7Days]` | Configuration values for continuous mode backup. |
| `backupPolicyType` | string | `'Continuous'` | `[Continuous, Periodic]` | Describes the mode of backups. |
| `backupRetentionIntervalInHours` | int | `8` |  | An integer representing the time (in hours) that each backup is retained. Only applies to periodic backup type. |
| `backupStorageRedundancy` | string | `'Local'` | `[Geo, Local, Zone]` | Enum to indicate type of backup residency. Only applies to periodic backup type. |
| `capabilitiesToAdd` | array | `[]` | `[DisableRateLimitingResponses, EnableCassandra, EnableGremlin, EnableMongo, EnableServerless, EnableTable]` | List of Cosmos DB capabilities for the account. |
| `databaseAccountOfferType` | string | `'Standard'` | `[Standard]` | The offer type for the Cosmos DB database account. |
| `defaultConsistencyLevel` | string | `'Session'` | `[BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong]` | The default consistency level of the Cosmos DB account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, CassandraRequests, ControlPlaneRequests, DataPlaneRequests, GremlinRequests, MongoRequests, PartitionKeyRUConsumption, PartitionKeyStatistics, QueryRuntimeStatistics, TableApiRequests]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Requests]` | `[Requests]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableFreeTier` | bool | `False` |  | Flag to indicate whether Free Tier is enabled. |
| `gremlinDatabases` | _[gremlinDatabases](gremlin-databases/README.md)_ array | `[]` |  | Gremlin Databases configurations. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxIntervalInSeconds` | int | `300` |  | Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400. |
| `maxStalenessPrefix` | int | `100000` |  | Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000. |
| `mongodbDatabases` | _[mongodbDatabases](mongodb-databases/README.md)_ array | `[]` |  | MongoDB Databases configurations. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serverVersion` | string | `'4.2'` | `[3.2, 3.6, 4.0, 4.2]` | Specifies the MongoDB server version to use. |
| `sqlDatabases` | _[sqlDatabases](sql-databases/README.md)_ array | `[]` |  | SQL Databases configurations. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the Database Account resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


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

### Parameter Usage: `locations`

<details>

<summary>Parameter JSON format</summary>

```json
"locations": {
    "value": [
        {
            "failoverPriority": 1,
            "locationName": "East US",
            "isZoneRedundant": false
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
locations: [
    {
        failoverPriority: 1
        locationName: 'East US'
        isZoneRedundant: false
    }
]
```

</details>
<p>

### Parameter Usage: `sqlDatabases`

<details>

<summary>Parameter JSON format</summary>

```json
"sqlDatabases": {
    "value": [
        {
            "name": "sxx-az-sql-x-001",
            "containers": [
                "container-001",
                "container-002"
            ]
        },
        {
            "name": "sxx-az-sql-x-002",
            "containers": []
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
sqlDatabases: {
    value: [
        {
            name: 'sxx-az-sql-x-001'
            containers: [
                'container-001'
                'container-002'
            ]
        }
        {
            name: 'sxx-az-sql-x-002'
            containers: []
        }
    ]
}
```

</details>
<p>

### Parameter Usage: `mongodbDatabases`

<details>

<summary>Parameter JSON format</summary>

```json
"mongodbDatabases": {
    "value": [
        {
            "name": "sxx-az-mdb-x-001",
            "collections": [
                <...>
            ]
        },
        {
            "name": "sxx-az-mdb-x-002",
            "collections": [
                <...>
            ]
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
mongodbDatabases: [
    {
        name: 'sxx-az-mdb-x-001'
        collections: [
            <...>
        ]
    }
    {
        name: 'sxx-az-mdb-x-002'
        collections: [
            <...>
        ]
    }
]
```

</details>
<p>

Please reference the documentation for [mongodbDatabases](./mongodb-databases/README.md)

### Parameter Usage: `gremlinDatabases`

<details>

<summary>Parameter JSON format</summary>

```json
"mongodbDatabases": {
  "value": [
    {
      "name": "graphDb01",
      "graphs": [
        {
          "name": "graph01",
          "automaticIndexing": true,
          "partitionKeyPaths": [
            "/name"
          ]
        },
        {
          "name": "graph02",
          "automaticIndexing": true,
          "partitionKeyPaths": [
            "/name"
          ]
        }
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
gremlinDatabases: [
  {
    name: 'graphDb01'
    graphs: [
      {
        name: 'graph01'
        automaticIndexing: true
        partitionKeyPaths: [
          '/name'
        ]
      }
      {
        name: 'graph02'
        automaticIndexing: true
        partitionKeyPaths: [
          '/name'
        ]
      }
    ]
  }
]
```

</details>
<p>

Please reference the documentation for [gremlinDatabases](./gremlin-databases/README.md)

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to 'ServicePrincipal'. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
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
        roleDefinitionIdOrName: 'Desktop Virtualization User'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: 'Reader'
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
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the database account. |
| `resourceGroupName` | string | The name of the resource group the database account was created in. |
| `resourceId` | string | The resource ID of the database account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Gremlindb</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './document-db/database-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dddagrm'
  params: {
    // Required parameters
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: 'West Europe'
      }
      {
        failoverPriority: 1
        isZoneRedundant: false
        locationName: 'North Europe'
      }
    ]
    name: '<<namePrefix>>dddagrm002'
    // Non-required parameters
    capabilitiesToAdd: [
      'EnableGremlin'
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gremlinDatabases: [
      {
        graphs: [
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'car_collection'
            partitionKeyPaths: [
              '/car_id'
            ]
          }
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'truck_collection'
            partitionKeyPaths: [
              '/truck_id'
            ]
          }
        ]
        name: '<<namePrefix>>-gdb-dddagrm-001'
      }
      {
        collections: [
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'bike_collection'
            partitionKeyPaths: [
              '/bike_id'
            ]
          }
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'bicycle_collection'
            partitionKeyPaths: [
              '/bicycle_id'
            ]
          }
        ]
        name: '<<namePrefix>>-gdb-dddagrm-002'
      }
    ]
    location: '<location>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
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
    "locations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": false,
          "locationName": "West Europe"
        },
        {
          "failoverPriority": 1,
          "isZoneRedundant": false,
          "locationName": "North Europe"
        }
      ]
    },
    "name": {
      "value": "<<namePrefix>>dddagrm002"
    },
    // Non-required parameters
    "capabilitiesToAdd": {
      "value": [
        "EnableGremlin"
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
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
    "gremlinDatabases": {
      "value": [
        {
          "graphs": [
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "car_collection",
              "partitionKeyPaths": [
                "/car_id"
              ]
            },
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "truck_collection",
              "partitionKeyPaths": [
                "/truck_id"
              ]
            }
          ],
          "name": "<<namePrefix>>-gdb-dddagrm-001"
        },
        {
          "collections": [
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "bike_collection",
              "partitionKeyPaths": [
                "/bike_id"
              ]
            },
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "bicycle_collection",
              "partitionKeyPaths": [
                "/bicycle_id"
              ]
            }
          ],
          "name": "<<namePrefix>>-gdb-dddagrm-002"
        }
      ]
    },
    "location": {
      "value": "<location>"
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
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Mongodb</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './document-db/database-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dddamng'
  params: {
    // Required parameters
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: 'West Europe'
      }
      {
        failoverPriority: 1
        isZoneRedundant: false
        locationName: 'North Europe'
      }
    ]
    name: '<<namePrefix>>dddamng001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    mongodbDatabases: [
      {
        collections: [
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'car_id'
                    'car_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'car_collection'
            shardKey: {
              car_id: 'Hash'
            }
          }
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'truck_id'
                    'truck_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'truck_collection'
            shardKey: {
              truck_id: 'Hash'
            }
          }
        ]
        name: '<<namePrefix>>-mdb-dddamng-001'
      }
      {
        collections: [
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'bike_id'
                    'bike_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'bike_collection'
            shardKey: {
              bike_id: 'Hash'
            }
          }
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'bicycle_id'
                    'bicycle_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'bicycle_collection'
            shardKey: {
              bicycle_id: 'Hash'
            }
          }
        ]
        name: '<<namePrefix>>-mdb-dddamng-002'
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
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
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
    "locations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": false,
          "locationName": "West Europe"
        },
        {
          "failoverPriority": 1,
          "isZoneRedundant": false,
          "locationName": "North Europe"
        }
      ]
    },
    "name": {
      "value": "<<namePrefix>>dddamng001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
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
    "location": {
      "value": "<location>"
    },
    "mongodbDatabases": {
      "value": [
        {
          "collections": [
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "car_id",
                      "car_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "car_collection",
              "shardKey": {
                "car_id": "Hash"
              }
            },
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "truck_id",
                      "truck_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "truck_collection",
              "shardKey": {
                "truck_id": "Hash"
              }
            }
          ],
          "name": "<<namePrefix>>-mdb-dddamng-001"
        },
        {
          "collections": [
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "bike_id",
                      "bike_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "bike_collection",
              "shardKey": {
                "bike_id": "Hash"
              }
            },
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "bicycle_id",
                      "bicycle_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "bicycle_collection",
              "shardKey": {
                "bicycle_id": "Hash"
              }
            }
          ],
          "name": "<<namePrefix>>-mdb-dddamng-002"
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
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Plain</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './document-db/database-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dddapln'
  params: {
    // Required parameters
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: 'West Europe'
      }
      {
        failoverPriority: 1
        isZoneRedundant: false
        locationName: 'North Europe'
      }
    ]
    name: '<<namePrefix>>dddapln001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
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
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
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
    "locations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": false,
          "locationName": "West Europe"
        },
        {
          "failoverPriority": 1,
          "isZoneRedundant": false,
          "locationName": "North Europe"
        }
      ]
    },
    "name": {
      "value": "<<namePrefix>>dddapln001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
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
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 4: Sqldb</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './document-db/database-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dddasql'
  params: {
    // Required parameters
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: 'West Europe'
      }
      {
        failoverPriority: 1
        isZoneRedundant: false
        locationName: 'North Europe'
      }
    ]
    name: '<<namePrefix>>dddasql001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sqlDatabases: [
      {
        containers: [
          {
            analyticalStorageTtl: 0
            conflictResolutionPolicy: {
              conflictResolutionPath: '/myCustomId'
              mode: 'LastWriterWins'
            }
            defaultTtl: 1000
            indexingPolicy: {
              automatic: true
            }
            kind: 'Hash'
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            throughput: 600
            uniqueKeyPolicyKeys: [
              {
                paths: [
                  '/firstName'
                ]
              }
              {
                paths: [
                  '/lastName'
                ]
              }
            ]
          }
        ]
        name: '<<namePrefix>>-sql-dddasql-001'
        throughput: 1000
      }
      {
        containers: []
        name: '<<namePrefix>>-sql-dddasql-002'
      }
      {
        autoscaleSettingsMaxThroughput: 1000
        containers: [
          {
            analyticalStorageTtl: 0
            autoscaleSettingsMaxThroughput: 1000
            conflictResolutionPolicy: {
              conflictResolutionPath: '/myCustomId'
              mode: 'LastWriterWins'
            }
            defaultTtl: 1000
            indexingPolicy: {
              automatic: true
            }
            kind: 'Hash'
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
            uniqueKeyPolicyKeys: [
              {
                paths: [
                  '/firstName'
                ]
              }
              {
                paths: [
                  '/lastName'
                ]
              }
            ]
          }
        ]
        name: '<<namePrefix>>-sql-dddasql-003'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
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
    "locations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": false,
          "locationName": "West Europe"
        },
        {
          "failoverPriority": 1,
          "isZoneRedundant": false,
          "locationName": "North Europe"
        }
      ]
    },
    "name": {
      "value": "<<namePrefix>>dddasql001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
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
    "location": {
      "value": "<location>"
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
    "sqlDatabases": {
      "value": [
        {
          "containers": [
            {
              "analyticalStorageTtl": 0,
              "conflictResolutionPolicy": {
                "conflictResolutionPath": "/myCustomId",
                "mode": "LastWriterWins"
              },
              "defaultTtl": 1000,
              "indexingPolicy": {
                "automatic": true
              },
              "kind": "Hash",
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ],
              "throughput": 600,
              "uniqueKeyPolicyKeys": [
                {
                  "paths": [
                    "/firstName"
                  ]
                },
                {
                  "paths": [
                    "/lastName"
                  ]
                }
              ]
            }
          ],
          "name": "<<namePrefix>>-sql-dddasql-001",
          "throughput": 1000
        },
        {
          "containers": [],
          "name": "<<namePrefix>>-sql-dddasql-002"
        },
        {
          "autoscaleSettingsMaxThroughput": 1000,
          "containers": [
            {
              "analyticalStorageTtl": 0,
              "autoscaleSettingsMaxThroughput": 1000,
              "conflictResolutionPolicy": {
                "conflictResolutionPath": "/myCustomId",
                "mode": "LastWriterWins"
              },
              "defaultTtl": 1000,
              "indexingPolicy": {
                "automatic": true
              },
              "kind": "Hash",
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ],
              "uniqueKeyPolicyKeys": [
                {
                  "paths": [
                    "/firstName"
                  ]
                },
                {
                  "paths": [
                    "/lastName"
                  ]
                }
              ]
            }
          ],
          "name": "<<namePrefix>>-sql-dddasql-003"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>
