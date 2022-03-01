# Network Private Endpoint Private DNS Zone Group `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a private endpoint private DNS zone group

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. The name of the private DNS Zone Group |
| `privateDNSResourceIds` | array |  |  | Required. List of private DNS resource IDs |
| `privateEndpointName` | string |  |  | Required. The name of the private endpoint |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the private endpoint DNS zone group |
| `resourceGroupName` | string | The resource group the private endpoint DNS zone group was deployed into |
| `resourceId` | string | The resource ID of the private endpoint DNS zone group |

## Template references

- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints/privateDnsZoneGroups)
