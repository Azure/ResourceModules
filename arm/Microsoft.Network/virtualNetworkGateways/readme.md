# VirtualNetworkGateway

This module deploys a Virtual Network Gateway.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/publicIPAddresses`|2020-08-01|
|`Microsoft.Network/virtualNetworkGateways`|2020-08-01|
|`Microsoft.Network/publicIPAddresses/providers/diagnosticSettings`|2017-05-01-preview|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/virtualNetworkGateways/providers/diagnosticSettings`|2017-05-01-preview|
|`Microsoft.Network/virtualNetworkGateways/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `activeActive` | bool | Optional. Value to specify if the Gateway should be deployed in active-active or active-passive configuration | True |  |
| `asn` | int | Optional. ASN value | 65815 |  |
| `clientRevokedCertThumbprint` | string | Optional. Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |  |  |
| `clientRootCertData` | string | Optional. Client root certificate data used to authenticate VPN clients. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Required. Resource identifier of the Diagnostic Storage Account. |  |  |
| `domainNameLabel` | array | Optional. DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com | System.Object[] |  |
| `enableBgp` | bool | Optional. Value to specify if BGP is enabled or not | True |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `gatewayPipName` | array | Optional. Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Virtual Network Gateway from deletion. | False |  |
| `publicIPPrefixId` | string | Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `virtualNetworkGatewayName` | string | Required. Specifies the Virtual Network Gateway name. |  |  |
| `virtualNetworkGatewaySku` | string | Required. The Sku of the Gateway. |  | System.Object[] |
| `virtualNetworkGatewayType` | string | Required. Specifies the gateway type. E.g. VPN, ExpressRoute |  | System.Object[] | 
| `vNetId` | string | Required. Virtual Network resource Id |  |  |
| `vpnClientAddressPoolPrefix` | string | Optional. The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |  |  |
| `vpnGatewayGeneration` | string | Optional. Specifies the VPN GW generation. | Generation1 | System.Object[] |
| `vpnType` | string | Required. Specifies the VPN type | RouteBased | System.Object[] |
| `workspaceId` | string | Required. Resource identifier of Log Analytics. |  |  |

### Parameter Usage: `subnets`

The `subnets` parameter accepts a JSON Array of `subnet` objects to deploy to the Virtual Network.

Here's an example of specifying a couple Subnets to deploy:

```json
"subnets": {
    "value": [
    {
        "name": "app",
        "properties": {
        "addressPrefix": "10.1.0.0/24",
        "networkSecurityGroup": {
            "id": "[resourceId('Microsoft.Network/networkSecurityGroups', 'app-nsg')]"
        },
        "routeTable": {
            "id": "[resourceId('Microsoft.Network/routeTables', 'app-udr')]"
        }
        }
    },
    {
        "name": "data",
        "properties": {
        "addressPrefix": "10.1.1.0/24"
        }
    }
    ]
}
```

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
| `activeActive` | bool | Shows if the VNet gateway is configured in active-active mode. |
| `virtualNetworkGatewayName` | string | The Name of the Virtual Network Gateway. |
| `virtualNetworkGatewayResourceGroup` | string | The Resource Group the Virtual Network Gateway was deployed. |
| `virtualNetworkGatewayResourceId` | string | The Resource Id of the Virtual Network Gateway. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.Network virtualNetworkGateways template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/virtualnetworkgateways)
- [What is VPN Gateway?](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [ExpressRoute virtual network gateway and FastPath](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways)
- [Public IP address prefix](https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-address-prefix)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
