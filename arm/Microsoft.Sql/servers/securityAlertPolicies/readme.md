# SQL Server Security Alert Policy `[Microsoft.Sql/servers/securityAlertPolicies]`

This module deploys an SQL Server Security Alert Policy.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/securityAlertPolicies` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `disabledAlerts` | array | `[]` |  | Optional. Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action, Brute_Force. |
| `emailAccountAdmins` | bool |  |  | Optional. Specifies that the alert is sent to the account administrators. |
| `emailAddresses` | array | `[]` |  | Optional. Specifies an array of email addresses to which the alert is sent. |
| `name` | string |  |  | Required. The name of the Security Alert Policy. |
| `retentionDays` | int |  |  | Optional. Specifies the number of days to keep in the Threat Detection audit logs. |
| `serverName` | string |  |  | Required. The Name of SQL Server |
| `state` | string | `Disabled` | `[Disabled, Enabled]` | Optional. Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database. |
| `storageAccountAccessKey` | secureString |  |  | Optional. Specifies the identifier key of the Threat Detection audit storage account.. |
| `storageEndpoint` | string |  |  | Optional. Specifies the blob storage endpoint (e.g. https://MyAccount.blob.core.windows.net). This blob storage will hold all Threat Detection audit logs. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `databaseId` | string | The resourceId of the deployed security alert policy |
| `databaseName` | string | The name of the deployed security alert policy |
| `databaseResourceGroup` | string | The resourceGroup of the deployed security alert policy |

## Template references

- [Servers/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/servers/securityAlertPolicies)
