# NetworkPrivateendpointsPrivatednszonegroups `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `privateDNSIds` | array |  |  | Required. List of private DNS Ids |
| `privateEndpointName` | string |  |  | Required. The name of the private endpoint |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `privateDnsZoneGroupName` | string | The name of the private endpoint DNS zone group |
| `privateDnsZoneGroupResourceGroup` | string | The resource group the private endpoint DNS zone group was deployed into |
| `privateDnsZoneGroupResourceId` | string | The resourceId of the private endpoint DNS zone group |

## Template references

- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints/privateDnsZoneGroups)
