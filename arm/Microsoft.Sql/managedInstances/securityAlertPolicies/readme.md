# SQL Managed Instance Security Alert Policy `[Microsoft.Sql/managedInstances/securityAlertPolicies]`

This module deploys a security alert policy for a SQL managed instance.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | 2017-03-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `emailAccountAdmins` | bool |  |  | Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| `managedInstanceName` | string |  |  | Required. Name of the SQL managed instance. |
| `name` | string |  |  | Required. The name of the security alert policy |
| `state` | string | `Disabled` | `[Enabled, Disabled]` | Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `securityAlertPolicyName` | string | The name of the deployed security alert policy |
| `securityAlertPolicyResourceGroupName` | string | The resource group of the deployed security alert policy |
| `securityAlertPolicyResourceId` | string | The resource ID of the deployed security alert policy |

## Template references

- [Managedinstances/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/securityAlertPolicies)
