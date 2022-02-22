# Role Definitions on Resource Group level `[Microsoft.Authorization/roleDefinitions/resourceGroups]`

With this module you can create role definitions on a resource group level

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | 2018-01-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Optional. List of allowed actions. |
| `assignableScopes` | array | `[]` |  | Optional. Role definition assignable scopes. If not provided, will use the current scope provided. |
| `dataActions` | array | `[]` |  | Optional. List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes |
| `description` | string |  |  | Optional. Description of the custom RBAC role to be created. |
| `notActions` | array | `[]` |  | Optional. List of denied actions. |
| `notDataActions` | array | `[]` |  | Optional. List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes |
| `resourceGroupName` | string | `[resourceGroup().name]` |  | Optional. The name of the Resource Group where the Role Definition and Target Scope will be applied to. |
| `roleName` | string |  |  | Required. Name of the custom RBAC role to be created. |
| `subscriptionId` | string | `[subscription().subscriptionId]` |  | Optional. The subscription ID where the Role Definition and Target Scope will be applied to. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition |
| `resourceId` | string | The resource ID of the Role Definition |
| `scope` | string | The scope this Role Definition applies to |

## Template references

- [Roledefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2018-01-01-preview/roleDefinitions)
