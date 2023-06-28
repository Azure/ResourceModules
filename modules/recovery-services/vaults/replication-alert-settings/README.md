# Recovery Services Vault Replication Alert Settings `[Microsoft.RecoveryServices/vaults/replicationAlertSettings]`

This module deploys a Recovery Services Vault Replication Alert Settings.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationAlertSettings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationAlertSettings) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `customEmailAddresses` | array | `[]` |  | Comma separated list of custom email address for sending alert emails. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `locale` | string | `''` |  | The locale for the email notification. |
| `name` | string | `'defaultAlertSetting'` |  | The name of the replication Alert Setting. |
| `sendToOwners` | string | `'Send'` | `[DoNotSend, Send]` | The value indicating whether to send email to subscription administrator. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication Alert Setting. |
| `resourceGroupName` | string | The name of the resource group the replication alert setting was created. |
| `resourceId` | string | The resource ID of the replication alert setting. |

## Cross-referenced modules

_None_
