# Role Assignments (Management Group scope) `[Microsoft.Authorization/roleAssignments]`

This module deploys a Role Assignment at a Management Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalid) | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | string | You can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-condition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. |
| [`conditionVersion`](#parameter-conditionversion) | string | Version of the condition. Currently accepted value is "2.0". |
| [`delegatedManagedIdentityResourceId`](#parameter-delegatedmanagedidentityresourceid) | string | ID of the delegated managed identity resource. |
| [`description`](#parameter-description) | string | The description of the role assignment. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `condition`

The conditions on the role assignment. This limits the resources it can be assigned to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `conditionVersion`

Version of the condition. Currently accepted value is "2.0".
- Required: No
- Type: string
- Default: `'2.0'`
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `delegatedManagedIdentityResourceId`

ID of the delegated managed identity resource.
- Required: No
- Type: string
- Default: `''`

### Parameter: `description`

The description of the role assignment.
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

Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `principalId`

The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).
- Required: Yes
- Type: string

### Parameter: `principalType`

The principal type of the assigned principal ID.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `roleDefinitionIdOrName`

You can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment. |
| `resourceId` | string | The resource ID of the Role Assignment. |
| `scope` | string | The scope this Role Assignment applies to. |

## Cross-referenced modules

_None_
