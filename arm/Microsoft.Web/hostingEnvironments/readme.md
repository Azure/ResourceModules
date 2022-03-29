# App Service Environments `[Microsoft.Web/hostingEnvironments]`

This module deploys an app service environment.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Web/hostingEnvironments` | 2021-02-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the App Service Environment |
| `subnetResourceId` | string | ResourceId for the sub net |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementAccountId` | string | `''` |  | API Management Account associated with the App Service Environment. |
| `clusterSettings` | array | `[]` |  | Custom settings for changing the behavior of the App Service Environment |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[AppServiceEnvironmentPlatformLogs]` | `[AppServiceEnvironmentPlatformLogs]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `dnsSuffix` | string | `''` |  | DNS suffix of the App Service Environment. |
| `dynamicCacheEnabled` | bool | `False` |  | True/false indicating whether the App Service Environment is suspended. The environment can be suspended e.g. when the management endpoint is no longer available(most likely because NSG blocked the incoming traffic). |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `frontEndScaleFactor` | int | `15` |  | Scale factor for frontends. |
| `hasLinuxWorkers` | bool | `False` |  | Flag that displays whether an ASE has linux workers or not |
| `internalLoadBalancingMode` | string | `'None'` | `[None, Web, Publishing]` | Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing |
| `ipsslAddressCount` | int | `2` |  | Number of IP SSL addresses reserved for the App Service Environment. |
| `kind` | string | `'ASEV2'` |  | Kind of resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `multiRoleCount` | int | `2` |  | Number of frontend instances. |
| `multiSize` | string | `'Standard_D1_V2'` | `[Medium, Large, ExtraLarge, Standard_D2, Standard_D3, Standard_D4, Standard_D1_V2, Standard_D2_V2, Standard_D3_V2, Standard_D4_V2]` | Frontend VM size, e.g. Medium, Large |
| `networkAccessControlList` | array | `[]` |  | Access control list for controlling traffic to the App Service Environment.. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `suspended` | bool | `False` |  | true if the App Service Environment is suspended; otherwise, false. The environment can be suspended, e.g. when the management endpoint is no longer available (most likely because NSG blocked the incoming traffic). |
| `tags` | object | `{object}` |  | Resource tags. |
| `userWhitelistedIpRanges` | array | `[]` |  | User added ip ranges to whitelist on ASE db - string |
| `workerPools` | array | `[]` |  | Description of worker pools with worker size IDs, VM sizes, and number of workers in each pool.. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
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

### Parameter Usage: `workerPools`

```json
"workerPools": {
    "value": {
        "workerPools": [
          {
            "workerSizeId": 0,
            "workerSize": "Small",
            "workerCount": 2
          },
          {
            "workerSizeId": 1,
            "workerSize": "Small",
            "workerCount": 2
          }
        ]
    }
}
```

workerPools can have two properties workerSize and workerCount:

```json
    "workerSize": {
      "type": "string",
      "allowedValues": [
        "Small",
        "Medium",
        "Large",
        "ExtraLarge"
      ],
      "defaultValue": "Small",
      "metadata": {
        "description": "Instance size for worker pool one.  Maps to P1,P2,P3,P4."
      }
    },
    "workerCount": {
      "type": "int",
      "defaultValue": 2,
      "minValue": 2,
      "maxValue": 100,
      "metadata": {
        "description": "Number of instances in worker pool one.  Minimum of two."
      }
    }
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the app service environment |
| `resourceGroupName` | string | The resource group the app service environment was deployed into |
| `resourceId` | string | The resource ID of the app service environment |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Hostingenvironments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/hostingEnvironments)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
