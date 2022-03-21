# Storage Account file share services `[Microsoft.Storage/storageAccounts/fileServices]`

This module can be used to deploy a file share service into a storage account.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Storage/storageAccounts/fileServices` | 2021-04-01 |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2021-08-01 |

## Parameters

### **Required** parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

### **Optional** parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| `shares` | _[shares](shares/readme.md)_ array | `[]` | File shares to create. |
| `diagnosticEventHubName` | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `name` | string | `default` | The name of the file service |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `diagnosticLogsRetentionInDays` | int | `365` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `metricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticWorkspaceId` | string | Resource ID of a log analytics workspace. |
| `diagnosticStorageAccountId` | string | Resource ID of the diagnostic storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `logsToEnable` | array | `[StorageRead, StorageWrite, StorageDelete]` | `[StorageRead, StorageWrite, StorageDelete]` | The name of logs that will be streamed. |
| `shareDeleteRetentionPolicy` | object | `{object}` | The service properties for soft delete. |
| `protocolSettings` | object | `{object}` | Protocol settings for file service |


### **Required** parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

### **Optional** parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| `shares` | _[shares](shares/readme.md)_ array | `[]` | File shares to create. |
| `diagnosticEventHubName` | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `name` | string | `default` | The name of the file service |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `diagnosticLogsRetentionInDays` | int | `365` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `metricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticWorkspaceId` | string | Resource ID of a log analytics workspace. |
| `diagnosticStorageAccountId` | string | Resource ID of the diagnostic storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `logsToEnable` | array | `[StorageRead, StorageWrite, StorageDelete]` | `[StorageRead, StorageWrite, StorageDelete]` | The name of logs that will be streamed. |
| `shareDeleteRetentionPolicy` | object | `{object}` | The service properties for soft delete. |
| `protocolSettings` | object | `{object}` | Protocol settings for file service |


### **Required** parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

### **Optional** parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| `shares` | _[shares](shares/readme.md)_ array | `[]` | `` | File shares to create. |
| `diagnosticEventHubName` | string | `` | `` | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `name` | string | `default` | `` | The name of the file service |
| `enableDefaultTelemetry` | bool | `True` | `` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `diagnosticLogsRetentionInDays` | int | `365` | `` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `metricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticWorkspaceId` | string | `` | `` | Resource ID of a log analytics workspace. |
| `diagnosticStorageAccountId` | string | `` | `` | Resource ID of the diagnostic storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `` | `` | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `logsToEnable` | array | `[StorageRead, StorageWrite, StorageDelete]` | `[StorageRead, StorageWrite, StorageDelete]` | The name of logs that will be streamed. |
| `shareDeleteRetentionPolicy` | object | `{object}` | `` | The service properties for soft delete. |
| `protocolSettings` | object | `{object}` | `` | Protocol settings for file service |


### **Required** parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

### **Optional** parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| `shares` | _[shares](shares/readme.md)_ array | `[]` | `` | File shares to create. |
| `diagnosticEventHubName` | string | `` | `` | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `name` | string | `default` | `` | The name of the file service |
| `enableDefaultTelemetry` | bool | `True` | `` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `diagnosticLogsRetentionInDays` | int | `365` | `` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `metricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticWorkspaceId` | string | `` | `` | Resource ID of a log analytics workspace. |
| `diagnosticStorageAccountId` | string | `` | `` | Resource ID of the diagnostic storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `` | `` | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `logsToEnable` | array | `[StorageRead, StorageWrite, StorageDelete]` | `[StorageRead, StorageWrite, StorageDelete]` | The name of logs that will be streamed. |
| `shareDeleteRetentionPolicy` | object | `{object}` | `` | The service properties for soft delete. |
| `protocolSettings` | object | `{object}` | `` | Protocol settings for file service |


### **Required** parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

### **Optional** parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| `shares` | _[shares](shares/readme.md)_ array | `[]` | `` | File shares to create. |
| `diagnosticEventHubName` | string | `` | `` | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `name` | string | `default` | `` | The name of the file service |
| `enableDefaultTelemetry` | bool | `True` | `` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `diagnosticLogsRetentionInDays` | int | `365` | `` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `metricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticWorkspaceId` | string | `` | `` | Resource ID of a log analytics workspace. |
| `diagnosticStorageAccountId` | string | `` | `` | Resource ID of the diagnostic storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `` | `` | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `logsToEnable` | array | `[StorageRead, StorageWrite, StorageDelete]` | `[StorageRead, StorageWrite, StorageDelete]` | The name of logs that will be streamed. |
| `shareDeleteRetentionPolicy` | object | `{object}` | `` | The service properties for soft delete. |
| `protocolSettings` | object | `{object}` | `` | Protocol settings for file service |


### **Required** parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

### **Optional** parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| `shares` | _[shares](shares/readme.md)_ array | `[] | ` | File shares to create. |
| `diagnosticEventHubName` | string | ` | ` | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `name` | string | `default | ` | The name of the file service |
| `enableDefaultTelemetry` | bool | `True | ` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `diagnosticLogsRetentionInDays` | int | `365 | ` | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `metricsToEnable` | array | `[Transaction] | `[Transaction] | The name of metrics that will be streamed. |
| `diagnosticWorkspaceId` | string | ` | ` | Resource ID of a log analytics workspace. |
| `diagnosticStorageAccountId` | string | ` | ` | Resource ID of the diagnostic storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | ` | ` | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `logsToEnable` | array | `[StorageRead, StorageWrite, StorageDelete] | `[StorageRead, StorageWrite, StorageDelete] | The name of logs that will be streamed. |
| `shareDeleteRetentionPolicy` | object | `{object} | ` | The service properties for soft delete. |
| `protocolSettings` | object | `{object} | ` | Protocol settings for file service |


### Required parameters
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| storageAccountName | string | Name of the Storage Account. |

### Optional parameters
| Parameter Name | Type | Default Value | Allowed Value | Description |
| :-- | :-- | :-- | :-- | :-- |
| shares | _[shares](shares/readme.md)_ array | [] |  | File shares to create. |
| diagnosticEventHubName | string |  |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| name | string | default |  | The name of the file service |
| enableDefaultTelemetry | bool | True |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| diagnosticLogsRetentionInDays | int | 365 |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| metricsToEnable | array | [Transaction] | [Transaction] | The name of metrics that will be streamed. |
| diagnosticWorkspaceId | string |  |  | Resource ID of a log analytics workspace. |
| diagnosticStorageAccountId | string |  |  | Resource ID of the diagnostic storage account. |
| diagnosticEventHubAuthorizationRuleId | string |  |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| logsToEnable | array | [StorageRead, StorageWrite, StorageDelete] | [StorageRead, StorageWrite, StorageDelete] | The name of logs that will be streamed. |
| shareDeleteRetentionPolicy | object | {object} |  | The service properties for soft delete. |
| protocolSettings | object | {object} |  | Protocol settings for file service |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed file share service |
| `resourceGroupName` | string | The resource group of the deployed file share service |
| `resourceId` | string | The resource ID of the deployed file share service |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Storageaccounts/Fileservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/fileServices)
- [Storageaccounts/Fileservices/Shares](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-08-01/storageAccounts/fileServices/shares)
