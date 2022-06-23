# Batch Accounts `[Microsoft.Batch/batchAccounts]`

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Batch/batchAccounts` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts) |
| `Microsoft.Batch/batchAccounts/applications` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/applications) |
| `Microsoft.Batch/batchAccounts/pools` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/pools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Batch/batchAccounts` | 2022-01-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Batch. |
| `storageAccountId` | string | The resource ID of the storage account to be used for auto-storage account. |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `encryptionKeyIdentifier` | string | `''` | Full path to the versioned secret. Required if `encryptionKeySource` is set to `Microsoft.KeyVault` or `poolAllocationMode` is set to `UserSubscription`. |
| `keyVaultResourceId` | string | `''` | The resource ID of the Azure key vault associated with the Batch account. Required if `encryptionKeySource` is set to `Microsoft.KeyVault` or `poolAllocationMode` is set to `UserSubscription`. |
| `keyVaultUri` | string | `''` | The URL of the Azure key vault associated with the Batch account. Required if `encryptionKeySource` is set to `Microsoft.KeyVault` or `poolAllocationMode` is set to `UserSubscription`. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowedAuthenticationModes` | array | `[]` | `[AAD, SharedKey, TaskAuthenticationToken]` | List of allowed authentication modes for the Batch account that can be used to authenticate with the data plane. |
| `applications` | _[applications](applications/readme.md)_ array | `[]` |  | A list of application package definitions. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[ServiceLog]` | `[ServiceLog]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `encryptionKeySource` | string | `'Microsoft.Batch'` | `[Microsoft.Batch, Microsoft.KeyVault]` | Type of the key source. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `poolAllocationMode` | string | `'BatchService'` | `[BatchService, UserSubscription]` | The allocation mode for creating pools in the Batch account. Determines which quota will be used. |
| `pools` | _[pools](pools/readme.md)_ array | `[]` |  | A list of node pool configurations. |
| `publicNetworkAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for operating on the resources in the Batch account. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `storageAccessIdentity` | string | `''` |  | The reference to a user assigned identity associated with the Batch pool which a compute node will use. |
| `storageAuthenticationMode` | string | `'StorageKeys'` | `[BatchAccountManagedIdentity, StorageKeys]` | The authentication mode which the Batch service will use to manage the auto-storage account. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the batch account. |
| `resourceGroupName` | string | The resource group the batch account was deployed into. |
| `resourceId` | string | The resource ID of the batch account. |

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
            "value": "<<namePrefix>>azbaweumin001"
        },
        "storageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-batchAccounts'
  params: {
    name: '<<namePrefix>>azbaweumin001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
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
            "value": "<<namePrefix>>azbaweux001"
        },
        "lock": {
            "value": "CanNotDelete"
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
        "poolAllocationMode": {
            "value": "BatchService"
        },
        "storageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "storageAuthenticationMode": {
            "value": "BatchAccountManagedIdentity"
        },
        "storageAccessIdentity": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
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
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-batchAccounts'
  params: {
    name: '<<namePrefix>>azbaweux001'
    lock: 'CanNotDelete'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    poolAllocationMode: 'BatchService'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    systemAssignedIdentity: true
    storageAuthenticationMode: 'BatchAccountManagedIdentity'
    storageAccessIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
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
            "value": "<<namePrefix>>azbaweux001"
        },
        "storageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "pools": {
            "value": [
                {
                    "userAssignedIdentities": {
                        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
                    },
                    "poolName": "helloworld",
                    "deploymentConfiguration": {
                        "virtualMachineConfiguration": {
                            "imageReference": {
                                "publisher": "microsoftwindowsserver",
                                "offer": "windowsserver",
                                "sku": "2022-datacenter",
                                "version": "latest"
                            },
                            "nodeAgentSkuId": "batch.node.windows amd64"
                        }
                    },
                    "displayName": "hellotest",
                    "networkConfiguration": {
                        "dynamicVNetAssignmentScope": "None",
                        "publicIPAddressConfiguration": {
                            "provision": "BatchManaged"
                        }
                    },
                    "scaleSettings": {
                        "fixedScale": {
                            "resizeTimeout": "PT15M",
                            "targetDedicatedNodes": 1,
                            "targetLowPriorityNodes": 1
                        }
                    },
                    "vmSize": "Standard_D2S_v3"
                }
            ]
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-batchAccounts'
  params: {
    name: '<<namePrefix>>azbaweux001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    pools: [
      {
        userAssignedIdentities: {
          '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        poolName: 'helloworld'
        deploymentConfiguration: {
          virtualMachineConfiguration: {
            imageReference: {
              publisher: 'microsoftwindowsserver'
              offer: 'windowsserver'
              sku: '2022-datacenter'
              version: 'latest'
            }
            nodeAgentSkuId: 'batch.node.windows amd64'
          }
        }
        displayName: 'hellotest'
        networkConfiguration: {
          dynamicVNetAssignmentScope: 'None'
          publicIPAddressConfiguration: {
            provision: 'BatchManaged'
          }
        }
        scaleSettings: {
          fixedScale: {
            resizeTimeout: 'PT15M'
            targetDedicatedNodes: 1
            targetLowPriorityNodes: 1
          }
        }
        vmSize: 'Standard_D2S_v3'
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 4</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>azbaweux001"
        },
        "storageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "pools": {
            "value": [
                {
                    "batchAccountName": "<<namePrefix>>azbaweux001",
                    "poolName": "helloworld",
                    "userAssignedIdentities": {
                        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
                    },
                    "deploymentConfiguration": {
                        "virtualMachineConfiguration": {
                            "imageReference": {
                                "publisher": "microsoftwindowsserver",
                                "offer": "windowsserver",
                                "sku": "2022-datacenter",
                                "version": "latest"
                            },
                            "nodeAgentSkuId": "batch.node.windows amd64"
                        }
                    },
                    "displayName": "hellotest",
                    "interNodeCommunication": "Enabled",
                    "metadata": [
                        {
                            "name": "carmlTest",
                            "value": "helloworld"
                        }
                    ],
                    "networkConfiguration": {
                        "dynamicVNetAssignmentScope": "None",
                        "publicIPAddressConfiguration": {
                            "ipAddressIds": [],
                            "provision": "BatchManaged"
                        },
                        "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001"
                    },
                    "scaleSettings": {
                        "fixedScale": {
                            "resizeTimeout": "PT15M",
                            "targetDedicatedNodes": 1,
                            "targetLowPriorityNodes": 0
                        }
                    },
                    "startTask": {
                        "commandLine": "cmd /c ipconfig",
                        "maxTaskRetryCount": 4,
                        "waitForSuccess": false
                    },
                    "taskSchedulingPolicy": "Pack",
                    "taskSlotsPerNode": 1,
                    "userAccounts": [
                        {
                            "elevationLevel": "Admin",
                            "name": "carmladmin",
                            "password": "VeryGeheim!",
                            "windowsUserConfiguration": {
                                "loginMode": "Interactive"
                            }
                        }
                    ],
                    "vmSize": "Standard_D2S_v3"
                }
            ]
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-batchAccounts'
  params: {
    name: '<<namePrefix>>azbaweux001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    pools: [
      {
        batchAccountName: '<<namePrefix>>azbaweux001'
        poolName: 'helloworld'
        userAssignedIdentities: {
          '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        deploymentConfiguration: {
          virtualMachineConfiguration: {
            imageReference: {
              publisher: 'microsoftwindowsserver'
              offer: 'windowsserver'
              sku: '2022-datacenter'
              version: 'latest'
            }
            nodeAgentSkuId: 'batch.node.windows amd64'
          }
        }
        displayName: 'hellotest'
        interNodeCommunication: 'Enabled'
        metadata: [
          {
            name: 'carmlTest'
            value: 'helloworld'
          }
        ]
        networkConfiguration: {
          dynamicVNetAssignmentScope: 'None'
          publicIPAddressConfiguration: {
            ipAddressIds: []
            provision: 'BatchManaged'
          }
          subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
        }
        scaleSettings: {
          fixedScale: {
            resizeTimeout: 'PT15M'
            targetDedicatedNodes: 1
            targetLowPriorityNodes: 0
          }
        }
        startTask: {
          commandLine: 'cmd /c ipconfig'
          maxTaskRetryCount: 4
          waitForSuccess: false
        }
        taskSchedulingPolicy: 'Pack'
        taskSlotsPerNode: 1
        userAccounts: [
          {
            elevationLevel: 'Admin'
            name: 'carmladmin'
            password: 'VeryGeheim!'
            windowsUserConfiguration: {
              loginMode: 'Interactive'
            }
          }
        ]
        vmSize: 'Standard_D2S_v3'
      }
    ]
  }
}
```

</details>
<p>
