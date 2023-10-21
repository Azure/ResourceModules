# Azure NetApp Files `[Microsoft.NetApp/netAppAccounts]`

This module deploys an Azure NetApp File.

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
| `Microsoft.NetApp/netAppAccounts` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/netAppAccounts) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/netAppAccounts/capacityPools/volumes) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/net-app.net-app-account:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Nfs3](#example-2-nfs3)
- [Nfs41](#example-3-nfs41)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br:bicep/modules/net-app.net-app-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nanaamin'
  params: {
    // Required parameters
    name: 'nanaamin001'
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
      "value": "nanaamin001"
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

### Example 2: _Nfs3_

<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br:bicep/modules/net-app.net-app-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nanaanfs3'
  params: {
    // Required parameters
    name: 'nanaanfs3001'
    // Non-required parameters
    capacityPools: [
      {
        name: 'nanaanfs3-cp-001'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: true
                nfsv41: false
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: 'nanaanfs3-vol-001'
            protocolTypes: [
              'NFSv3'
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
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
          }
          {
            name: 'nanaanfs3-vol-002'
            protocolTypes: [
              'NFSv3'
            ]
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
          }
        ]
      }
      {
        name: 'nanaanfs3-cp-002'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
      Contact: 'test.user@testcompany.com'
      CostCenter: '7890'
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      PurchaseOrder: '1234'
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
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
    "name": {
      "value": "nanaanfs3001"
    },
    // Non-required parameters
    "capacityPools": {
      "value": [
        {
          "name": "nanaanfs3-cp-001",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": [
            {
              "exportPolicyRules": [
                {
                  "allowedClients": "0.0.0.0/0",
                  "nfsv3": true,
                  "nfsv41": false,
                  "ruleIndex": 1,
                  "unixReadOnly": false,
                  "unixReadWrite": true
                }
              ],
              "name": "nanaanfs3-vol-001",
              "protocolTypes": [
                "NFSv3"
              ],
              "roleAssignments": [
                {
                  "principalIds": [
                    "<managedIdentityPrincipalId>"
                  ],
                  "principalType": "ServicePrincipal",
                  "roleDefinitionIdOrName": "Reader"
                }
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400
            },
            {
              "name": "nanaanfs3-vol-002",
              "protocolTypes": [
                "NFSv3"
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400
            }
          ]
        },
        {
          "name": "nanaanfs3-cp-002",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": []
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
        "Contact": "test.user@testcompany.com",
        "CostCenter": "7890",
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "PurchaseOrder": "1234",
        "Role": "DeploymentValidation",
        "ServiceName": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Nfs41_

<details>

<summary>via Bicep module</summary>

```bicep
module netAppAccount 'br:bicep/modules/net-app.net-app-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nanaanfs41'
  params: {
    // Required parameters
    name: 'nanaanfs41001'
    // Non-required parameters
    capacityPools: [
      {
        name: 'nanaanfs41-cp-001'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: false
                nfsv41: true
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: 'nanaanfs41-vol-001'
            protocolTypes: [
              'NFSv4.1'
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
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
          }
          {
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: false
                nfsv41: true
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: 'nanaanfs41-vol-002'
            protocolTypes: [
              'NFSv4.1'
            ]
            subnetResourceId: '<subnetResourceId>'
            usageThreshold: 107374182400
          }
        ]
      }
      {
        name: 'nanaanfs41-cp-002'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      Contact: 'test.user@testcompany.com'
      CostCenter: '7890'
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      PurchaseOrder: '1234'
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
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
    "name": {
      "value": "nanaanfs41001"
    },
    // Non-required parameters
    "capacityPools": {
      "value": [
        {
          "name": "nanaanfs41-cp-001",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": [
            {
              "exportPolicyRules": [
                {
                  "allowedClients": "0.0.0.0/0",
                  "nfsv3": false,
                  "nfsv41": true,
                  "ruleIndex": 1,
                  "unixReadOnly": false,
                  "unixReadWrite": true
                }
              ],
              "name": "nanaanfs41-vol-001",
              "protocolTypes": [
                "NFSv4.1"
              ],
              "roleAssignments": [
                {
                  "principalIds": [
                    "<managedIdentityPrincipalId>"
                  ],
                  "principalType": "ServicePrincipal",
                  "roleDefinitionIdOrName": "Reader"
                }
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400
            },
            {
              "exportPolicyRules": [
                {
                  "allowedClients": "0.0.0.0/0",
                  "nfsv3": false,
                  "nfsv41": true,
                  "ruleIndex": 1,
                  "unixReadOnly": false,
                  "unixReadWrite": true
                }
              ],
              "name": "nanaanfs41-vol-002",
              "protocolTypes": [
                "NFSv4.1"
              ],
              "subnetResourceId": "<subnetResourceId>",
              "usageThreshold": 107374182400
            }
          ]
        },
        {
          "name": "nanaanfs41-cp-002",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "serviceLevel": "Premium",
          "size": 4398046511104,
          "volumes": []
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
        "Contact": "test.user@testcompany.com",
        "CostCenter": "7890",
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "PurchaseOrder": "1234",
        "Role": "DeploymentValidation",
        "ServiceName": "DeploymentValidation"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the NetApp account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacityPools`](#parameter-capacitypools) | array | Capacity pools to create. |
| [`dnsServers`](#parameter-dnsservers) | string | Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed. |
| [`domainJoinOU`](#parameter-domainjoinou) | string | Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. 'OU=SecondLevel,OU=FirstLevel'). |
| [`domainJoinPassword`](#parameter-domainjoinpassword) | securestring | Required if domainName is specified. Password of the user specified in domainJoinUser parameter. |
| [`domainJoinUser`](#parameter-domainjoinuser) | string | Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain. |
| [`domainName`](#parameter-domainname) | string | Fully Qualified Active Directory DNS Domain Name (e.g. 'contoso.com'). |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`smbServerNamePrefix`](#parameter-smbservernameprefix) | string | Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `capacityPools`

Capacity pools to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `dnsServers`

Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed.
- Required: No
- Type: string
- Default: `''`

### Parameter: `domainJoinOU`

Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. 'OU=SecondLevel,OU=FirstLevel').
- Required: No
- Type: string
- Default: `''`

### Parameter: `domainJoinPassword`

Required if domainName is specified. Password of the user specified in domainJoinUser parameter.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `domainJoinUser`

Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain.
- Required: No
- Type: string
- Default: `''`

### Parameter: `domainName`

Fully Qualified Active Directory DNS Domain Name (e.g. 'contoso.com').
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
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

### Parameter: `name`

The name of the NetApp account.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `smbServerNamePrefix`

Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes.
- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags for all resources.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the NetApp account. |
| `resourceGroupName` | string | The name of the Resource Group the NetApp account was created in. |
| `resourceId` | string | The Resource ID of the NetApp account. |

## Cross-referenced modules

_None_
