# Operationalinsights Workspaces Storage Insight Configs `[Microsoft.OperationalInsights/workspaces/storageInsightConfigs]`

This template deploys a storage insights configuration for a Log Analytics workspace.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `containers` | array | `[]` |  | Optional. The names of the blob containers that the workspace should read. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace. |
| `name` | string | `[last(split(parameters('storageAccountId'), '/'))]` |  | The name of the storage insights config |
| `storageAccountId` | string |  |  | Required. The Azure Resource Manager ID of the storage account resource. |
| `tables` | array | `[]` |  | Optional. The names of the Azure tables that the workspace should read. |
| `tags` | object | `{object}` |  | Optional. Tags to configure in the resource. |

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
| `storageinsightconfigName` | string | The name of the storage insights configuration |
| `storageinsightconfigResourceGroup` | string | The resource group where the storage insight configuration is deployed |
| `storageinsightconfigResourceId` | string | The resource ID of the deployed storage insights configuration |

## Template references

- [Workspaces/Storageinsightconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs)
