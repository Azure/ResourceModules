# OperationalinsightsWorkspacesSavedsearches `[Microsoft.OperationalInsights/workspaces/savedSearches]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `category` | string |  |  | Required. Query category. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `displayName` | string |  |  | Requried. Display name for the search. |
| `etag` | string | `*` |  | Optional. The ETag of the data source. |
| `functionAlias` | string |  |  | Optional. The function alias if query serves as a function.. |
| `functionParameters` | string |  |  | Optional. The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions. |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `name` | string |  |  | Required. Name of the saved search |
| `query` | string |  |  | Required. Kusto Query to be stored. |
| `tags` | array | `[]` |  | Optional. Tags to configure in the resource. |
| `version` | int | `2` |  | Optional. The version number of the query language. |

## Outputs

| Output Name | Type |
| :-- | :-- |

## Template references

- [Workspaces/Savedsearches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches)
