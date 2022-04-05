# VPN Gateways `[Microsoft.Network/vpnGateways]`

This module deploys VPN Gateways.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Network/vpnGateways` | 2021-05-01 |
| `Microsoft.Network/vpnGateways/natRules` | 2021-05-01 |
| `Microsoft.Network/vpnGateways/vpnConnections` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the VPN gateway |
| `virtualHubResourceId` | string | The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `bgpSettings` | object | `{object}` |  | BGP settings details. |
| `connections` | _[connections](connections/readme.md)_ array | `[]` |  | The connections to create in the VPN gateway |
| `enableBgpRouteTranslationForNat` | bool | `False` |  | Enable BGP routes translation for NAT on this VPN gateway. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `isRoutingPreferenceInternet` | bool | `False` |  | Enable routing preference property for the public IP interface of the VPN gateway. |
| `location` | string | `[resourceGroup().location]` |  | Location where all resources will be created. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `natRules` | _[natRules](natRules/readme.md)_ array | `[]` |  | List of all the NAT Rules to associate with the gateway. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vpnGatewayScaleUnit` | int | `2` |  | The scale unit for this VPN gateway. |


### Parameter Usage:

### Parameter Usage: `bgpSettings`

```json
"bgpSettings": {
    "asn": 65515,
    "peerWeight": 0,
    "bgpPeeringAddresses": [
        {
            "ipconfigurationId": "Instance0",
            "defaultBgpIpAddresses": [
                "10.0.0.12"
            ],
            "customBgpIpAddresses": [],
            "tunnelIpAddresses": [
                "20.84.35.53",
                "10.0.0.4"
            ]
        },
        {
            "ipconfigurationId": "Instance1",
            "defaultBgpIpAddresses": [
                "10.0.0.13"
            ],
            "customBgpIpAddresses": [],
            "tunnelIpAddresses": [
                "20.84.34.225",
                "10.0.0.5"
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
| `name` | string | The name of the VPN gateway |
| `resourceGroupName` | string | The name of the resource group the VPN gateway was deployed into |
| `resourceId` | string | The resource ID of the VPN gateway |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Vpngateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnGateways)
- [Vpngateways/Natrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnGateways/natRules)
- [Vpngateways/Vpnconnections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnGateways/vpnConnections)
