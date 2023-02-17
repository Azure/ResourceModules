# SQL Managed Instance Security Alert Policy `[Microsoft.Sql/managedInstances/securityAlertPolicies]`

This module deploys a security alert policy for a SQL managed instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/managedInstances/securityAlertPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security alert policy. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `emailAccountAdmins` | bool | `False` |  | Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `state` | string | `'Disabled'` | `[Disabled, Enabled]` | Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy. |
| `resourceGroupName` | string | The resource group of the deployed security alert policy. |
| `resourceId` | string | The resource ID of the deployed security alert policy. |

## Cross-referenced modules

_None_
