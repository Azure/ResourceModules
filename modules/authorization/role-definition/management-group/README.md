# Role Definitions (Management Group scope) `[Microsoft.Authorization/roleDefinitions]`

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

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleName`](#parameter-rolename) | string | Name of the custom RBAC role to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | List of allowed actions. |
| [`assignableScopes`](#parameter-assignablescopes) | array | Role definition assignable scopes. If not provided, will use the current scope provided. |
| [`description`](#parameter-description) | string | Description of the custom RBAC role to be created. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| [`notActions`](#parameter-notactions) | array | List of denied actions. |

### Parameter: `actions`

List of allowed actions.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `assignableScopes`

Role definition assignable scopes. If not provided, will use the current scope provided.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `description`

Description of the custom RBAC role to be created.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `notActions`

List of denied actions.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleName`

Name of the custom RBAC role to be created.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition. |
| `resourceId` | string | The resource ID of the Role Definition. |
| `scope` | string | The scope this Role Definition applies to. |

## Cross-referenced modules

_None_
