# Private DNS Zone Virtual Network Link `[Microsoft.Network/privateDnsZones/virtualNetworkLinks]`

This module deploys private dns zone virtual network links.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2020-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateDnsZoneName` | string | Private DNS zone name. |
| `virtualNetworkResourceId` | string | Link to another virtual network resource ID. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `'global'` | The location of the PrivateDNSZone. Should be global. |
| `name` | string | `[format('{0}-vnetlink', last(split(parameters('virtualNetworkResourceId'), '/')))]` | The name of the virtual network link. |
| `registrationEnabled` | bool | `False` | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? |
| `tags` | object | `{object}` | Tags of the resource. |


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
| `name` | string | The name of the deployed virtual network link |
| `resourceGroupName` | string | The resource group of the deployed virtual network link |
| `resourceId` | string | The resource ID of the deployed virtual network link |

## Template references

- [Privatednszones/Virtualnetworklinks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks)
