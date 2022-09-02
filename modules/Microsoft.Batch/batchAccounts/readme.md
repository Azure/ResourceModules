# Batch BatchAccounts `[Microsoft.Batch/batchAccounts]`

This module deploys Batch BatchAccounts.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Batch/batchAccounts` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts) |
| `Microsoft.Batch/batchAccounts/applications` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/applications) |
| `Microsoft.Batch/batchAccounts/pools` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/pools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints/privateDnsZoneGroups) |

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
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `poolAllocationMode` | string | `'BatchService'` | `[BatchService, UserSubscription]` | The allocation mode for creating pools in the Batch account. Determines which quota will be used. |
| `pools` | _[pools](pools/readme.md)_ array | `[]` |  | A list of node pool configurations. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for operating on the resources in the Batch account. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `storageAccessIdentity` | string | `''` |  | The reference to a user assigned identity associated with the Batch pool which a compute node will use. |
| `storageAuthenticationMode` | string | `'StorageKeys'` | `[BatchAccountManagedIdentity, StorageKeys]` | The authentication mode which the Batch service will use to manage the auto-storage account. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>", // e.g. vault, registry, file, blob, queue, table etc.
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
                ]
            },
            "customDnsConfigs": [ // Optional
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
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>" // e.g. vault, registry, file, blob, queue, table etc.
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
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
        privateDnsZoneGroups: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
            ]
        }
        // Optional
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
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

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.
   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: App</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-BatchAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>azbaweux001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    // Non-required parameters
    applications: [
      {
        allowUpdates: true
        displayName: 'Hallo World App'
        name: 'halloworldapp'
      }
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
      "value": "<<namePrefix>>azbaweux001"
    },
    "storageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "allowUpdates": true,
          "displayName": "Hallo World App",
          "name": "halloworldapp"
        }
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
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-BatchAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>azbaweumin001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
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
      "value": "<<namePrefix>>azbaweumin001"
    },
    "storageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    }
  }
}
```

</details>
<p>

<h3>Example 3: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-BatchAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>azbaweux001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    lock: 'CanNotDelete'
    poolAllocationMode: 'BatchService'
    roleAssignments: [
      {
        principalIds: [
          '<<deploymentSpId>>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    storageAccessIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    storageAuthenticationMode: 'BatchAccountManagedIdentity'
    systemAssignedIdentity: true
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
      "value": "<<namePrefix>>azbaweux001"
    },
    "storageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
    },
    "diagnosticEventHubName": {
      "value": "adp-<<namePrefix>>-az-evh-x-001"
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
    "lock": {
      "value": "CanNotDelete"
    },
    "poolAllocationMode": {
      "value": "BatchService"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<<deploymentSpId>>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "storageAccessIdentity": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
    },
    "storageAuthenticationMode": {
      "value": "BatchAccountManagedIdentity"
    },
    "systemAssignedIdentity": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 4: Pool Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-BatchAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>azbaweux001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    // Non-required parameters
    pools: [
      {
        deploymentConfiguration: {
          virtualMachineConfiguration: {
            imageReference: {
              offer: 'windowsserver'
              publisher: 'microsoftwindowsserver'
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
        poolName: 'helloworld'
        scaleSettings: {
          fixedScale: {
            resizeTimeout: 'PT15M'
            targetDedicatedNodes: 1
            targetLowPriorityNodes: 1
          }
        }
        userAssignedIdentities: {
          '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        vmSize: 'Standard_D2S_v3'
      }
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
      "value": "<<namePrefix>>azbaweux001"
    },
    "storageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    // Non-required parameters
    "pools": {
      "value": [
        {
          "deploymentConfiguration": {
            "virtualMachineConfiguration": {
              "imageReference": {
                "offer": "windowsserver",
                "publisher": "microsoftwindowsserver",
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
          "poolName": "helloworld",
          "scaleSettings": {
            "fixedScale": {
              "resizeTimeout": "PT15M",
              "targetDedicatedNodes": 1,
              "targetLowPriorityNodes": 1
            }
          },
          "userAssignedIdentities": {
            "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
          },
          "vmSize": "Standard_D2S_v3"
        }
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 5: Pool</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module batchAccounts './Microsoft.Batch/batchAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-BatchAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>azbaweux001'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    // Non-required parameters
    pools: [
      {
        deploymentConfiguration: {
          virtualMachineConfiguration: {
            imageReference: {
              offer: 'windowsserver'
              publisher: 'microsoftwindowsserver'
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
        poolName: 'helloworld'
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
        userAssignedIdentities: {
          '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        vmSize: 'Standard_D2S_v3'
      }
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
      "value": "<<namePrefix>>azbaweux001"
    },
    "storageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    // Non-required parameters
    "pools": {
      "value": [
        {
          "deploymentConfiguration": {
            "virtualMachineConfiguration": {
              "imageReference": {
                "offer": "windowsserver",
                "publisher": "microsoftwindowsserver",
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
          "poolName": "helloworld",
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
          "userAssignedIdentities": {
            "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
          },
          "vmSize": "Standard_D2S_v3"
        }
      ]
    }
  }
}
```

</details>
<p>
