# AzureSQLDatabase

This module deploys an Azure SQL Server.

## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Sql/servers/databases`|2017-10-01-preview|
|`Microsoft.Network/privateEndpoints`|2019-02-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `autoPauseDelay` | string | Optional. Time in minutes after which database is automatically paused. |  |  |
| `collation` | string | Optional. The collation of the database. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `databaseName` | string | Required. The name of the database. |  |  |
| `enableADS` | bool | Optional. Whether or not ADS is enabled. | False |  |
| `enablePrivateEndpoint` | bool | Optional. Whether or not private Endpoint is enabled | False |  |
| `enableVA` | bool | Optional. Whether or not VA is enabled. | False |  |
| `licenseType` | string | Optional. The license type to apply for this database. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `maxSizeBytes` | int | Optional. The max size of the database expressed in bytes. |  |  |
| `minCapacity` | string | Optional. Minimal capacity that database will always have allocated. |  |  |
| `numberOfReplicas` | int | Optional. The number of readonly secondary replicas associated with the database. | 0 |  |      
| `privateEndpointLocation` | string | Optional. This is not required anymore. |  |  |
| `privateEndpointName` | string | Optional. Private Endpoint Name. |  |  |
| `privateEndpointNestedTemplateId` | string | Optional. Nested template ID. |  |  |
| `privateEndpointResourceGroup` | string | Optional. private Endpoint Resource Group. |  |  |
| `privateEndpointSubnetId` | string | Optional. Subnet of Private endpoint. |  |  |
| `privateEndpointSubscriptionId` | string | Optional. This is not requried anymore. |  |  |
| `privateLinkServiceName` | string | Optional. privatelink service name. |  |  |
| `privateLinkServiceServiceId` | string | Optional. For setting service connection. |  |  |
| `readScaleOut` | string | Optional. The state of read-only routing. | Disabled |  |
| `sampleName` | string | Optional. The name of the sample schema to apply when creating this database. |  |  |
| `serverName` | string | Required. The Name of SQL Server |  |  |
| `skuName` | string | Required. The name of the SKU. |  |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `tier` | string | Optional. The tier or edition of the particular SKU. |  |  |
| `zoneRedundant` | bool | Optional. Whether or not this database is zone redundant. | False |  |

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
| `databaseName` | string | The name of the created database. |
| `databaseResourceGroup` | string | Name of the Databse ResourceGroup. |
| `serverName` | string | The name of the target SQL Server instance. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.Network bastionHosts template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-09-01/bastionhosts)
- [What is Azure Bastion?](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Public IP address prefix](https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-address-prefix)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
