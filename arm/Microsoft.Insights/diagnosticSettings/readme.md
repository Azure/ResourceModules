# Activity Logs `[Microsoft.Insights/diagnosticSettings]`

This module deploys a subscription wide export of the activity log.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `logsToEnable` | array | `[Administrative, Security, ServiceHealth, Alert, Recommendation, Policy, Autoscale, ResourceHealth]` | `[Administrative, Security, ServiceHealth, Alert, Recommendation, Policy, Autoscale, ResourceHealth]` | Optional. The name of logs that will be streamed. |
| `name` | string | `[format('{0}-ActivityLog', uniqueString(subscription().id))]` |  | Optional. Name of the ActivityLog diagnostic settings. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `diagnosticResourceId` | string | The resource ID of the diagnostic settings |
| `diagnosticsName` | string | The name of the diagnostic settings |
| `subscriptionName` | string | The name of the subscription to deploy into |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
