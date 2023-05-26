# Storage Account blob services `[Microsoft.Storage/storageAccounts/blobServices]`

This module can be used to deploy a blob service into a storage account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automaticSnapshotPolicyEnabled` | bool | `False` |  | Automatic Snapshot is enabled if set to true. |
| `changeFeedEnabled` | bool | `True` |  | The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service. |
| `changeFeedRetentionInDays` | int | `7` |  | Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. A "0" value indicates an infinite retention of the change feed. |
| `containerDeleteRetentionPolicyAllowPermanentDelete` | bool | `False` |  | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| `containerDeleteRetentionPolicyDays` | int | `7` |  | Indicates the number of days that the deleted item should be retained. |
| `containerDeleteRetentionPolicyEnabled` | bool | `True` |  | The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled. |
| `containers` | _[containers](containers/README.md)_ array | `[]` |  | Blob containers to create. |
| `corsRules` | array | `[]` |  | Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service. |
| `defaultServiceVersion` | string | `''` |  | Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions. |
| `deleteRetentionPolicyDays` | int | `7` |  | Indicates the number of days that the deleted blob should be retained. |
| `deleteRetentionPolicyEnabled` | bool | `True` |  | The blob service properties for blob soft delete. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, StorageDelete, StorageRead, StorageWrite]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of a log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `isVersioningEnabled` | bool | `True` |  | Use versioning to automatically maintain previous versions of your blobs. |
| `lastAccessTimeTrackingPolicyEnable` | bool | `False` |  | The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled. |
| `restorePolicyDays` | int | `6` |  | how long this blob can be restored. It should be less than DeleteRetentionPolicy days. |
| `restorePolicyEnabled` | bool | `True` |  | The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed blob service. |
| `resourceGroupName` | string | The name of the deployed blob service. |
| `resourceId` | string | The resource ID of the deployed blob service. |

## Cross-referenced modules

_None_
