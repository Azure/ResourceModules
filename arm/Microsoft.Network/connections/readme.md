# Virtual Network Gateway Connections `[Microsoft.Network/connections]`

This template deploys a virtual network gateway connection.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Network/connections` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `customIPSecPolicy` | object | `{object}` |  | Optional. The IPSec Policies to be considered by this connection |
| `enableBgp` | bool |  |  | Optional. Value to specify if BGP is enabled or not |
| `localVirtualNetworkGatewayName` | string |  |  | Required. Specifies the local Virtual Network Gateway name |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `name` | string |  |  | Required. Remote connection name |
| `remoteEntityName` | string |  |  | Required. Specifies the remote Virtual Network Gateway/ExpressRoute |
| `remoteEntityResourceGroup` | string |  |  | Optional. Remote Virtual Network Gateway/ExpressRoute resource group name |
| `remoteEntitySubscriptionId` | string |  |  | Optional. Remote Virtual Network Gateway/ExpressRoute Subscription ID |
| `routingWeight` | string |  |  | Optional. The weight added to routes learned from this BGP speaker. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `usePolicyBasedTrafficSelectors` | bool |  |  | Optional. Enable policy-based traffic selectors |
| `virtualNetworkGatewayConnectionType` | string | `Ipsec` | `[Ipsec, VNet2VNet, ExpressRoute, VPNClient]` | Optional. Gateway connection type. |
| `vpnSharedKey` | string |  |  | Optional. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways |

### Parameter Usage: `customIPSecPolicy`

If ipsecEncryption parameter is empty, customIPSecPolicy will not be deployed. The parameter file should look like below.

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 0,
        "saDataSizeKilobytes": 0,
        "ipsecEncryption": "",
        "ipsecIntegrity": "",
        "ikeEncryption": "",
        "ikeIntegrity": "",
        "dhGroup": "",
        "pfsGroup": ""
    }
},
```

Format of the full customIPSecPolicy parameter in parameter file.

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 28800,
        "saDataSizeKilobytes": 102400000,
        "ipsecEncryption": "AES256",
        "ipsecIntegrity": "SHA256",
        "ikeEncryption": "AES256",
        "ikeIntegrity": "SHA256",
        "dhGroup": "DHGroup14",
        "pfsGroup": "None"
    }
},
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
| `connectionName` | string | The name of the remote connection |
| `remoteConnectionResourceGroup` | string | The resource group the remote connection was deployed into |
| `remoteConnectionResourceId` | string | The resource ID of the remote connection |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Connections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/connections)
