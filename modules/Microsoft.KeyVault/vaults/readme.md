# Key Vaults `[Microsoft.KeyVault/vaults]`

This module deploys a key vault and its child resources.

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
| `Microsoft.KeyVault/vaults` | [2021-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-11-01-preview/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2019-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2019-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accessPolicies` | _[accessPolicies](accessPolicies/readme.md)_ array | `[]` |  | Array of access policies object. |
| `createMode` | string | `'default'` |  | The vault's create mode to indicate whether the vault need to be recovered or not. - recover or default. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[AuditEvent, AzurePolicyEvaluationDetails]` | `[AuditEvent, AzurePolicyEvaluationDetails]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enablePurgeProtection` | bool | `False` |  | Provide 'true' to enable Key Vault's purge protection feature. |
| `enableRbacAuthorization` | bool | `False` |  | Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC. |
| `enableSoftDelete` | bool | `True` |  | Switch to enable/disable Key Vault's soft delete feature. |
| `enableVaultForDeployment` | bool | `True` | `[True, False]` | Specifies if the vault is enabled for deployment by script or compute. |
| `enableVaultForDiskEncryption` | bool | `True` | `[True, False]` | Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. |
| `enableVaultForTemplateDeployment` | bool | `True` | `[True, False]` | Specifies if the vault is enabled for a template deployment. |
| `keys` | _[keys](keys/readme.md)_ array | `[]` |  | All keys to create. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `name` | string | `''` |  | Name of the Key Vault. If no name is provided, then unique name will be created. |
| `networkAcls` | object | `{object}` |  | Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny. |
| `privateEndpoints` | array | `[]` |  | Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `'enabled'` | `[enabled, disabled]` | Property to specify whether the vault will accept traffic from public internet. If set to "disabled" all traffic except private endpoint traffic and that that originates from trusted services will be blocked. This will override the set firewall rules, meaning that even if the firewall rules are present we will not honor the rules. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `secrets` | secureObject | `{object}` |  | All secrets to create. |
| `softDeleteRetentionInDays` | int | `90` |  | softDelete data retention days. It accepts >=7 and <=90. |
| `tags` | object | `{object}` |  | Resource tags. |
| `vaultSku` | string | `'premium'` | `[premium, standard]` | Specifies the SKU for the vault. |

**Generated parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Do not provide a value! This date value is used to generate a SAS token to access the modules. |


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

### Parameter Usage: `networkAcls`

<details>

<summary>Parameter JSON format</summary>

```json
"networkAcls": {
    "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "virtualNetworkRules": [
            {
                "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001"
            }
        ],
        "ipRules": []
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkAcls: {
    bypass: 'AzureServices'
    defaultAction: 'Deny'
    virtualNetworkRules: [
        {
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        }
    ]
    ipRules: []
}
```

</details>
<p>

### Parameter Usage: `vNetId`

<details>

<summary>Parameter JSON format</summary>

```json
"vNetId": {
    "value": "/subscriptions/00000000/resourceGroups/resourceGroup"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
vNetId: '/subscriptions/00000000/resourceGroups/resourceGroup'
```

</details>
<p>

### Parameter Usage: `accessPolicies`

<details>

<summary>Parameter JSON format</summary>

```json
"accessPolicies": {
    "value": [
        {
            "tenantId": null, // Optional
            "applicationId": null, // Optional
            "objectId": null,
            "permissions": {
                "certificates": [
                    "All"
                ],
                "keys": [
                    "All"
                ],
                "secrets": [
                    "All"
                ]
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
accessPolicies: [
    {
        tenantId: null // Optional
        applicationId: null // Optional
        objectId: null
        permissions: {
            certificates: [
                'All'
            ]
            keys: [
                'All'
            ]
            secrets: [
                'All'
            ]
        }
    }
]
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the key vault. |
| `resourceGroupName` | string | The name of the resource group the key vault was created in. |
| `resourceId` | string | The resource ID of the key vault. |
| `uri` | string | The URI of the key vault. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {}
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module vaults './Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-vaults'
  params: {

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
            "value": "<<namePrefix>>-az-kv-x-002"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "softDeleteRetentionInDays": {
            "value": 7
        },
        "enableRbacAuthorization": {
            "value": false
        },
        "privateEndpoints": {
            "value": [
                {
                    "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints",
                    "service": "vault"
                }
            ]
        },
        "networkAcls": {
            "value": {
                "bypass": "AzureServices",
                "defaultAction": "Deny",
                "virtualNetworkRules": [
                    {
                        "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001",
                        "action": "Allow"
                    }
                ],
                "ipRules": []
            }
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
        "secrets": {
            "value": {
                "secureList": [
                    {
                        "name": "secretName",
                        "value": "secretValue",
                        "contentType": "Something",
                        "attributesExp": 1702648632,
                        "attributesNbf": 10000,
                        "roleAssignments": [
                            {
                                "roleDefinitionIdOrName": "Reader",
                                "principalIds": [
                                    "<<deploymentSpId>>"
                                ]
                            }
                        ]
                    }
                ]
            }
        },
        "keys": {
            "value": [
                {
                    "name": "keyName",
                    "attributesExp": 1702648632,
                    "attributesNbf": 10000,
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ]
                }
            ]
        },
        "accessPolicies": {
            "value": [
                {
                    "objectId": "<<deploymentSpId>>",
                    "permissions": {
                        "keys": [
                            "get",
                            "list",
                            "update"
                        ],
                        "secrets": [
                            "all"
                        ]
                    },
                    "tenantId": "<<tenantId>>"
                },
                {
                    "objectId": "<<deploymentSpId>>",
                    "permissions": {
                        "certificates": [
                            "backup",
                            "create",
                            "delete"
                        ],
                        "secrets": [
                            "all"
                        ]
                    }
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
module vaults './Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-vaults'
  params: {
    name: '<<namePrefix>>-az-kv-x-002'
    lock: 'CanNotDelete'
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    privateEndpoints: [
      {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
        service: 'vault'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
          action: 'Allow'
        }
      ]
      ipRules: []
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    secrets: {
      secureList: [
        {
          name: 'secretName'
          value: 'secretValue'
          contentType: 'Something'
          attributesExp: 1702648632
          attributesNbf: 10000
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                '<<deploymentSpId>>'
              ]
            }
          ]
        }
      ]
    }
    keys: [
      {
        name: 'keyName'
        attributesExp: 1702648632
        attributesNbf: 10000
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              '<<deploymentSpId>>'
            ]
          }
        ]
      }
    ]
    accessPolicies: [
      {
        objectId: '<<deploymentSpId>>'
        permissions: {
          keys: [
            'get'
            'list'
            'update'
          ]
          secrets: [
            'all'
          ]
        }
        tenantId: '<<tenantId>>'
      }
      {
        objectId: '<<deploymentSpId>>'
        permissions: {
          certificates: [
            'backup'
            'create'
            'delete'
          ]
          secrets: [
            'all'
          ]
        }
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
