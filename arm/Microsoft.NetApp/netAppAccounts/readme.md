# Azure NetApp Files `[Microsoft.NetApp/netAppAccounts]`

This template deploys Azure NetApp Files.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.NetApp/netAppAccounts` | 2021-04-01 |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | 2021-06-01 |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | 2021-06-01 |

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
| `domainJoinPassword` | secureString | `''` |  | Required if domainName is specified. Password of the user specified in domainJoinUser parameter |
| `domainJoinUser` | string | `''` |  | Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain. |
| `domainName` | string | `''` |  | Fully Qualified Active Directory DNS Domain Name (e.g. 'contoso.com') |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `smbServerNamePrefix` | string | `''` |  | Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes |
| `tags` | object | `{object}` |  | Tags for all resources. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the NetApp account. |
| `resourceGroupName` | string | The name of the Resource Group the NetApp account was created in. |
| `resourceId` | string | The Resource ID of the NetApp account. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Netappaccounts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-04-01/netAppAccounts)
- [Netappaccounts/Capacitypools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools)
- [Netappaccounts/Capacitypools/Volumes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools/volumes)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
