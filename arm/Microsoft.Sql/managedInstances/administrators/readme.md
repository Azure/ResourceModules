# SQL Managed Instances Administrator `[Microsoft.Sql/managedInstances/administrators]`

This module deploys an administrator for the SQL managed instance

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/administrators` | [2021-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/administrators) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `login` | string | Login name of the managed instance administrator. |
| `sid` | string | SID (object ID) of the managed instance administrator. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'ActiveDirectory'` | The name of the managed instance administrator. |
| `tenantId` | string | `''` | Tenant ID of the managed instance administrator. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance. |
| `resourceGroupName` | string | The resource group of the deployed managed instance. |
| `resourceId` | string | The resource ID of the deployed managed instance. |
