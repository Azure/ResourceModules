# Network Watchers Connection Monitors `[Microsoft.Network/networkWatchers/connectionMonitors]`

This template deploys Connection Monitors.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/connectionMonitors` | 2021-03-01 |

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



### Parameter Usage: `endpoints`

***Note:*** the parameter ``name`` must include the ``resource name`` AND ``resource group`` inside brackets (). e.g ``"name": "myVm01(my-rg-01)"``.

```json

"endpoints": {
    "value":
    [
        {
            "name": "endpoint01",
            "resourceId": "/subscriptions/111111-222222-33333-4444-5555555/resourceGroups/my-rg-01/providers/Microsoft.Compute/virtualMachines/myVm01"
        },
        {
            "name": "myonpremvm.contoso.com",
            "address": "10.10.10.10"
        }
    ]
}

```

### Parameter Usage: `testGroups`

Important note: the parameter ``name`` must include the ``resource name`` AND ``resource group`` inside brackets (). e.g ``"name": "myVm01(my-rg-01)"``.

```json
"testGroups": {
    "value": {
        [
            {
                "name": "myTestGroup01",
                "disable": false,
                "testConfigurations": [
                    "ICMP"
                ],
                "sources": [
                    "myVm01(my-rg-01)"
                ],
                "destinations": [
                    "myonpremvm.contoso.com"
                ]
            }
        ]
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `connectionMonitorName` | string | The name of the deployed connection monitor |
| `connectionMonitorResourceGroup` | string | The resource group the connection monitor was deployed into |
| `connectionMonitorResourceId` | string | The resource ID of the deployed connection monitor |

## Template references

- [Networkwatchers/Connectionmonitors](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/networkWatchers/connectionMonitors)
