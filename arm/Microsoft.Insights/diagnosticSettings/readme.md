# ActivityLog

This module deploys a subscription wide export of the ActivityLog.

## Resource Types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Insights/diagnosticSettings`|2017-05-01-preview|


## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticsName` | string | Required. Name of the ActivityLog diagnostic settings. |  |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Optional. Location for all resources. | global |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `diagnosticResourceId` | string | The Resource Ids of the Diagnostics. |
| `diagnosticsName` | string | The Name of the Diagnostics. |

## Considerations

*N/A*

## Additional resources

- [Collect Azure Activity log with diagnostic settings (preview)](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-subscription)
- [Microsoft.Insights template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/allversions)