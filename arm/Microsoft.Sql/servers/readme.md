# AzureSQLServer

This module deploys an Azure SQL Server.


## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Sql/servers`|2015-05-01-preview|
|`firewallrules`|2014-04-01-preview|
|`securityAlertPolicies`|2017-03-01-preview|
|`Microsoft.Sql/servers/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string | Required. Administrator username for the server. |  |  |
| `administratorLoginPassword` | securestring | Required. The administrator login password. |  |  |
| `allowAzureIps` | bool | Required. Whether or not Azure IP's are allowed. | False |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `enableADS` | bool | Optional. Whether or not ADS should be enabled. | False |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `serverName` | string | Required. The name of the server. |  |  |
| `tags` | object | Optional. Tags of the resource. |  |  |

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
| `serverName` | string | The name of the target SQL Server instance. |
| `serverResourceGroup` | string | The Resource Group in which the server is created. |
| `serverResourceId` | string | The resource ID of the server. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.Network bastionHosts template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-09-01/bastionhosts)
- [What is Azure Bastion?](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Public IP address prefix](https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-address-prefix)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
