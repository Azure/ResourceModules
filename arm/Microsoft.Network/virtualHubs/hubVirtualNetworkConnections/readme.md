# Virtual Hub Virtual Network Connections `[Microsoft.Network/virtualHubs/hubVirtualNetworkConnections]`

This module deploys virtual hub virtual network connections.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enableInternetSecurity` | bool | `True` |  | Optional. Enable internet security. |
| `name` | string |  |  | Required. The connection name. |
| `remoteVirtualNetworkId` | string |  |  | Required. Resource ID of the virtual network to link to |
| `routingConfiguration` | object | `{object}` |  | Optional. Routing Configuration indicating the associated and propagated route tables for this connection. |
| `virtualHubName` | string |  |  | Required. The virtual hub name. |

### Parameter Usage: `hubVirtualNetworkConnections`

...

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual hub connection |
| `resourceGroupName` | string | The resource group the virtual hub connection was deployed into |
| `resourceId` | string | The resource ID of the virtual hub connection |

## Template references

- [Virtualhubs/Hubvirtualnetworkconnections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs/hubVirtualNetworkConnections)
