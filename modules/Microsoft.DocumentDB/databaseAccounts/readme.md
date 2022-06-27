# DocumentDB Database Accounts `[Microsoft.DocumentDB/databaseAccounts]`

This module deploys a DocumentDB database account and its child resources.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts` | [2021-06-15](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2021-06-15](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

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
| `databaseAccountOfferType` | string | `'Standard'` | `[Standard]` | The offer type for the Cosmos DB database account. |
| `defaultConsistencyLevel` | string | `'Session'` | `[Eventual, ConsistentPrefix, Session, BoundedStaleness, Strong]` | The default consistency level of the Cosmos DB account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[DataPlaneRequests, MongoRequests, QueryRuntimeStatistics, PartitionKeyStatistics, PartitionKeyRUConsumption, ControlPlaneRequests, CassandraRequests, GremlinRequests, TableApiRequests]` | `[DataPlaneRequests, MongoRequests, QueryRuntimeStatistics, PartitionKeyStatistics, PartitionKeyRUConsumption, ControlPlaneRequests, CassandraRequests, GremlinRequests, TableApiRequests]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Requests]` | `[Requests]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxIntervalInSeconds` | int | `300` |  | Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400. |
| `maxStalenessPrefix` | int | `100000` |  | Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000. |
| `mongodbDatabases` | _[mongodbDatabases](mongodbDatabases/readme.md)_ array | `[]` |  | MongoDB Databases configurations. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serverVersion` | string | `'4.0'` | `[3.2, 3.6, 4.0]` | Specifies the MongoDB server version to use. |
| `sqlDatabases` | _[sqlDatabases](sqlDatabases/readme.md)_ array | `[]` |  | SQL Databases configurations. |
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

Please reference the documentation for [mongodbDatabases](./mongodbDatabases/readme.md)

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
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the database account. |
| `resourceGroupName` | string | The name of the resource group the database account was created in. |
| `resourceId` | string | The resource ID of the database account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-cdb-mongodb-001"
        },
        "location": {
            "value": "West Europe"
        },
        "locations": {
            "value": [
                {
                    "locationName": "West Europe",
                    "failoverPriority": 0,
                    "isZoneRedundant": false
                },
                {
                    "locationName": "North Europe",
                    "failoverPriority": 1,
                    "isZoneRedundant": false
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "mongodbDatabases": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-mdb-x-001",
                    "collections": [
                        {
                            "name": "car_collection",
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
                            "shardKey": {
                                "car_id": "Hash"
                            }
                        },
                        {
                            "name": "truck_collection",
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
                            "shardKey": {
                                "truck_id": "Hash"
                            }
                        }
                    ]
                },
                {
                    "name": "<<namePrefix>>-az-mdb-x-002",
                    "collections": [
                        {
                            "name": "bike_collection",
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
                            "shardKey": {
                                "bike_id": "Hash"
                            }
                        },
                        {
                            "name": "bicycle_collection",
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
                            "shardKey": {
                                "bicycle_id": "Hash"
                            }
                        }
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "systemAssignedIdentity": {
            "value": true
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './Microsoft.DocumentDB/databaseAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-databaseAccounts'
  params: {
    name: '<<namePrefix>>-az-cdb-mongodb-001'
    location: 'West Europe'
    locations: [
      {
        locationName: 'West Europe'
        failoverPriority: 0
        isZoneRedundant: false
      }
      {
        locationName: 'North Europe'
        failoverPriority: 1
        isZoneRedundant: false
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    mongodbDatabases: [
      {
        name: '<<namePrefix>>-az-mdb-x-001'
        collections: [
          {
            name: 'car_collection'
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
            shardKey: {
              car_id: 'Hash'
            }
          }
          {
            name: 'truck_collection'
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
            shardKey: {
              truck_id: 'Hash'
            }
          }
        ]
      }
      {
        name: '<<namePrefix>>-az-mdb-x-002'
        collections: [
          {
            name: 'bike_collection'
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
            shardKey: {
              bike_id: 'Hash'
            }
          }
          {
            name: 'bicycle_collection'
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
            shardKey: {
              bicycle_id: 'Hash'
            }
          }
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    systemAssignedIdentity: true
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-cdb-plain-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "locations": {
            "value": [
                {
                    "locationName": "West Europe",
                    "failoverPriority": 0,
                    "isZoneRedundant": false
                },
                {
                    "locationName": "North Europe",
                    "failoverPriority": 1,
                    "isZoneRedundant": false
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './Microsoft.DocumentDB/databaseAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-databaseAccounts'
  params: {
    name: '<<namePrefix>>-az-cdb-plain-001'
    lock: 'CanNotDelete'
    locations: [
      {
        locationName: 'West Europe'
        failoverPriority: 0
        isZoneRedundant: false
      }
      {
        locationName: 'North Europe'
        failoverPriority: 1
        isZoneRedundant: false
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-cdb-sqldb-001"
        },
        "location": {
            "value": "West Europe"
        },
        "locations": {
            "value": [
                {
                    "locationName": "West Europe",
                    "failoverPriority": 0,
                    "isZoneRedundant": false
                },
                {
                    "locationName": "North Europe",
                    "failoverPriority": 1,
                    "isZoneRedundant": false
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "sqlDatabases": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-sql-x-001",
                    "containers": [
                        {
                            "name": "container-001",
                            "paths": [
                                "/myPartitionKey"
                            ],
                            "kind": "Hash"
                        }
                    ]
                },
                {
                    "name": "<<namePrefix>>-az-sql-x-002",
                    "containers": []
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccounts './Microsoft.DocumentDB/databaseAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-databaseAccounts'
  params: {
    name: '<<namePrefix>>-az-cdb-sqldb-001'
    location: 'West Europe'
    locations: [
      {
        locationName: 'West Europe'
        failoverPriority: 0
        isZoneRedundant: false
      }
      {
        locationName: 'North Europe'
        failoverPriority: 1
        isZoneRedundant: false
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    sqlDatabases: [
      {
        name: '<<namePrefix>>-az-sql-x-001'
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            kind: 'Hash'
          }
        ]
      }
      {
        name: '<<namePrefix>>-az-sql-x-002'
        containers: []
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
  }
}
```

</details>
<p>
