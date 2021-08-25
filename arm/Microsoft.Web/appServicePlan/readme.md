# AppServicePlan

This module deploys an App Service Plan.


## Resource Types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Web/serverfarms`|2019-08-01|
|`providers/locks`|2016-09-01| 
|`Microsoft.Web/serverfarms/providers/roleAssignments`|2018-09-01-preview|


## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `appServiceEnvironmentId` | string | Optional. The Resource Id of the App Service Environment to use for the App Service Plan. |  |  |
| `appServicePlanName` | string | Required. The Name of the App Service Plan to deploy. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock App Service Plan from deletion. | False |  |
| `maximumElasticWorkerCount` | int | Optional. Maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan. | 1 |  |
| `perSiteScaling` | bool | Optional. If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `serverOS` | string | Optional. Kind of server OS. | Windows | System.Object[] |
| `sku` | object | Required. Defines the name, tier, size, family and capacity of the App Service Plan. |  |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `targetWorkerCount` | int | Optional. Scaling worker count. | 0 |  |
| `targetWorkerSize` | int | Optional. The instance size of the hosting plan (small, medium, or large). | 0 | System.Object[] |
| `workerTierName` | string | Optional. Target worker tier assigned to the App Service plan. |  |  |

### Parameter Usage: `sku`

```json
"sku": {
    "value": {
        "name": "P1v2",
        "tier": "PremiumV2",
        "size": "P1v2",
        "family": "Pv2",
        "capacity": 1
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
| `appServicePlanName` | string | The Name of the App Service Plan that was deployed. |
| `appServicePlanResourceGroup` | string | The Resource Group the App Service Plan was deployed to. |
| `appServicePlanResourceId` | string | The Resource Id of the App Service Plan that was deployed. |

## Considerations

*N/A*

## Additional resources

- [Azure App Service plan overview](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
- [Microsoft.Web serverfarms template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/2019-08-01/serverfarms)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)