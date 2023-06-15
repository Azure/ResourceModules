# Virtual Network Gateway Connections `[Microsoft.Network/connections]`

This module deploys a Virtual Network Gateway Connection.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Network/connections` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/connections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Remote connection name. |
| `virtualNetworkGateway1` | object | The primary Virtual Network Gateway. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationKey` | securestring | `''` |  | The Authorization Key to connect to an Express Route Circuit. Used for connection type [ExpressRoute]. |
| `connectionMode` | string | `'Default'` | `[Default, InitiatorOnly, ResponderOnly]` | The connection connectionMode for this connection. Available for IPSec connections. |
| `connectionProtocol` | string | `'IKEv2'` | `[IKEv1, IKEv2]` | Connection connectionProtocol used for this connection. Available for IPSec connections. |
| `connectionType` | string | `'IPsec'` | `[ExpressRoute, IPsec, Vnet2Vnet, VPNClient]` | Gateway connection connectionType. |
| `customIPSecPolicy` | object | `{object}` |  | The IPSec Policies to be considered by this connection. |
| `dpdTimeoutSeconds` | int | `45` |  | The dead peer detection timeout of this connection in seconds. Setting the timeout to shorter periods will cause IKE to rekey more aggressively, causing the connection to appear to be disconnected in some instances. The general recommendation is to set the timeout between 30 to 45 seconds. |
| `enableBgp` | bool | `False` |  | Value to specify if BGP is enabled or not. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enablePrivateLinkFastPath` | bool | `False` |  | Bypass the ExpressRoute gateway when accessing private-links. ExpressRoute FastPath (expressRouteGatewayBypass) must be enabled. Only available when connection connectionType is Express Route. |
| `expressRouteGatewayBypass` | bool | `False` |  | Bypass ExpressRoute Gateway for data forwarding. Only available when connection connectionType is Express Route. |
| `localNetworkGateway2` | object | `{object}` |  | The local network gateway. Used for connection type [IPsec]. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the connectionType of lock. |
| `peer` | object | `{object}` |  | The remote peer. Used for connection connectionType [ExpressRoute]. |
| `routingWeight` | int | `-1` |  | The weight added to routes learned from this BGP speaker. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `useLocalAzureIpAddress` | bool | `False` |  | Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property. |
| `usePolicyBasedTrafficSelectors` | bool | `False` |  | Enable policy-based traffic selectors. |
| `virtualNetworkGateway2` | object | `{object}` |  | The remote Virtual Network Gateway. Used for connection connectionType [Vnet2Vnet]. |
| `vpnSharedKey` | string | `''` |  | Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways. |


### Parameter Usage: `virtualNetworkGateway1`

The primary virtual network gateway object.

<details>

<summary>Parameter JSON format</summary>

```json
"virtualNetworkGateway1": {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway01"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
virtualNetworkGateway1: {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway01'
}
```

</details>
<p>

### Parameter Usage: `virtualNetworkGateway2`

The secondary virtual network gateway used for VNET to VNET connections.

<details>

<summary>Parameter JSON format</summary>

```json
"virtualNetworkGateway2" : {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway02"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
virtualNetworkGateway2 : {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway02'
}
```

</details>
<p>

### Parameter Usage: `localNetworkGateway2`

The local virtual network gateway object.

<details>

<summary>Parameter JSON format</summary>

```json
"localNetworkGateway2": {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
localNetworkGateway2: {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway'
}
```

</details>
<p>

### Parameter Usage: `peer`

The remote peer object used for ExpressRoute connections

<details>

<summary>Parameter JSON format</summary>

```json
"peer": {
    "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'peer': {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute'
}
```

</details>
<p>

### Parameter Usage: `customIPSecPolicy`

If ipsecEncryption parameter is empty, customIPSecPolicy will not be deployed. The parameter file should look like below.

<details>

<summary>Parameter JSON format</summary>

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
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 0
    saDataSizeKilobytes: 0
    ipsecEncryption: ''
    ipsecIntegrity: ''
    ikeEncryption: ''
    ikeIntegrity: ''
    dhGroup: ''
    pfsGroup: ''
}
```

</details>
<p>

Format of the full customIPSecPolicy parameter in parameter file.

<details>

<summary>Parameter JSON format</summary>

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
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 28800
    saDataSizeKilobytes: 102400000
    ipsecEncryption: 'AES256'
    ipsecIntegrity: 'SHA256'
    ikeEncryption: 'AES256'
    ikeIntegrity: 'SHA256'
    dhGroup: 'DHGroup14'
    pfsGroup: 'None'
}
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remote connection. |
| `resourceGroupName` | string | The resource group the remote connection was deployed into. |
| `resourceId` | string | The resource ID of the remote connection. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Vnet2vnet</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module connections './network/connections/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ncvtv'
  params: {
    // Required parameters
    name: '<<namePrefix>>ncvtv001'
    virtualNetworkGateway1: {
      id: '<id>'
    }
    // Non-required parameters
    connectionType: 'Vnet2Vnet'
    enableBgp: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    virtualNetworkGateway2: {
      id: '<id>'
    }
    vpnSharedKey: '<vpnSharedKey>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>ncvtv001"
    },
    "virtualNetworkGateway1": {
      "value": {
        "id": "<id>"
      }
    },
    // Non-required parameters
    "connectionType": {
      "value": "Vnet2Vnet"
    },
    "enableBgp": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkGateway2": {
      "value": {
        "id": "<id>"
      }
    },
    "vpnSharedKey": {
      "value": "<vpnSharedKey>"
    }
  }
}
```

</details>
<p>
