# Authorization Locks (Subscription scope) `[Microsoft.Authorization/locks]`

This module deploys an Authorization Lock at a Subscription scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-level) | string | Set lock level. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`name`](#parameter-name) | string | The name of the lock. |
| [`notes`](#parameter-notes) | string | The decription attached to the lock. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `level`

Set lock level.
- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'ReadOnly'
  ]
  ```

### Parameter: `name`

The name of the lock.
- Required: No
- Type: string
- Default: `[format('{0}-lock', parameters('level'))]`

### Parameter: `notes`

The decription attached to the lock.
- Required: No
- Type: string
- Default: `[if(equals(parameters('level'), 'CanNotDelete'), 'Cannot delete resource or child resources.', 'Cannot modify the resource or child resources.')]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lock. |
| `resourceId` | string | The resource ID of the lock. |
| `scope` | string | The scope this lock applies to. |
| `subscriptionName` | string | The subscription name the lock was deployed into. |

## Cross-referenced modules

_None_
