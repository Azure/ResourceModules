# VirtualNetworkPeering `[Microsoft.Network/virtualNetwork/virtualNetworkPeerings-multiRemoteVnets]`

This template deploys Virtual Network Peering.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualnetworks/virtualnetworkpeerings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `localVnetName` | string | The Name of the Virtual Network to add the peering to. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `peeringConfigurations` | array | `[]` | Optional. The list of remote networks to peering peer with, including the configuration. |


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

</details>

<details>

<summary>Bicep format</summary>

```bicep
peeringConfigurations: [
    {
        peeringName: 'sxx-az-peering-x-002-sxx-az-peering-x-003'  // Optional
        remoteVirtualNetworkId: '/subscriptions/<subscriptionId>/resourceGroups/dependencies-rg/providers/Microsoft.Network/virtualNetworks/<vnetName>'
        allowVirtualNetworkAccess: false // Optional. Default true
        allowForwardedTraffic: false // Optional. Default true
        allowGatewayTransit: false // Optional. Default false
        useRemoteGateways: false // Optional. Default true
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `localVirtualNetworkPeeringResourceIds` | array | The resource IDs of the deployed virtual network peerings. |
| `virtualNetworkPeeringNames` | array | The names of the deployed virtual network peerings. |
| `virtualNetworkPeeringResourceGroup` | string | The resource group of the deployed virtual network peerings. |

## Cross-referenced modules

_None_
