# VPN Sites `[Microsoft.Network/vpnSites]`

This module deploys a VPN Site.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Network/vpnSites` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnSites) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the VPN Site. |
| `virtualWanId` | string | Resource ID of the virtual WAN to link to. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefixes` | array | `[]` |  | An array of IP address ranges that can be used by subnets of the virtual network. Must be provided if no bgpProperties or VPNSiteLinks are configured. |
| `bgpProperties` | object | `{object}` |  | BGP settings details. Must be provided if no addressPrefixes or VPNSiteLinks are configured. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. |
| `deviceProperties` | object | `{object}` |  | List of properties of the device. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ipAddress` | string | `''` |  | The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. |
| `isSecuritySite` | bool | `False` |  | IsSecuritySite flag. |
| `location` | string | `[resourceGroup().location]` |  | Location where all resources will be created. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `o365Policy` | object | `{object}` |  | The Office365 breakout policy. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vpnSiteLinks` | array | `[]` |  | List of all VPN site links. |


### Parameter Usage `o365Policy`

<details>

<summary>Parameter JSON format</summary>

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

</details>


<details>

<summary>Bicep format</summary>

```bicep
o365Policy: {
    breakOutCategories: {
        optimize: true
        allow: true
        default: true
    }
}
```

</details>
<p>

### Parameter Usage `deviceProperties`

<details>

<summary>Parameter JSON format</summary>

```json
"deviceProperties": {
    "value": {
        "deviceModel": "morty",
        "deviceVendor": "contoso",
        "linkSpeedInMbps": 0
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
deviceProperties: {
    deviceModel: 'morty'
    deviceVendor: 'contoso'
    linkSpeedInMbps: 0
}
```

</details>
<p>

### Parameter Usage `bgpProperties`

The BGP properties. Note: This is a deprecated property, please use the corresponding `VpnSiteLinks` property instead.

<details>

<summary>Parameter JSON format</summary>

```json
"bgpProperties": {
    "value": {
        "asn": 65010,
        "bgpPeeringAddress": "1.1.1.1",
        "peerWeight": 0
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
bgpProperties: {
    asn: 65010
    bgpPeeringAddress: '1.1.1.1'
    peerWeight: 0
}
```

</details>
<p>

### Parameter Usage `vpnSiteLinks`

An array of links. Should be used instead of the top-level `ipAddress` & `bgpProperties` properties. If using links,  one default link with same name and properties as VpnSite itself is mandatory.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
vpnSiteLinks: [
    {
        name: '<<namePrefix>>-az-vSite-x-001'
        properties: {
            bgpProperties: {
                asn: 65010
                bgpPeeringAddress: '1.1.1.1'
            }
            ipAddress: '1.2.3.4'
            linkProperties: {
                linkProviderName: 'contoso'
                linkSpeedInMbps: 5
            }
        }
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VPN site. |
| `resourceGroupName` | string | The resource group the VPN site was deployed into. |
| `resourceId` | string | The resource ID of the VPN site. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-vSite-min-001"
        },
        "addressPrefixes": {
            "value": [
                "10.0.0.0/16"
            ]
        },
        "ipAddress": {
            "value": "1.2.3.4"
        },
        "virtualWanId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualWans/apd-<<namePrefix>>-az-vw-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module vpnSites './Microsoft.Network/vpnSites/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-vpnSites'
  params: {
    name: '<<namePrefix>>-az-vSite-min-001'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    ipAddress: '1.2.3.4'
    virtualWanId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualWans/apd-<<namePrefix>>-az-vw-x-001'
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-vSite-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "tags": {
            "value": {
                "tagA": "valueA",
                "tagB": "valueB"
            }
        },
        "deviceProperties": {
            "value": {
                "linkSpeedInMbps": 0
            }
        },
        "virtualWanId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualWans/apd-<<namePrefix>>-az-vw-x-001"
        },
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
                },
                {
                    "name": "Link1",
                    "properties": {
                        "bgpProperties": {
                            "asn": 65020,
                            "bgpPeeringAddress": "192.168.1.0"
                        },
                        "ipAddress": "2.2.2.2",
                        "linkProperties": {
                            "linkProviderName": "contoso",
                            "linkSpeedInMbps": 5
                        }
                    }
                }
            ]
        },
        "o365Policy": {
            "value": {
                "breakOutCategories": {
                    "optimize": true,
                    "allow": true,
                    "default": true
                }
            }
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module vpnSites './Microsoft.Network/vpnSites/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-vpnSites'
  params: {
    name: '<<namePrefix>>-az-vSite-x-001'
    lock: 'CanNotDelete'
    tags: {
      tagA: 'valueA'
      tagB: 'valueB'
    }
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    virtualWanId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualWans/apd-<<namePrefix>>-az-vw-x-001'
    vpnSiteLinks: [
      {
        name: '<<namePrefix>>-az-vSite-x-001'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
    ]
    o365Policy: {
      breakOutCategories: {
        optimize: true
        allow: true
        default: true
      }
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>
