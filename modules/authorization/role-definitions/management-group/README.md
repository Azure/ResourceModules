# Role Definitions (Management Group scope) `[Microsoft.Authorization/roleDefinitions/managementGroup]`

This module deploys a Role Definition at a Management Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleDefinitions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `roleName` | string | Name of the custom RBAC role to be created. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `actions` | array | `[]` | List of allowed actions. |
| `assignableScopes` | array | `[]` | Role definition assignable scopes. If not provided, will use the current scope provided. |
| `description` | string | `''` | Description of the custom RBAC role to be created. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `managementGroupId` | string | `[managementGroup().name]` | The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| `notActions` | array | `[]` | List of denied actions. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition. |
| `resourceId` | string | The resource ID of the Role Definition. |
| `scope` | string | The scope this Role Definition applies to. |

## Cross-referenced modules

_None_
