# SQL Managed Instance Security Alert Policy `[Microsoft.Sql/managedInstances/securityAlertPolicies]`

This module deploys a security alert policy for a SQL managed instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | 2017-03-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | Name of the SQL managed instance. |
| `name` | string | The name of the security alert policy |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `emailAccountAdmins` | bool | `False` |  | Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `state` | string | `'Disabled'` | `[Enabled, Disabled]` | Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy |
| `resourceGroupName` | string | The resource group of the deployed security alert policy |
| `resourceId` | string | The resource ID of the deployed security alert policy |

## Template references

- [Managedinstances/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/securityAlertPolicies)
