# Virtual WANs `[Microsoft.Network/virtualWans]`

This template deploys a virtual WAN.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Network/virtualHubs` | 2021-03-01 |
| `Microsoft.Network/virtualWans` | 2021-03-01 |
| `Microsoft.Network/vpnGateways` | 2021-03-01 |
| `Microsoft.Network/vpnSites` | 2021-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefix` | string | `192.168.0.0/24` |  | Optional. The hub address prefix. This address prefix will be used as the address prefix for the hub vnet |
| `connectionName` | string | `SampleVpnsiteVpnGwConnection` |  | Optional. Name of the vpnconnection. A vpn connection is established between a vpnsite and a vpn gateway. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enableBgp` | string | `false` | `[true, false]` | Optional. his needs to be set to true if BGP needs to enabled on the vpn connection. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location where all resources will be created. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `name` | string |  |  | Required. Name of the Virtual Wan. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualHubName` | string | `SampleVirtualHub` |  | Optional. Name of the Virtual Hub. A virtual hub is created inside a virtual wan. |
| `virtualWanSku` | string | `Standard` | `[Standard, Basic]` | Optional. Sku of the Virtual Wan. |
| `vpnGatewayName` | string | `SampleVpnGateway` |  | Optional. Name of the Vpn Gateway. A vpn gateway is created inside a virtual hub. |
| `vpnsiteAddressspaceList` | array | `[]` |  | Optional. A list of static routes corresponding to the vpn site. These are configured on the vpn gateway. |
| `vpnsiteBgpAsn` | int |  |  | Required. The bgp asn number of a vpnsite. |
| `vpnsiteBgpPeeringAddress` | string |  |  | Required. The bgp peer IP address of a vpnsite. |
| `vpnSiteName` | string | `SampleVpnSite` |  | Optional. Name of the vpnsite. A vpnsite represents the on-premise vpn device. A public ip address is mandatory for a vpn site creation. |
| `vpnsitePublicIPAddress` | string |  |  | Required. he public IP address of a vpn site. |

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
| `virtualWanName` | string | The name of the virtual WAN |
| `virtualWanResourceGroup` | string | The resource group the virtual WAN was deployed into |
| `virtualWanResourceId` | string | The resource ID of the virtual WAN |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Virtualhubs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/virtualHubs)
- [Virtualwans](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/virtualWans)
- [Vpngateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/vpnGateways)
- [Vpnsites](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/vpnSites)
