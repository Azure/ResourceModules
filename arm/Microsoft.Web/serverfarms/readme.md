# App Service Plans `[Microsoft.Web/serverfarms]`

This module deploys an app service plan.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Web/serverfarms` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appServiceEnvironmentId` | string |  |  | Optional. The Resource ID of the App Service Environment to use for the App Service Plan. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `maximumElasticWorkerCount` | int | `1` |  | Optional. Maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan. |
| `name` | string |  |  | Required. The name of the app service plan to deploy. |
| `perSiteScaling` | bool |  |  | Optional. If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `serverOS` | string | `Windows` | `[Windows, Linux]` | Optional. Kind of server OS. |
| `sku` | object |  |  | Required. Defines the name, tier, size, family and capacity of the App Service Plan. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `targetWorkerCount` | int |  |  | Optional. Scaling worker count. |
| `targetWorkerSize` | int |  | `[0, 1, 2]` | Optional. The instance size of the hosting plan (small, medium, or large). |
| `workerTierName` | string |  |  | Optional. Target worker tier assigned to the App Service plan. |

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
| `appServicePlanName` | string | The name of the app service plan |
| `appServicePlanResourceGroup` | string | The resource group the app service plan was deployed into |
| `appServicePlanResourceId` | string | The resource ID of the app service plan |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Serverfarms](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/serverfarms)
