# OperationalinsightsWorkspacesStorageinsightconfigs `[Microsoft.OperationalInsights/workspaces/storageInsightConfigs]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `containers` | array | `[]` |  | Optional. The names of the blob containers that the workspace should read. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `etag` | string | `*` |  | Optional. The ETag of the data source. |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace. |
| `name` | string |  |  | Required. Name of the saved search. |
| `storageAccountId` | string |  |  | Required. The Azure Resource Manager ID of the storage account resource. |
| `tables` | array | `[]` |  | Optional. The names of the Azure tables that the workspace should read. |
| `tags` | object | `{object}` |  | Optional. Tags to configure in the resource. |

## Outputs

| Output Name | Type |
| :-- | :-- |

## Template references

- [Workspaces/Storageinsightconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs)
