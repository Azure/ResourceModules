# Machine Learning Workspaces `[Microsoft.MachineLearningServices/workspaces]`

This module deploys a Machine Learning Services Workspace.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.MachineLearningServices/workspaces` | [2021-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2021-07-01/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-01-01-preview/workspaces/computes) |
| `Microsoft.Network/privateEndpoints` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `associatedApplicationInsightsResourceId` | string |  | The resource ID of the associated Application Insights. |
| `associatedKeyVaultResourceId` | string |  | The resource ID of the associated Key Vault. |
| `associatedStorageAccountResourceId` | string |  | The resource ID of the associated Storage Account. |
| `name` | string |  | The name of the machine learning workspace. |
| `sku` | string | `[Basic, Enterprise]` | Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace. |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `primaryUserAssignedIdentity` | string | `''` | The user assigned identity resource id that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled. |
| `systemAssignedIdentity` | bool | `False` | Enables system assigned managed identity on the resource. Required if `userAssignedIdentities` is not provided. |
| `userAssignedIdentities` | object | `{object}` | The ID(s) to assign to the resource. Required if `systemAssignedIdentity` is set to false. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowPublicAccessWhenBehindVnet` | bool | `False` |  | The flag to indicate whether to allow public access when behind VNet. |
| `associatedContainerRegistryResourceId` | string | `''` |  | The resource ID of the associated Container Registry. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `cMKUserAssignedIdentityResourceId` | string | `''` |  | User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first. |
| `computes` | _[computes](computes/readme.md)_ array | `[]` |  | Computes to create respectively attach to the workspace. |
| `description` | string | `''` |  | The description of this workspace. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[AmlComputeClusterEvent, AmlComputeClusterNodeEvent, AmlComputeJobEvent, AmlComputeCpuGpuUtilization, AmlRunStatusChangedEvent]` | `[AmlComputeClusterEvent, AmlComputeClusterNodeEvent, AmlComputeJobEvent, AmlComputeCpuGpuUtilization, AmlRunStatusChangedEvent]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `discoveryUrl` | string | `''` |  | URL for the discovery service to identify regional endpoints for machine learning experimentation services. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `hbiWorkspace` | bool | `False` |  | The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. |
| `imageBuildCompute` | string | `''` |  | The compute name for image build. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Enabled, Disabled]` | Whether requests from Public Network are allowed. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Resource tags. |


### Parameter Usage: `computes`

Array to specify the compute resources to create respectively attach.
In case you provide a resource id, it will attach the resource and ignore "properties". In this case "computeLocation", "sku", "systemAssignedIdentity", "userAssignedIdentities" as well as "tags" don't need to be provided respectively are being ignored.
Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML. I.e. for the first run set "deploy" to true, and after successful deployment to false.
For more information see https://docs.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep

<details>

<summary>Parameter JSON format</summary>

```json
"computes": {
    "value": [
        // Attach existing resources
        {
            "name": "DefaultAKS",
            "location": "westeurope",
            "description": "Default AKS Cluster",
            "disableLocalAuth": false,
            "deployCompute": true,
            "computeType": "AKS",
            "resourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx"
        },
        // Create new compute resource
        {
            "name": "DefaultCPU",
            "location": "westeurope",
            "computeLocation": "westeurope",
            "sku": "Basic",
            "systemAssignedIdentity": true,
            "userAssignedIdentities": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            },
            "description": "Default CPU Cluster",
            "disableLocalAuth": false,
            "computeType": "AmlCompute",
            "properties": {
                "enableNodePublicIp": true,
                "isolatedNetwork": false,
                "osType": "Linux",
                "remoteLoginPortPublicAccess": "Disabled",
                "scaleSettings": {
                    "maxNodeCount": 3,
                    "minNodeCount": 0,
                    "nodeIdleTimeBeforeScaleDown": "PT5M"
                },
                "vmPriority": "Dedicated",
                "vmSize": "STANDARD_DS11_V2"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
computes: [
    // Attach existing resources
    {
        name: 'DefaultAKS'
        location: 'westeurope'
        description: 'Default AKS Cluster'
        disableLocalAuth: false
        deployCompute: true
        computeType: 'AKS'
        resourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx'
    }
    // Create new compute resource
    {
        name: 'DefaultCPU'
        location: 'westeurope'
        computeLocation: 'westeurope'
        sku: 'Basic'
        systemAssignedIdentity: true
        userAssignedIdentities: {
            '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        computeType: 'AmlCompute'
        properties: {
            enableNodePublicIp: true
            isolatedNetwork: false
            osType: 'Linux'
            remoteLoginPortPublicAccess: 'Disabled'
            scaleSettings: {
                maxNodeCount: 3
                minNodeCount: 0
                nodeIdleTimeBeforeScaleDown: 'PT5M'
            }
            vmPriority: 'Dedicated'
            vmSize: 'STANDARD_DS11_V2'
        }
    }
]
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
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
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
        privateDnsZoneResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
            '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
        ]
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
| `name` | string | The name of the machine learning service. |
| `principalId` | string | The principal ID of the system assigned identity. |
| `resourceGroupName` | string | The resource group the machine learning service was deployed into. |
| `resourceId` | string | The resource ID of the machine learning service. |

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
            "value": "<<namePrefix>>-az-mls-encr-001"
        },
        "sku": {
            "value": "Basic"
        },
        "associatedStorageAccountResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "associatedKeyVaultResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
        },
        "associatedApplicationInsightsResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Insights/components/adp-<<namePrefix>>-az-appi-x-001"
        },
        "cMKUserAssignedIdentityResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
        },
        "cMKKeyName": {
            "value": "keyEncryptionKey"
        },
        "cMKKeyVaultResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002"
        },
        "systemAssignedIdentity": {
            "value": false // Must be false if `primaryUserAssignedIdentity` is provided
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "primaryUserAssignedIdentity": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
        },
        "privateEndpoints": {
            "value": [
                {
                    "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints",
                    "service": "amlworkspace"
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
module workspaces './Microsoft.MachineLearningServices/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-mls-encr-001'
    sku: 'Basic'
    associatedStorageAccountResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    associatedKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
    associatedApplicationInsightsResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Insights/components/adp-<<namePrefix>>-az-appi-x-001'
    cMKUserAssignedIdentityResourceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    cMKKeyName: 'keyEncryptionKey'
    cMKKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002'
    systemAssignedIdentity: false
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    primaryUserAssignedIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    privateEndpoints: [
      {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
        service: 'amlworkspace'
      }
    ]
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
            "value": "<<namePrefix>>-az-mls-min-001"
        },
        "sku": {
            "value": "Basic"
        },
        "associatedStorageAccountResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "associatedKeyVaultResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
        },
        "associatedApplicationInsightsResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Insights/components/adp-<<namePrefix>>-az-appi-x-001"
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
module workspaces './Microsoft.MachineLearningServices/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-mls-min-001'
    sku: 'Basic'
    associatedStorageAccountResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    associatedKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
    associatedApplicationInsightsResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Insights/components/adp-<<namePrefix>>-az-appi-x-001'
    systemAssignedIdentity: true
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
            "value": "<<namePrefix>>-az-mls-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "sku": {
            "value": "Basic"
        },
        "associatedStorageAccountResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "associatedKeyVaultResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
        },
        "associatedApplicationInsightsResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Insights/components/adp-<<namePrefix>>-az-appi-x-001"
        },
        "systemAssignedIdentity": {
            "value": false // Must be false if `primaryUserAssignedIdentity` is provided
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "description": {
            "value": "The cake is a lie."
        },
        "discoveryUrl": {
            "value": "http://example.com"
        },
        "imageBuildCompute": {
            "value": "testcompute"
        },
        "publicNetworkAccess": {
            "value": "Enabled"
        },
        "primaryUserAssignedIdentity": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
        },
        "computes": {
            "value": [
                {
                    "name": "DefaultCPU",
                    "location": "westeurope",
                    "computeLocation": "westeurope",
                    "sku": "Basic",
                    "systemAssignedIdentity": false,
                    "userAssignedIdentities": {
                        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
                    },
                    "description": "Default CPU Cluster",
                    "disableLocalAuth": false,
                    "computeType": "AmlCompute",
                    "properties": {
                        "enableNodePublicIp": true,
                        "isolatedNetwork": false,
                        "osType": "Linux",
                        "remoteLoginPortPublicAccess": "Disabled",
                        "scaleSettings": {
                            "maxNodeCount": 3,
                            "minNodeCount": 0,
                            "nodeIdleTimeBeforeScaleDown": "PT5M"
                        },
                        "vmPriority": "Dedicated",
                        "vmSize": "STANDARD_DS11_V2"
                    }
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
        },
        "privateEndpoints": {
            "value": [
                {
                    "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints",
                    "service": "amlworkspace"
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
module workspaces './Microsoft.MachineLearningServices/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-mls-x-001'
    lock: 'CanNotDelete'
    sku: 'Basic'
    associatedStorageAccountResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    associatedKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
    associatedApplicationInsightsResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Insights/components/adp-<<namePrefix>>-az-appi-x-001'
    systemAssignedIdentity: false
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    description: 'The cake is a lie.'
    discoveryUrl: 'http://example.com'
    imageBuildCompute: 'testcompute'
    publicNetworkAccess: 'Enabled'
    primaryUserAssignedIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    computes: [
      {
        name: 'DefaultCPU'
        location: 'westeurope'
        computeLocation: 'westeurope'
        sku: 'Basic'
        systemAssignedIdentity: false
        userAssignedIdentities: {
          '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        computeType: 'AmlCompute'
        properties: {
          enableNodePublicIp: true
          isolatedNetwork: false
          osType: 'Linux'
          remoteLoginPortPublicAccess: 'Disabled'
          scaleSettings: {
            maxNodeCount: 3
            minNodeCount: 0
            nodeIdleTimeBeforeScaleDown: 'PT5M'
          }
          vmPriority: 'Dedicated'
          vmSize: 'STANDARD_DS11_V2'
        }
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
    privateEndpoints: [
      {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
        service: 'amlworkspace'
      }
    ]
  }
}
```

</details>
<p>
