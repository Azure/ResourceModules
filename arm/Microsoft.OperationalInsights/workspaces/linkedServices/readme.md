# Operationalinsights Workspaces Linked Services `[Microsoft.OperationalInsights/workspaces/linkedServices]`

This template deploys a linked service for a Log Analytics workspace.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `name` | string |  |  | Required. Name of the link |
| `resourceId` | string |  |  | Required. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access. |
| `tags` | object | `{object}` |  | Optional. Tags to configure in the resource. |
| `writeAccessResourceId` | string |  |  | Optional. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access.  |

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
| `linkedServiceName` | string | The name of the deployed linked service |
| `linkedServiceResourceGroup` | string | The resource group where the linked service is deployed |
| `linkedServiceResourceId` | string | The resource ID of the deployed linked service |

## Template references

- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices)
