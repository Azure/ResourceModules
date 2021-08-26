# VirtualNetworkPeering

This template deploys Virtual Network Peering.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Network/virtualNetworks/virtualNetworkPeerings`|2020-05-01|
|`Microsoft.Resources/deployments`|2020-06-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `remoteVirtualNetworksProperties` | Array | Optional. Required when not using remoteVirtualNetworkId (i.e. Single Peering deployment). Array containing multiple objects for different VNETs to peer with. Format: Object of remoteVirtualNetwork:Id (string-required), allowVirtualNetworkAccess (bool-optional-default-true), allowForwardedTraffic (bool-optional-default-true), allowGatewayTransit (bool-optional-default-false), useRemoteGateways (bool-optional-default-true). | [] | See [Considerations](readme.md##considerations) |
| `allowForwardedTraffic` | bool | Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. | True |  |
| `allowGatewayTransit` | bool | Optional. If gateway links can be used in remote virtual networking to link to this virtual network. | False |  |
| `allowVirtualNetworkAccess` | bool | Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. | True |  |
| `localVnetName` | string | Required. The Name of the Virtual Network to add the peering to. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `peeringName` | string | Optional. Required if not using remoteVirtualNetworksProperties. The Name of the virtual network peering resource. |  |  |
| `remoteVirtualNetworkId` | string |Optional. Required if not using remoteVirtualNetworksProperties. The Resource Id of the remote virtual network. The remove virtual network can be in the same or different region. |  |  |
| `useRemoteGateways` | bool | Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. | True |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `virtualNetworkPeeringName` | string | The Name of the vNet Peering. |
| `virtualNetworkPeeringResourceId` | string | The Resource Id of the vNet Peering. |
| `virtualNetworkPeeringResourceGroup` | string | The Resource Group the vNet Peering was deployed to. |
| `virtualNetworkPeeringResourceIds` | array | Array of vNet Peering Resource Ids of the vNet Peering. Only available if using remoteVirtualNetworksProperties |

## Considerations

- The `remoteVirtualNetworksProperties` allows you to create peering with multiple virtual networks at the same time, each with its own unique configurations for `allowForwardedTraffic`, `allowGatewayTransit`, `allowVirtualNetworkAccess` and `useRemoteGateways`. However this parameter cannot be used in conjuction with `remoteVirtualNetworkId` or other parameters in the template.

    Example:
    ```json
    "remoteVirtualNetworksProperties": {
        "value": [
            {
                "remoteVirtualNetwork": {
                    "id": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/dependencies-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-002"
                },
                "allowVirtualNetworkAccess": true,
                "allowForwardedTraffic": true
            },
            {
                "remoteVirtualNetwork": {
                    "id": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/dependencies-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-005"
                },
                "allowVirtualNetworkAccess": true,
                "allowForwardedTraffic": true,
                "allowGatewayTransit": false,
                "useRemoteGateways": false
            }
        ]
    }
    ```

## Additional resources

- [Microsoft.Network virtualNetworks/virtualNetworkPeerings template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-04-01/virtualnetworks/virtualnetworkpeerings)
