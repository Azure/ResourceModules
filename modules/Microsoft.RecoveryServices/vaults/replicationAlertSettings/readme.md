# RecoveryServices Vaults ReplicationAlertSettings `[Microsoft.RecoveryServices/vaults/replicationAlertSettings]`

This module deploys RecoveryServices Vaults ReplicationAlertSettings.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationAlertSettings` | [2022-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-08-01/vaults/replicationAlertSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `emailAddresses` | string | `''` | Comma separated list of custom email address for sending alert emails. |
| `name` | string |  | The name of the replication Alert Setting. |
| `recoveryVaultName` | string |  | The name of the parent Azure Recovery Service Vault. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `locale` | string | `'en-GB'` |  | The locale for the email notification. |
| `sendToOwners` | string | `'DoNotSend'` | `[DoNotSend, Send]` | The value indicating whether to send email to subscription administrator. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication Alert Setting. |
| `resourceGroupName` | string | The name of the resource group the replication alert setting was created. |
| `resourceId` | string | The resource ID of the replication alert setting. |

## Cross-referenced modules

_None_
