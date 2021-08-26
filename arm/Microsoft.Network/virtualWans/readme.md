# Virtual Wan

This template deploys Virtual Wan


## Resource types

|ResourceType|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/virtualWans`|2020-08-01|
|`Microsoft.Network/virtualHubs`|2020-08-01|
|`Microsoft.Network/vpnSites`|2020-08-01|
|`Microsoft.Network/vpnGateways`|2020-08-01|
|`Microsoft.Network/virtualWans/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `wanName` | string | | | Required. Name given for the Route Table.
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `wanSku` | string | Standard |  | Optional. Sku of the Virtual Wan.
| `hubName` | string | SampleVirtualHub | | Optional. Name of the Virtual Hub. A virtual hub is created inside a virtual wan.
| `vpnGatewayName` | string | SampleVpnGateway | | Optional. Name of the Vpn Gateway. A vpn gateway is created inside a virtual hub.
| `vpnSiteName` | string | SampleVpnSite | | Optional. Name of the vpnsite. A vpnsite represents the on-premise vpn device. A public ip address is mandatory for a vpn site creation.
| `connectionName` | string | SampleVpnsiteVpnGwConnection | | Optional. Name of the vpnconnection. A vpn connection is established between a vpnsite and a vpn gateway.
| `vpnsiteAddressspaceList` | array | [] | | Optional. A list of static routes corresponding to the vpn site. These are configured on the vpn gateway.
| `vpnsitePublicIPAddress` | string | | | Required. he public IP address of a vpn site.
| `vpnsiteBgpAsn` | int | | | Required. The bgp asn number of a vpnsite.
| `vpnsiteBgpPeeringAddress` | string | | | Required. The bgp peer IP address of a vpnsite.
| `addressPrefix` | string | 192.168.0.0/24 | | Optional. The hub address prefix. This address prefix will be used as the address prefix for the hub vnet
| `enableBgp` | string | false | | Optional. his needs to be set to true if BGP needs to enabled on the vpn connection.
| `roleAssignments` | array | [] | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
| `tags` | object | {} | Complex structure, see below. | Optional. Tags of the Virtual Wan resource.
| `cuaId` | string | "" | | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.

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
| `wanName` | string | The name of the WAN. |
| `wanNameResourceGroup` | string | The Resource Group in which the resource is created. |
| `wanNameResourceId` | string | The Reeosurce ID of the WAN. |

## Considerations

- Please note that this module is using a customized removal step. Instead of using a global removal step (Modules\ARM\.global\PipelineTemplates\pipeline.jobs.remove.yml), the module has its own, customized removal, located in the module's 'Pipeline' folder: (Modules\ARM\VirtualWan\Pipeline\pipeline.jobs.remove.VirtualWAN.yml)

## Additional resources

- [Microsoft.Network virtualWans template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-09-01/virtualwans)
- [About Azure Virtual Wan](https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about)