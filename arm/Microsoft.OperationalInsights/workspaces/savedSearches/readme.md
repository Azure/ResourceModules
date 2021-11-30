# Operationalinsights Workspaces Saved Searches `[Microsoft.OperationalInsights/workspaces/savedSearches]`

This template deploys a saved search for a Log Analytics workspace.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `category` | string |  |  | Required. Query category. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `displayName` | string |  |  | Requried. Display name for the search. |
| `functionAlias` | string |  |  | Optional. The function alias if query serves as a function.. |
| `functionParameters` | string |  |  | Optional. The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions. |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `name` | string |  |  | Required. Name of the saved search |
| `query` | string |  |  | Required. Kusto Query to be stored. |
| `tags` | array | `[]` |  | Optional. Tags to configure in the resource. |
| `version` | int | `2` |  | Optional. The version number of the query language. |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `savedSearchName` | string | The name of the deployed saved search |
| `savedSearchResourceGroup` | string | The resource group where the saved search is deployed |
| `savedSearchResourceId` | string | The resource ID of the deployed saved search |

## Template references

- [Workspaces/Savedsearches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches)
