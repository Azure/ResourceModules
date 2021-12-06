# Private DNS Zones `[Microsoft.Network/privateDnsZones]`

This template deploys a private DNS zone.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Network/privateDnsZones` | 2018-09-01 |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2018-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `location` | string | `global` |  | Optional. The location of the PrivateDNSZone. Should be global. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `name` | string |  |  | Required. Private DNS zone name. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualNetworkLinks` | _[virtualNetworkLinks](virtualNetworkLinks/readme.md)_ array | `[]` |  | Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'vnetResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet. |

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
| `privateDnsZoneName` | string | The name of the private DNS zone |
| `privateDnsZoneResourceGroup` | string | The resource group the private DNS zone was deployed into |
| `privateDnsZoneResourceId` | string | The resource ID of the private DNS zone |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Privatednszones](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-09-01/privateDnsZones)
- [Privatednszones/Virtualnetworklinks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-09-01/privateDnsZones/virtualNetworkLinks)
