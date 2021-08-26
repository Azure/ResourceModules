# AzureBastion

This module deploys an Azure Bastion.

## Resource Types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/publicIPAddresses`|2020-08-01|
|`Microsoft.Network/bastionHosts`|2020-08-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/publicIPAddresses/providers/diagnosticSettings`|2017-05-01-preview|
|`Microsoft.Network/bastionHosts/providers/diagnosticSettings`|2017-05-01-preview|
|`Microsoft.Network/bastionHosts/providers/roleAssignments`	|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `azureBastionName` | string | Required. Name of the Azure Bastion resource |  |  |
| `azureBastionPipName` | string | Optional. Specifies the name of the Public IP used by Azure Bastion. If it's not provided, a '-pip' suffix will be appended to the Bastion's name. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `domainNameLabel` | string | Optional. DNS name of the Public IP resource. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False |  |
| `publicIPPrefixId` | string | Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `vNetId` | string | Required. Shared services Virtual Network resource identifier |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `azureBastionName` | string | The Name of the Azure Bastion. |
| `azureBastionResourceGroup` | string | The Resource Group the Azure Bastion was deployed. |
| `azureBastionResourceId` | string | The Resource Id of the Azure Bastion. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.Network bastionHosts template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-09-01/bastionhosts)
- [What is Azure Bastion?](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Public IP address prefix](https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-address-prefix)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
