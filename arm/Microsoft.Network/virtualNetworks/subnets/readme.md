# Virtual Network Subnets `[Microsoft.Network/virtualNetworks/subnets]`

This module deploys a virtual network subnet.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/subnets` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefix` | string | The address prefix for the subnet. |
| `virtualNetworkName` | string | The name of the parent virtual network |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefixes` | array | `[]` |  | List of address prefixes for the subnet. |
| `applicationGatewayIpConfigurations` | array | `[]` |  | Application gateway IP configurations of virtual network resource. |
| `delegations` | array | `[]` |  | The delegations to enable on the subnet |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ipAllocations` | array | `[]` |  | Array of IpAllocation which reference this subnet |
| `name` | string |  |  | The Name of the subnet resource. |
| `natGatewayId` | string | `''` |  | The resource ID of the NAT Gateway to use for the subnet |
| `networkSecurityGroupId` | string | `''` |  | The resource ID of the network security group to assign to the subnet |
| `privateEndpointNetworkPolicies` | string | `''` | `[Disabled, Enabled, ]` | enable or disable apply network policies on private endpoint in the subnet. |
| `privateLinkServiceNetworkPolicies` | string | `''` | `[Disabled, Enabled, ]` | enable or disable apply network policies on private link service in the subnet. |
| `routeTableId` | string | `''` |  | The resource ID of the route table to assign to the subnet |
| `serviceEndpointPolicies` | array | `[]` |  | An array of service endpoint policies. |
| `serviceEndpoints` | array | `[]` |  | The service endpoints to enable on the subnet |


### Parameter Usage: `delegations`

```json
"delegations": [
    {
        "name": "sqlMiDel",
        "properties": {
            "serviceName": "Microsoft.Sql/managedInstances"
        }
    }
]
```

### Parameter Usage: `serviceEndpoints`

```json
"serviceEndpoints": [
    "Microsoft.EventHub",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
]
```

## Considerations

The `privateEndpointNetworkPolicies` property must be set to disabled for subnets that contain private endpoints. It confirms that NSGs rules will not apply to private endpoints (currently not supported, [reference](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#limitations)). Default Value when not specified is "Enabled".


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network peering |
| `resourceGroupName` | string | The resource group the virtual network peering was deployed into |
| `resourceId` | string | The resource ID of the virtual network peering |
| `subnetAddressPrefix` | string | The address prefix for the subnet |
| `subnetAddressPrefixes` | array | List of address prefixes for the subnet |

## Template references

- [Virtualnetworks/Subnets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualNetworks/subnets)
