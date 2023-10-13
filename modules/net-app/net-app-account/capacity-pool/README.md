# Azure NetApp Files Capacity Pools `[Microsoft.NetApp/netAppAccounts/capacityPools]`

This module deploys an Azure NetApp Files Capacity Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the capacity pool. |
| `size` | int | Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104). |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `netAppAccountName` | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `coolAccess` | bool | `False` |  | If enabled (true) the pool can contain cool Access enabled volumes. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `encryptionType` | string | `'Single'` | `[Double, Single]` | Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool. |
| `location` | string | `[resourceGroup().location]` |  | Location of the pool volume. |
| `qosType` | string | `'Auto'` | `[Auto, Manual]` | The qos type of the pool. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serviceLevel` | string | `'Standard'` | `[Premium, Standard, StandardZRS, Ultra]` | The pool service level. |
| `tags` | object | `{object}` |  | Tags for all resources. |
| `volumes` | array | `[]` |  | List of volumnes to create in the capacity pool. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Capacity Pool. |
| `resourceGroupName` | string | The name of the Resource Group the Capacity Pool was created in. |
| `resourceId` | string | The resource ID of the Capacity Pool. |

## Cross-referenced modules

_None_
