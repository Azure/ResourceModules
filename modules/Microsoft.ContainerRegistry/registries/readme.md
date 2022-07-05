# Container Registries `[Microsoft.ContainerRegistry/registries]`

Azure Container Registry is a managed, private Docker registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your private Docker container images and related artifacts.

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
| `Microsoft.ContainerRegistry/registries` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2021-09-01/registries) |
| `Microsoft.ContainerRegistry/registries/replications` | [2021-12-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2021-12-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2021-12-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2021-12-01-preview/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of your Azure container registry. |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKUserAssignedIdentityResourceId` | string | `''` | User assigned identity to use when fetching the customer managed key. Note, CMK requires the 'acrSku' to be 'Premium'. Required if 'cMKKeyName' is not empty. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `acrAdminUserEnabled` | bool | `False` |  | Enable admin user that have push / pull permission to the registry. |
| `acrSku` | string | `'Basic'` | `[Basic, Premium, Standard]` | Tier of your Azure container registry. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. Note, CMK requires the 'acrSku' to be 'Premium'. |
| `cMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. Note, CMK requires the 'acrSku' to be 'Premium'. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `dataEndpointEnabled` | bool | `False` |  | Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[ContainerRegistryRepositoryEvents, ContainerRegistryLoginEvents]` | `[ContainerRegistryRepositoryEvents, ContainerRegistryLoginEvents]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `exportPolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | The value that indicates whether the export policy is enabled or not. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `networkRuleBypassOptions` | string | `'AzureServices'` |  | Whether to allow trusted Azure services to access a network restricted registry. Not relevant in case of public access. - AzureServices or None. |
| `networkRuleSetDefaultAction` | string | `'Deny'` | `[Allow, Deny]` | The default action of allow or deny when no other rules match. |
| `networkRuleSetIpRules` | array | `[]` |  | The IP ACL rules. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | Whether or not public network access is allowed for the container registry. - Enabled or Disabled. |
| `quarantinePolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | The value that indicates whether the quarantine policy is enabled or not. |
| `replications` | _[replications](replications/readme.md)_ array | `[]` |  | All replications to create. |
| `retentionPolicyDays` | int | `15` |  | The number of days to retain an untagged manifest after which it gets purged. |
| `retentionPolicyStatus` | string | `'enabled'` | `[disabled, enabled]` | The value that indicates whether the retention policy is enabled or not. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `trustPolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | The value that indicates whether the trust policy is enabled or not. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `webhooks` | _[webhooks](webhooks/readme.md)_ array | `[]` |  | All webhooks to create. |
| `zoneRedundancy` | string | `'Disabled'` | `[Disabled, Enabled]` | Whether or not zone redundancy is enabled for this container registry. |


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

### Parameter Usage: `imageRegistryCredentials`

The image registry credentials by which the container group is created from.

<details>

<summary>Parameter JSON format</summary>

```json
"acrName": {
    "value": {
        "server": "acrx001",
    }
},
"acrAdminUserEnabled": {
    "value": false
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
acrName: {
    server: 'acrx001'
}
acrAdminUserEnabled: false
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
| `loginServer` | string | The reference to the Azure container registry. |
| `name` | string | The Name of the Azure container registry. |
| `resourceGroupName` | string | The name of the Azure container registry. |
| `resourceId` | string | The resource ID of the Azure container registry. |
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
            "value": "<<namePrefix>>azacrencr001"
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "publicNetworkAccess": {
            "value": "Disabled"
        },
        "acrSku": {
            "value": "Premium"
        },
        "cMKUserAssignedIdentityResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
        },
        "cMKKeyVaultResourceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002"
        },
        "cMKKeyName": {
            "value": "keyEncryptionKey"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module registries './Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-registries'
  params: {
    name: '<<namePrefix>>azacrencr001'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    publicNetworkAccess: 'Disabled'
    acrSku: 'Premium'
    cMKUserAssignedIdentityResourceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    cMKKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002'
    cMKKeyName: 'keyEncryptionKey'
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
            "value": "<<namePrefix>>azacrmin001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module registries './Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-registries'
  params: {
    name: '<<namePrefix>>azacrmin001'
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
            "value": "<<namePrefix>>azacrx001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "acrAdminUserEnabled": {
            "value": false
        },
        "acrSku": {
            "value": "Premium"
        },
        "exportPolicyStatus": {
            "value": "enabled"
        },
        "quarantinePolicyStatus": {
            "value": "enabled"
        },
        "trustPolicyStatus": {
            "value": "enabled"
        },
        "replications": {
            "value": [
                {
                    "name": "northeurope",
                    "location": "northeurope"
                }
            ]
        },
        "webhooks": {
            "value": [
                {
                    "name": "<<namePrefix>>azacrx001webhook",
                    "serviceUri": "https://www.contoso.com/webhook"
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
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "publicNetworkAccess": {
            "value": "Disabled"
        },
        "privateEndpoints": {
            "value": [
                {
                    "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints",
                    "service": "registry"
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
module registries './Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-registries'
  params: {
    name: '<<namePrefix>>azacrx001'
    lock: 'CanNotDelete'
    acrAdminUserEnabled: false
    acrSku: 'Premium'
    exportPolicyStatus: 'enabled'
    quarantinePolicyStatus: 'enabled'
    trustPolicyStatus: 'enabled'
    replications: [
      {
        name: 'northeurope'
        location: 'northeurope'
      }
    ]
    webhooks: [
      {
        name: '<<namePrefix>>azacrx001webhook'
        serviceUri: 'https://www.contoso.com/webhook'
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
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
        service: 'registry'
      }
    ]
  }
}
```

</details>
<p>
