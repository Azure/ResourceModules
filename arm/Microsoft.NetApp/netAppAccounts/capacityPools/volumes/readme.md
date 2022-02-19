# Azure NetApp Files Capacity Pool Volumes `[Microsoft.NetApp/netAppAccounts/capacityPools/volumes]`

This template deploys volumes in a capacity pool of an Azure NetApp files.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `capacityPoolName` | string |  |  | Required. The name of the capacity pool. |
| `creationToken` | string | `[parameters('name')]` |  | Optional. A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `exportPolicyRules` | array | `[]` |  | Optional. Export policy rules. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location of the pool volume. |
| `name` | string |  |  | Required. The name of the pool volume. |
| `netAppAccountName` | string |  |  | Required. The name of the NetApp account. |
| `protocolTypes` | array | `[]` |  | Optional. Set of protocol types. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `serviceLevel` | string | `Standard` | `[Premium, Standard, StandardZRS, Ultra]` | Optional. The pool service level. Must match the one of the parent capacity pool. |
| `subnetResourceId` | string |  |  | Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| `usageThreshold` | int |  |  | Required. Maximum storage quota allowed for a file system in bytes. |

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
| `name` | string | The name of the Volume. |
| `resourceGroupName` | string | The name of the Resource Group the Volume was created in. |
| `resourceId` | string | The Resource ID of the Volume. |

## Template references

- [Netappaccounts/Capacitypools/Volumes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools/volumes)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
