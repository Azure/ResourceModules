# DDoS Protection Plans

This template deploys a DDoS protection plan.


## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/ddosProtectionPlans`|2020-08-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/ddosProtectionPlans/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `ddosProtectionPlanName` | string | Required. Name of the DDoS protection plan to assign the VNET to. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock DDoS protection plan from deletion. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
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
| `ddosProtectionPlanName` | string | The name of the DDoS Protection Plan deployed. |
| `ddosProtectionPlanResourceGroup` | string | The name of the Resource Group the DDoS Protection Plan was created in. |
| `ddosProtectionPlanResourceId` | string | The Resource id of the DDoS Protection Plan deployed. |

## Considerations

N/A

## Additional resources

- [Microsoft.Network ddosProtectionPlans template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-04-01/ddosprotectionplans)
- [Manage Azure DDoS Protection Standard using the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/manage-ddos-protection)
- [Azure DDoS Protection Standard overview](https://docs.microsoft.com/en-us/azure/virtual-network/ddos-protection-overview)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)