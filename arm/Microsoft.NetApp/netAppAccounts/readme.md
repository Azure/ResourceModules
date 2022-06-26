# Azure NetApp Files `[Microsoft.NetApp/netAppAccounts]`

This template deploys Azure NetApp Files.

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
| `Microsoft.NetApp/netAppAccounts` | [2021-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-04-01/netAppAccounts) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the NetApp account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `capacityPools` | _[capacityPools](capacityPools/readme.md)_ array | `[]` |  | Capacity pools to create. |
| `dnsServers` | string | `''` |  | Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed. |
| `domainJoinOU` | string | `''` |  | Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. 'OU=SecondLevel,OU=FirstLevel'). |
| `domainJoinPassword` | secureString | `''` |  | Required if domainName is specified. Password of the user specified in domainJoinUser parameter. |
| `domainJoinUser` | string | `''` |  | Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain. |
| `domainName` | string | `''` |  | Fully Qualified Active Directory DNS Domain Name (e.g. 'contoso.com'). |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `smbServerNamePrefix` | string | `''` |  | Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes. |
| `tags` | object | `{object}` |  | Tags for all resources. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the NetApp account. |
| `resourceGroupName` | string | The name of the Resource Group the NetApp account was created in. |
| `resourceId` | string | The Resource ID of the NetApp account. |

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
            "value": "<<namePrefix>>-az-anf-min-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccounts './Microsoft.NetApp/netAppAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-netAppAccounts'
  params: {
    name: '<<namePrefix>>-az-anf-min-001'
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
            "value": "<<namePrefix>>-az-anf-nfs3-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "capacityPools": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-anfcp-x-001",
                    "serviceLevel": "Premium",
                    "size": 4398046511104,
                    "volumes": [
                        {
                            "name": "anf3-vol01-nfsv3",
                            "usageThreshold": 107374182400,
                            "protocolTypes": [
                                "NFSv3"
                            ],
                            "exportPolicyRules": [
                                {
                                    "ruleIndex": 1,
                                    "unixReadOnly": false,
                                    "unixReadWrite": true,
                                    "nfsv3": true,
                                    "nfsv41": false,
                                    "allowedClients": "0.0.0.0/0"
                                }
                            ],
                            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004",
                            "roleAssignments": [
                                {
                                    "roleDefinitionIdOrName": "Reader",
                                    "principalIds": [
                                        "<<deploymentSpId>>"
                                    ]
                                }
                            ]
                        },
                        {
                            "name": "anf3-vol02-nfsv3",
                            "usageThreshold": 107374182400,
                            "protocolTypes": [
                                "NFSv3"
                            ],
                            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004"
                        }
                    ],
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ]
                },
                {
                    "name": "<<namePrefix>>-az-anfcp-x-002",
                    "serviceLevel": "Premium",
                    "size": 4398046511104,
                    "volumes": [],
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
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccounts './Microsoft.NetApp/netAppAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-netAppAccounts'
  params: {
    name: '<<namePrefix>>-az-anf-nfs3-001'
    lock: 'CanNotDelete'
    capacityPools: [
      {
        name: '<<namePrefix>>-az-anfcp-x-001'
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            name: 'anf3-vol01-nfsv3'
            usageThreshold: 107374182400
            protocolTypes: [
              'NFSv3'
            ]
            exportPolicyRules: [
              {
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
                nfsv3: true
                nfsv41: false
                allowedClients: '0.0.0.0/0'
              }
            ]
            subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004'
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Reader'
                principalIds: [
                  '<<deploymentSpId>>'
                ]
              }
            ]
          }
          {
            name: 'anf3-vol02-nfsv3'
            usageThreshold: 107374182400
            protocolTypes: [
              'NFSv3'
            ]
            subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004'
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
      }
      {
        name: '<<namePrefix>>-az-anfcp-x-002'
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
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
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Contact: 'test.user@testcompany.com'
      PurchaseOrder: '1234'
      CostCenter: '7890'
      ServiceName: 'DeploymentValidation'
      Role: 'DeploymentValidation'
    }
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
            "value": "<<namePrefix>>-az-anf-nfs41-001"
        },
        "capacityPools": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-anfcp-x-001",
                    "serviceLevel": "Premium",
                    "size": 4398046511104,
                    "volumes": [
                        {
                            "name": "anf4-vol01-nfsv41",
                            "usageThreshold": 107374182400,
                            "protocolTypes": [
                                "NFSv4.1"
                            ],
                            "exportPolicyRules": [
                                {
                                    "ruleIndex": 1,
                                    "unixReadOnly": false,
                                    "unixReadWrite": true,
                                    "nfsv3": false,
                                    "nfsv41": true,
                                    "allowedClients": "0.0.0.0/0"
                                }
                            ],
                            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004",
                            "roleAssignments": [
                                {
                                    "roleDefinitionIdOrName": "Reader",
                                    "principalIds": [
                                        "<<deploymentSpId>>"
                                    ]
                                }
                            ]
                        },
                        {
                            "name": "anf4-vol02-nfsv41",
                            "usageThreshold": 107374182400,
                            "protocolTypes": [
                                "NFSv4.1"
                            ],
                            "exportPolicyRules": [
                                {
                                    "ruleIndex": 1,
                                    "unixReadOnly": false,
                                    "unixReadWrite": true,
                                    "nfsv3": false,
                                    "nfsv41": true,
                                    "allowedClients": "0.0.0.0/0"
                                }
                            ],
                            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004"
                        }
                    ],
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ]
                },
                {
                    "name": "<<namePrefix>>-az-anfcp-x-002",
                    "serviceLevel": "Premium",
                    "size": 4398046511104,
                    "volumes": [],
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
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccounts './Microsoft.NetApp/netAppAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-netAppAccounts'
  params: {
    name: '<<namePrefix>>-az-anf-nfs41-001'
    capacityPools: [
      {
        name: '<<namePrefix>>-az-anfcp-x-001'
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            name: 'anf4-vol01-nfsv41'
            usageThreshold: 107374182400
            protocolTypes: [
              'NFSv4.1'
            ]
            exportPolicyRules: [
              {
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
                nfsv3: false
                nfsv41: true
                allowedClients: '0.0.0.0/0'
              }
            ]
            subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004'
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Reader'
                principalIds: [
                  '<<deploymentSpId>>'
                ]
              }
            ]
          }
          {
            name: 'anf4-vol02-nfsv41'
            usageThreshold: 107374182400
            protocolTypes: [
              'NFSv4.1'
            ]
            exportPolicyRules: [
              {
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
                nfsv3: false
                nfsv41: true
                allowedClients: '0.0.0.0/0'
              }
            ]
            subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-004'
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
      }
      {
        name: '<<namePrefix>>-az-anfcp-x-002'
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
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
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Contact: 'test.user@testcompany.com'
      PurchaseOrder: '1234'
      CostCenter: '7890'
      ServiceName: 'DeploymentValidation'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>
