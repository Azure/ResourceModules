# Network Watcher

This template deploys Network Watcher.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/networkWatchers`|2020-08-01|
|`Microsoft.Network/networkWatchers/connectionMonitors`|2019-11-01|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :- | :- | :-| :-| :-|
| `networkWatcherName` | string | | Required. Name of the Network Watcher resource (hidden)
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `monitors` | array | [] | complex structure see below | Optional. Array that contains the monitors|
| `workspaceResourceId` | string | "" | ID of Workspace Resource| Optional. Specify the Workspace Resource ID. If not specified a default workspace will be created |
| `tags`| object | {} | Complex structure, see below. | Optional. Tags of the Virtual Network Gateway resource. |
| `cuaId` | string | {} | | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered" |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `networkWatcherName` | string | The name of the Network Watcher deployed. |
| `networkWatcherResourceGroup` | string | The name of the Resource Group the Network Watcher was created in. |
| `networkWatcherResourceId` | string | The Resource id of the Network Watcher deployed. |

## Considerations

N/A

### Parameter Usage: `monitors`

Montiors specifies the Connection monitors in an array in the following structure.

Important note: the parameter ``name`` must include the ``resource name`` AND ``resource group`` inside brackets (). e.g ``"name": "myVm01(my-rg-01)"``. This parameter is under ``monitors/value/endpoints/name`` and ``monitors/value/testGroups/name``. See example below for full structure.

```json
"monitors": {
    "value": [
        {
            "connectionMonitorName": "my-connection-monitor01",
            "workspaceResourceId": {
                "value": "[variables('workspaceId')]"
            },
            "endpoints": [
                {
                    "name": "endpoint01",
                    "resourceId": "/subscriptions/111111-222222-33333-4444-5555555/resourceGroups/my-rg-01/providers/Microsoft.Compute/virtualMachines/myVm01"
                },
                {
                    "name": "myonpremvm.contoso.com",
                    "address": "10.10.10.10"
                }
            ],
            "testConfigurations": [
                {
                    "name": "ICMP",
                    "testFrequencySec": 60,
                    "protocol": "Icmp",
                    "icmpConfiguration": {
                        "disableTraceRoute": false
                    },
                    "successThreshold": {
                        "checksFailedPercent": 1,
                        "roundTripTimeMs": 70
                    }
                }
            ],
            "testGroups": [
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
    ]
}
```

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

## Additional resources

- [Microsoft.Network networkWatchers template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-04-01/networkwatchers)
- [What is Azure Network Watcher?](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview)
- [Network Connectivity Monitoring with Connection Monitor (Preview)](https://docs.microsoft.com/en-us/azure/network-watcher/connection-monitor-preview)