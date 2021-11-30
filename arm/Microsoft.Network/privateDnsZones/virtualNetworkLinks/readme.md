# Private DNS Zone Virtual Network Link `[Microsoft.Network/privateDnsZones/virtualNetworkLinks]`

This module deploys private dns zone virtual network links.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2018-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `location` | string | `global` |  | Optional. The location of the PrivateDNSZone. Should be global. |
| `name` | string | `[last(split(parameters('virtualNetworkResourceId'), '/'))]` |  | Optional. The name of the virtual network link. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `registrationEnabled` | bool |  |  | Optional. Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualNetworkResourceId` | string |  |  | Required. Link to another virtual network resource ID. |

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
| `virtualNetworkLinkName` | string | The name of the deployed virtual network link |
| `virtualNetworkLinkResourceGroup` | string | The resource group of the deployed virtual network link |
| `virtualNetworkLinkResourceId` | string | The resource ID of the deployed virtual network link |

## Template references

- [Privatednszones/Virtualnetworklinks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-09-01/privateDnsZones/virtualNetworkLinks)
