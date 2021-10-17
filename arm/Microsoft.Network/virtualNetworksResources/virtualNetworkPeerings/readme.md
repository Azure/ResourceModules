# VirtualNetworkPeering

This template deploys Virtual Network Peering.

## Resource types

| Resource Type                                              | Api Version |
| :--------------------------------------------------------- | :---------- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2021-02-01  |
| `Microsoft.Resources/deployments`                          | 2019-10-01  |

### Resource dependency

The following resources are required to be able to deploy this resource.

- Local Virtual Network (Identified by the `localVnetName` parameter).
- Remote Virtual Network (Identified by the `remoteVirtualNetworkId` parameter)

## Parameters

| Parameter Name              | Type   | Description                                                                                                                                                                                                                                                                                                                                                        | DefaultValue | Possible values |
| :-------------------------- | :----- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------- | :-------------- |
| `cuaId`                     | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered                                                                                                                                                                                                                                                                            |              |                 |
| `peeringName`               | string | Optional. The Name of Vnet Peering resource. If not provided, value will be localVnetName-remoteVnetName                                                                                                                                                                                                                                                           |              |                 |
| `localVnetName`             | string | Required. The Name of the Virtual Network to add the peering to.                                                                                                                                                                                                                                                                                                   |              |                 |
| `remoteVirtualNetworkId`    | string | Required. The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID.                                                                                                                                                                                                                                        |              |                 |
| `allowForwardedTraffic`     | bool   | Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true.                                                                                                                                                                                                           | `true`       |                 |
| `allowGatewayTransit`       | bool   | Optional. If gateway links can be used in remote virtual networking to link to this virtual network. Default is false.                                                                                                                                                                                                                                             | `false`      |                 |
| `allowVirtualNetworkAccess` | bool   | Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true.                                                                                                                                                                                                                     | `true`       |                 |
| `doNotVerifyRemoteGateways` | bool   | Optional. If we need to verify the provisioning state of the remote gateway. Default is true'.                                                                                                                                                                                                                                                                     | `true`       |                 |
| `useRemoteGateways`         | bool   | Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false | `false`      |                 |

## Outputs

| Output Name                            | Type   | Description                               |
| :------------------------------------- | :----- | :---------------------------------------- |
| `localVirtualNetworkPeeringResourceId` | array  | The Resource ID of the VNet Peering       |
| `virtualNetworkPeeringName`            | array  | The name of the VNet Peering              |
| `virtualNetworkPeeringResourceGroup`   | string | The Resource Group name of the local VNet |

## Considerations

- *None*

## Additional resources

- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [VirtualNetworks/VirtualNetworkPeerings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/virtualNetworks/virtualNetworkPeerings)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/deployments)
