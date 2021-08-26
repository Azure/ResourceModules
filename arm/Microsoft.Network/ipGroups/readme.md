# KeyVault

This module deploys an IP Group, with resource lock.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Network/ipGroups`|2020-08-01|
|`Microsoft.Resources/deployments`|2020-06-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/ipGroups/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `ipGroupName` | string | | | Required. The name of the ipGroups.
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `ipAddresses` | array | `[]` |  | Optional. IpAddresses/IpAddressPrefixes in the IpGroups resource.
| `lockForDeletion` | bool | `true` | | Optional. Switch to lock Azure Key Vault from deletion.
| `roleAssignments` | array | [] | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
| `tags` | object | {} | Complex structure, see below. | Optional. Tags of the Azure Key Vault resource.
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
| `ipGroupsResourceId` | string | The Resource Id of the IP Group. |
| `ipGroupsResourceGroup` | string | The name of the Resource Group the IP Group was created in. |
| `ipGroupName` | string | The Name of the IP Group. |

## Considerations

*N/A*

## Additional resources

- [IP Groups in Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/ip-groups)
- [Microsoft.Network ipGroups template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2020-05-01/ipgroups)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)