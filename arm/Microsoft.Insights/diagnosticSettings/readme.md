# ActivityLog `[Microsoft.Insights/diagnosticSettings]`

This module deploys a subscription wide export of the ActivityLog.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticsName` | string | `[format('{0}-ActivityLog', uniqueString(subscription().id))]` |  | Optional. Name of the ActivityLog diagnostic settings. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `logsToEnable` | array | `[Administrative, Security, ServiceHealth, Alert, Recommendation, Policy, Autoscale, ResourceHealth]` | `[Administrative, Security, ServiceHealth, Alert, Recommendation, Policy, Autoscale, ResourceHealth]` | Optional. The name of logs that will be streamed. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

## Outputs

| Output Name | Type |
| :-- | :-- |
| `diagnosticResourceId` | string |
| `diagnosticsName` | string |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
