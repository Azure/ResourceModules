# NSG Flow Logs `[Microsoft.Network/networkWatchers/flowLogs]`

This module controls the Network Security Group Flow Logs and analytics settings
**Note: this module must be run on the Resource Group where Network Watcher is deployed**

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/flowLogs` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enabled` | bool | `True` |  | Optional. If the flow log should be enabled |
| `formatVersion` | int | `2` | `[1, 2]` | Optional. The flow log format version |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string | `[format('{0}-{1}-flowlog', last(split(parameters('targetResourceId'), '/')), split(parameters('targetResourceId'), '/')[4])]` |  | Optional. Name of the resource. |
| `networkWatcherName` | string | `[format('NetworkWatcher_{0}', resourceGroup().location)]` |  | Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG |
| `retentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `storageId` | string |  |  | Required. Resource ID of the diagnostic storage account. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `targetResourceId` | string |  |  | Required. Resource ID of the NSG that must be enabled for Flow Logs. |
| `trafficAnalyticsInterval` | int | `60` | `[10, 60]` | Optional. The interval in minutes which would decide how frequently TA service should do flow analytics. |
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
| `name` | string | The name of the flow log |
| `resourceGroupName` | string | The resource group the flow log was deployed into |
| `resourceId` | string | The resource ID of the flow log |

## Template references

- [Networkwatchers/Flowlogs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkWatchers/flowLogs)
