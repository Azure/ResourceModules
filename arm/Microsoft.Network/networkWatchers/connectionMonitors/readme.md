# Network Watchers Connection Monitors `[Microsoft.Network/networkWatchers/connectionMonitors]`

This template deploys Connection Monitors.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/connectionMonitors` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `endpoints` | array | `[]` |  | Optional. List of connection monitor endpoints. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string |  |  | Optional. Name of the resource. |
| `networkWatcherName` | string | `[format('NetworkWatcher_{0}', resourceGroup().location)]` |  | Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `testConfigurations` | array | `[]` |  | Optional. List of connection monitor test configurations. |
| `testGroups` | array | `[]` |  | Optional. List of connection monitor test groups. |
| `workspaceResourceId` | string |  |  | Optional. Specify the Log Analytics Workspace Resource ID |

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
| `name` | string | The name of the deployed connection monitor |
| `resourceGroupName` | string | The resource group the connection monitor was deployed into |
| `resourceId` | string | The resource ID of the deployed connection monitor |

## Template references

- [Networkwatchers/Connectionmonitors](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkWatchers/connectionMonitors)
