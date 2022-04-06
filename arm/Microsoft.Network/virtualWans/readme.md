# Virtual WANs `[Microsoft.Network/virtualWans]`

This template deploys a virtual WAN.

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
| `Microsoft.Network/virtualWans` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Virtual WAN. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowBranchToBranchTraffic` | bool | `False` |  | True if branch to branch traffic is allowed. |
| `allowVnetToVnetTraffic` | bool | `False` |  | True if VNET to VNET traffic is allowed.  |
| `disableVpnEncryption` | bool | `False` |  | VPN encryption to be disabled or not. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location where all resources will be created. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `type` | string | `'Standard'` | `[Standard, Basic]` | The type of the Virtual WAN. |


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
| `name` | string | The name of the virtual WAN |
| `resourceGroupName` | string | The resource group the virtual WAN was deployed into |
| `resourceId` | string | The resource ID of the virtual WAN |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Virtualwans](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualWans)
