# Role Assignment on Resource Group level `[Microsoft.Authorization/roleAssignments/resourceGroup]`

With this module you can perform role assignments on a resource group level

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `condition` | string |  |  | Optional. The conditions on the role assignment. This limits the resources it can be assigned to |
| `conditionVersion` | string | `2.0` | `[2.0]` | Optional. Version of the condition. Currently accepted value is "2.0" |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `delegatedManagedIdentityResourceId` | string |  |  | Optional. ID of the delegated managed identity resource |
| `description` | string |  |  | Optional. Description of role assignment |
| `principalId` | string |  |  | Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity) |
| `principalType` | string |  | `[ServicePrincipal, Group, User, ForeignGroup, Device, ]` | Optional. The principal type of the assigned principal ID. |
| `resourceGroupName` | string | `[resourceGroup().name]` |  | Optional. Name of the Resource Group to assign the RBAC role to. If not provided, will use the current scope for deployment. |
| `roleDefinitionIdOrName` | string |  |  | Required. You can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `subscriptionId` | string | `[subscription().subscriptionId]` |  | Optional. Subscription ID of the subscription to assign the RBAC role to. If not provided, will use the current scope for deployment. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment |
| `resourceGroupName` | string | The name of the resource group the role assignment was applied at |
| `resourceId` | string | The scope this Role Assignment applies to |
| `scope` | string | The resource ID of the Role Assignment |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
