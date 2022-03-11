# VPN Site `[Microsoft.Network/vpnSites]`

This module deploys a VPN Site.
## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Network/vpnSites` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefixes` | array | `[]` |  | Optional. An array of IP address ranges that can be used by subnets of the virtual network. Must be provided if no bgpProperties or VPNSiteLinks are configured. |
| `bgpProperties` | object | `{object}` |  | Optional. BGP settings details. Must be provided if no addressPrefixes or VPNSiteLinks are configured. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. |
| `deviceProperties` | object | `{object}` |  | Optional. List of properties of the device. |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ipAddress` | string |  |  | Optional. The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. |
| `isSecuritySite` | bool | `False` |  | Optional. IsSecuritySite flag |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location where all resources will be created. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `name` | string |  |  | Required. Name of the VPN Site. |
| `o365Policy` | object | `{object}` |  | Optional. The Office365 breakout policy. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualWanId` | string |  |  | Required. Resource ID of the virtual WAN to link to |
| `vpnSiteLinks` | array | `[]` |  | Optional. List of all VPN site links. |

### Parameter Usage `o365Policy`

```json
"o365Policy": {
    "value": {
        "breakOutCategories": {
            "optimize": true,
            "allow": true,
            "default": true
        }
    }
}
```

### Parameter Usage `deviceProperties`

```json
"deviceProperties": {
    "value": {
        "deviceModel": "morty",
        "deviceVendor": "contoso",
        "linkSpeedInMbps": 0
    }
}
```

### Parameter Usage `bgpProperties`

The BGP properties. Note: This is a deprecated property, please use the corresponding `VpnSiteLinks` property instead.

```json
"bgpProperties": {
    "value": {
        "asn": 65010,
        "bgpPeeringAddress": "1.1.1.1",
        "peerWeight": 0
    }
}
```

### Parameter Usage `vpnSiteLinks`

An array of links. Should be used instead of the top-level `ipAddress` & `bgpProperties` properties. If using links,  one default link with same name and properties as VpnSite itself is mandatory.

```json
"vpnSiteLinks": {
    "value": [
        {
            "name": "<<namePrefix>>-az-vSite-x-001",
            "properties": {
                "bgpProperties": {
                    "asn": 65010,
                    "bgpPeeringAddress": "1.1.1.1"
                },
                "ipAddress": "1.2.3.4",
                "linkProperties": {
                    "linkProviderName": "contoso",
                    "linkSpeedInMbps": 5
                }
            }
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the VPN site |
| `resourceGroupName` | string | The resource group the VPN site was deployed into |
| `resourceId` | string | The resource ID of the VPN site |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Vpnsites](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnSites)
