# AzureNetAppFilesCapacitypools `[Microsoft.NetApp/netAppAccounts/capacityPools]`

This template deploys capacity pools in an Azure NetApp Files.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | 2021-06-01 |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `coolAccess` | bool |  |  | Optional. If enabled (true) the pool can contain cool Access enabled volumes. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location of the pool volume. |
| `name` | string |  |  | Required. The name of the capacity pool. |
| `netAppAccountName` | string |  |  | Required. The name of the capacity pool. |
| `qosType` | string | `Auto` | `[Auto, Manual]` | Optional. The qos type of the pool. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `serviceLevel` | string | `Standard` | `[Premium, Standard, StandardZRS, Ultra]` | Optional. The pool service level. |
| `size` | int |  |  | Required. Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104). |
| `tags` | object | `{object}` |  | Optional. Tags for all resources. |
| `volumes` | _[volumes](volumes/readme.md)_ array | `[]` |  | Optional. List of volumnes to create in the capacity pool. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
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
            ]
        }
    ]
}
```
## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `capacityPoolName` | string | The name of the Capacity Pool. |
| `capacityPoolResourceGroup` | string | The name of the Resource Group the Capacity Pool was created in. |
| `capacityPoolResourceId` | string | The Resource Id of the Capacity Pool. |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Netappaccounts/Capacitypools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools)
- [Netappaccounts/Capacitypools/Volumes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools/volumes)
