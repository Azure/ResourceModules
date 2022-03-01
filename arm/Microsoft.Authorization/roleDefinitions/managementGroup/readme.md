# Role Definitions on Management Group level `[Microsoft.Authorization/roleDefinitions/managementGroup]`

With this module you can create role definitions on a management group level

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | 2018-01-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Optional. List of allowed actions. |
| `assignableScopes` | array | `[]` |  | Optional. Role definition assignable scopes. If not provided, will use the current scope provided. |
| `description` | string |  |  | Optional. Description of the custom RBAC role to be created. |
| `managementGroupId` | string | `[managementGroup().name]` |  | Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| `notActions` | array | `[]` |  | Optional. List of denied actions. |
| `roleName` | string |  |  | Required. Name of the custom RBAC role to be created. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition |
| `resourceId` | string | The resource ID of the Role Definition |
| `scope` | string | The scope this Role Definition applies to |

## Template references

- [Roledefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2018-01-01-preview/roleDefinitions)
