# Network Watchers `[Microsoft.Network/networkWatchers]`

This template deploys a network watcher.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Network/networkWatchers` | 2021-05-01 |
| `Microsoft.Network/networkWatchers/connectionMonitors` | 2021-05-01 |
| `Microsoft.Network/networkWatchers/flowLogs` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `connectionMonitors` | _[connectionMonitors](connectionMonitors/readme.md)_ array | `[]` |  | Optional. Array that contains the Connection Monitors |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `flowLogs` | _[flowLogs](flowLogs/readme.md)_ array | `[]` |  | Optional. Array that contains the Flow Logs |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `name` | string | `[format('NetworkWatcher_{0}', parameters('location'))]` |  | Required. Name of the Network Watcher resource (hidden) |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |


### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed network watcher |
| `resourceGroupName` | string | The resource group the network watcher was deployed into |
| `resourceId` | string | The resource ID of the deployed network watcher |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Networkwatchers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkWatchers)
- [Networkwatchers/Connectionmonitors](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkWatchers/connectionMonitors)
- [Networkwatchers/Flowlogs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkWatchers/flowLogs)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
