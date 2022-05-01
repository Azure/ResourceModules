# Synapse Workspaces Keys `[Microsoft.Synapse/workspaces/keys]`

This module deploys a Synapse Workspaces Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Synapse/workspaces/keys` | 2021-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `isActiveCMK` | bool | Used to activate the workspace after a customer managed key is provided. |
| `keyVaultUrl` | string | The Key Vault Url of the workspace key. |
| `name` | string | Encryption key name. |
| `workspaceName` | string | Synapse workspace name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `False` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | The geo-location where the resource lives. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed key |
| `resourceGroupName` | string | The resource group of the deployed key |
| `resourceId` | string | The resource ID of the deployed key |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Workspaces/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys)
