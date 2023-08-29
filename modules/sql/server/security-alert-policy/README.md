# Azure SQL Server Security Alert Policies `[Microsoft.Sql/servers/securityAlertPolicies]`

This module deploys an Azure SQL Server Security Alert Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/securityAlertPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Security Alert Policy. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverName` | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `disabledAlerts` | array | `[]` |  | Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action, Brute_Force. |
| `emailAccountAdmins` | bool | `False` |  | Specifies that the alert is sent to the account administrators. |
| `emailAddresses` | array | `[]` |  | Specifies an array of email addresses to which the alert is sent. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `retentionDays` | int | `0` |  | Specifies the number of days to keep in the Threat Detection audit logs. |
| `state` | string | `'Disabled'` | `[Disabled, Enabled]` | Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database. |
| `storageAccountAccessKey` | securestring | `''` |  | Specifies the identifier key of the Threat Detection audit storage account.. |
| `storageEndpoint` | string | `''` |  | Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy. |
| `resourceGroupName` | string | The resource group of the deployed security alert policy. |
| `resourceId` | string | The resource ID of the deployed security alert policy. |

## Cross-referenced modules

_None_
