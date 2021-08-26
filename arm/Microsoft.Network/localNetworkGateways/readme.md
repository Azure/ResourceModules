# Local Network Gateway

This module deploys Local Network Gateway, with resource lock.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/localNetworkGateways`|2020-08-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/localNetworkGateways/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `localAddressPrefixes` | array | Required. List of the local (on-premises) IP address ranges |  |  |
| `localAsn` | string | Optional. The BGP speaker's ASN. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |  |  |
| `localBgpPeeringAddress` | string | Optional. The BGP peering address and BGP identifier of this BGP speaker. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |  |  |
| `localGatewayPublicIpAddress` | string | Required. Public IP of the local gateway |  |  |
| `localNetworkGatewayName` | string | Required. Name of the Local Network Gateway |  |  |
| `localPeerWeight` | string | Optional. The weight added to routes learned from this BGP speaker. This will only take effect if both the localAsn and the localBgpPeeringAddress values are provided. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Local Network Gateway from deletion. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `fqdn` | string | Optional. FQDN for local gateway (on-prem gateway). | | |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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
| `localNetworkGatewayName` | string | The Name of the Local Network Gateway. |
| `localNetworkGatewayResourceGroup` | string | The name of the Resource Group the Local Network Gateway was created in. |        
| `localNetworkGatewayResourceId` | string | The Resource Id of the Local Network Gateway. |

## Considerations

*N/A*

## Additional resources

- [What is VPN Gateway?](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)