# VirtualNetworkPeering

This template deploys Virtual Network Peering.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `localVnetName` | string |  |  | Required. The Name of the Virtual Network to add the peering to. |
| `peeringConfigurations` | array | `[]` |  | Optional. Optional. The list of remote networks to peering peer with, including the configuration. |

### Parameter Usage: `peeringConfigurations`

Array containing multiple objects for different VNETs to peer with.

```json
"peeringConfigurations": {
    "value": [
        {
            "peeringName": "sxx-az-peering-x-002-sxx-az-peering-x-003",  // Optional
            "remoteVirtualNetworkId": "/subscriptions/<subscriptionId>/resourceGroups/dependencies-rg/providers/Microsoft.Network/virtualNetworks/<vnetName>",
            "allowVirtualNetworkAccess": false, // Optional. Default true
            "allowForwardedTraffic": false, // Optional. Default true
            "allowGatewayTransit": false, // Optional. Default false
            "useRemoteGateways": false // Optional. Default true
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `localVirtualNetworkPeeringResourceIds` | array | The names of the deployed virtual network peerings |
| `virtualNetworkPeeringNames` | array | The resource IDs of the deployed virtual network peerings |
| `virtualNetworkPeeringResourceGroup` | string | The resource group of the deployed virtual network peerings |

## Template references

- [Virtualnetworks/Virtualnetworkpeerings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/virtualNetworks/virtualNetworkPeerings)
