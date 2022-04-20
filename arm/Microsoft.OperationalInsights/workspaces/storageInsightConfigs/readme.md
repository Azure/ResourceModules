# Operationalinsights Workspaces Storage Insight Configs `[Microsoft.OperationalInsights/workspaces/storageInsightConfigs]`

This template deploys a storage insights configuration for a Log Analytics workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2020-08-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsWorkspaceName` | string | Name of the Log Analytics workspace. |
| `storageAccountId` | string | The Azure Resource Manager ID of the storage account resource. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `containers` | array | `[]` | The names of the blob containers that the workspace should read. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `[format('{0}-stinsconfig', last(split(parameters('storageAccountId'), '/')))]` | The name of the storage insights config |
| `tables` | array | `[]` | The names of the Azure tables that the workspace should read. |
| `tags` | object | `{object}` | Tags to configure in the resource. |


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
| `name` | string | The name of the storage insights configuration |
| `resourceGroupName` | string | The resource group where the storage insight configuration is deployed |
| `resourceId` | string | The resource ID of the deployed storage insights configuration |

## Template references

- [Workspaces/Storageinsightconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs)
