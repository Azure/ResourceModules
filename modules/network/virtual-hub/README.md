# Virtual Hubs `[Microsoft.Network/virtualHubs]`

This module deploys a Virtual Hub.
If you are planning to deploy a Secure Virtual Hub (with an Azure Firewall integrated), please refer to the Azure Firewall module.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Network/virtualHubs` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs) |
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubRouteTables) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubVirtualNetworkConnections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.virtual-hub:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHub 'br:bicep/modules/network.virtual-hub:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nvhcom'
  params: {
    // Required parameters
    addressPrefix: '10.1.0.0/16'
    name: 'nvhcom'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hubRouteTables: [
      {
        name: 'routeTable1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
        routingConfiguration: {
          associatedRouteTable: {
            id: '<id>'
          }
          propagatedRouteTables: {
            ids: [
              {
                id: '<id>'
              }
            ]
            labels: [
              'none'
            ]
          }
        }
      }
    ]
    lock: 'CanNotDelete'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "addressPrefix": {
      "value": "10.1.0.0/16"
    },
    "name": {
      "value": "nvhcom"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hubRouteTables": {
      "value": [
        {
          "name": "routeTable1"
        }
      ]
    },
    "hubVirtualNetworkConnections": {
      "value": [
        {
          "name": "connection1",
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
          "routingConfiguration": {
            "associatedRouteTable": {
              "id": "<id>"
            },
            "propagatedRouteTables": {
              "ids": [
                {
                  "id": "<id>"
                }
              ],
              "labels": [
                "none"
              ]
            }
          }
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHub 'br:bicep/modules/network.virtual-hub:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nvhmin'
  params: {
    // Required parameters
    addressPrefix: '10.0.0.0/16'
    name: 'nvhmin'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "addressPrefix": {
      "value": "10.0.0.0/16"
    },
    "name": {
      "value": "nvhmin"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-addressprefix) | string | Address-prefix for this VirtualHub. |
| [`name`](#parameter-name) | string | The virtual hub name. |
| [`virtualWanId`](#parameter-virtualwanid) | string | Resource ID of the virtual WAN to link to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBranchToBranchTraffic`](#parameter-allowbranchtobranchtraffic) | bool | Flag to control transit for VirtualRouter hub. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`expressRouteGatewayId`](#parameter-expressroutegatewayid) | string | Resource ID of the Express Route Gateway to link to. |
| [`hubRouteTables`](#parameter-hubroutetables) | array | Route tables to create for the virtual hub. |
| [`hubVirtualNetworkConnections`](#parameter-hubvirtualnetworkconnections) | array | Virtual network connections to create for the virtual hub. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`p2SVpnGatewayId`](#parameter-p2svpngatewayid) | string | Resource ID of the Point-to-Site VPN Gateway to link to. |
| [`preferredRoutingGateway`](#parameter-preferredroutinggateway) | string | The preferred routing gateway types. |
| [`routeTableRoutes`](#parameter-routetableroutes) | array | VirtualHub route tables. |
| [`securityPartnerProviderId`](#parameter-securitypartnerproviderid) | string | ID of the Security Partner Provider to link to. |
| [`securityProviderName`](#parameter-securityprovidername) | string | The Security Provider name. |
| [`sku`](#parameter-sku) | string | The sku of this VirtualHub. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualHubRouteTableV2s`](#parameter-virtualhubroutetablev2s) | array | List of all virtual hub route table v2s associated with this VirtualHub. |
| [`virtualRouterAsn`](#parameter-virtualrouterasn) | int | VirtualRouter ASN. |
| [`virtualRouterIps`](#parameter-virtualrouterips) | array | VirtualRouter IPs. |
| [`vpnGatewayId`](#parameter-vpngatewayid) | string | Resource ID of the VPN Gateway to link to. |

### Parameter: `addressPrefix`

Address-prefix for this VirtualHub.
- Required: Yes
- Type: string

### Parameter: `allowBranchToBranchTraffic`

Flag to control transit for VirtualRouter hub.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `expressRouteGatewayId`

Resource ID of the Express Route Gateway to link to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `hubRouteTables`

Route tables to create for the virtual hub.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `hubVirtualNetworkConnections`

Virtual network connections to create for the virtual hub.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The virtual hub name.
- Required: Yes
- Type: string

### Parameter: `p2SVpnGatewayId`

Resource ID of the Point-to-Site VPN Gateway to link to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `preferredRoutingGateway`

The preferred routing gateway types.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', ExpressRoute, None, VpnGateway]`

### Parameter: `routeTableRoutes`

VirtualHub route tables.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `securityPartnerProviderId`

ID of the Security Partner Provider to link to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `securityProviderName`

The Security Provider name.
- Required: No
- Type: string
- Default: `''`

### Parameter: `sku`

The sku of this VirtualHub.
- Required: No
- Type: string
- Default: `'Standard'`
- Allowed: `[Basic, Standard]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `virtualHubRouteTableV2s`

List of all virtual hub route table v2s associated with this VirtualHub.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualRouterAsn`

VirtualRouter ASN.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `virtualRouterIps`

VirtualRouter IPs.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualWanId`

Resource ID of the virtual WAN to link to.
- Required: Yes
- Type: string

### Parameter: `vpnGatewayId`

Resource ID of the VPN Gateway to link to.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual hub. |
| `resourceGroupName` | string | The resource group the virtual hub was deployed into. |
| `resourceId` | string | The resource ID of the virtual hub. |

## Cross-referenced modules

_None_
