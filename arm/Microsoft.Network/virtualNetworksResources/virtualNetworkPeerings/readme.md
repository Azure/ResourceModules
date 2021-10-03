# VirtualNetworkPeering

This template deploys Virtual Network Peering.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2020-05-01 |
| `Microsoft.Resources/deployments` | 2019-10-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.   

- *None*

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `localVnetName` | string | Required. The Name of the Virtual Network to add the peering to. |  |  |
| `peeringConfigurations` | array | Optional. The list of remote networks to peering peer with, including the configuration. See below for instructions. | System.Object[] |  |

### Parameter Usage: `peeringConfigurations`

Array containing multiple objects for different VNETs to peer with.

```json
"peeringConfigurations": {
    "value": [
        {
            "peeringName": "sxx-az-peering-weu-x-002-sxx-az-peering-weu-x-003",  // Optional
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
| `localVirtualNetworkPeeringResourceIds` | array |  |
| `remoteVirtualNetworkPeeringResourceIds` | array |  |
| `virtualNetworkPeeringNames` | array |  |
| `virtualNetworkPeeringResourceGroup` | string |  |

## Considerations

- *None*

## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [VirtualNetworks/VirtualNetworkPeerings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/virtualNetworks/virtualNetworkPeerings)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/deployments)