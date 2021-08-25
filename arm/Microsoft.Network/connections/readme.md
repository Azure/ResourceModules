# VirtualNetworkGatewayConnection

This template deploys Virtual Network Gateway Connection.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/connections`|2020-08-01|
|`providers/locks`|2016-09-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `connectionName` | string | Required. Remote connection name |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `customIPSecPolicy` | object | Optional. The IPSec Policies to be considered by this connection | @{saLifeTimeSeconds=0; saDataSizeKilobytes=0; ipsecEncryption=; ipsecIntegrity=; ikeEncryption=; ikeIntegrity=; dhGroup=; pfsGroup=} |  |
| `enableBgp` | bool | Optional. Value to specify if BGP is enabled or not | False |  |
| `localVirtualNetworkGatewayName` | string | Required. Specifies the local Virtual Network Gateway name |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Connection from deletion. | False |  |
| `remoteEntityName` | string | Required. Specifies the remote Virtual Network Gateway/ExpressRoute |  |  |
| `remoteEntityResourceGroup` | string | Optional. Remote Virtual Network Gateway/ExpressRoute resource group name |  |  |   
| `remoteEntitySubscriptionId` | string | Optional. Remote Virtual Network Gateway/ExpressRoute Subscription Id |  |  |      
| `routingWeight` | string | Optional. The weight added to routes learned from this BGP speaker. |  | |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `usePolicyBasedTrafficSelectors` | bool | Optional. Enable policy-based traffic selectors | False | |
| `virtualNetworkGatewayConnectionType` | string | Optional. Gateway connection type. | Ipsec | System.Object[] |
| `vpnSharedKey` | string | Required. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways |  |  |

### Parameter Usage: `customIPSecPolicy`

If ipsecEncryption parameter is empty, customIPSecPolicy will not be deployed. The parameter file should look like below.

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 0,
        "saDataSizeKilobytes": 0,
        "ipsecEncryption": "",
        "ipsecIntegrity": "",
        "ikeEncryption": "",
        "ikeIntegrity": "",
        "dhGroup": "",
        "pfsGroup": ""
    }
},
```

Format of the full customIPSecPolicy parameter in parameter file.

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 28800,
        "saDataSizeKilobytes": 102400000,
        "ipsecEncryption": "AES256",
        "ipsecIntegrity": "SHA256",
        "ikeEncryption": "AES256",
        "ikeIntegrity": "SHA256",
        "dhGroup": "DHGroup14",
        "pfsGroup": "None"
    }
},
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
| `connectionName` | string | The Name of the Virtual Network Gateway Connection. |
| `remoteConnectionResourceGroup` | string | The Resource Group deployed it. |
| `remoteConnectionResourceId` | string | The Resource Id of the Virtual Network Gateway Connection. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.Network connections template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/connections)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
