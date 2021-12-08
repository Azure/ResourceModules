# App Service Environments `[Microsoft.Web/hostingEnvironments]`

This module deploys an app service environment.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Web/hostingEnvironments` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementAccountId` | string |  |  | Optional. API Management Account associated with the App Service Environment. |
| `clusterSettings` | array | `[]` |  | Optional. Custom settings for changing the behavior of the App Service Environment |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `dnsSuffix` | string |  |  | Optional. DNS suffix of the App Service Environment. |
| `dynamicCacheEnabled` | bool |  |  | Optional. True/false indicating whether the App Service Environment is suspended. The environment can be suspended e.g. when the management endpoint is no longer available(most likely because NSG blocked the incoming traffic). |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `frontEndScaleFactor` | int | `15` |  | Optional. Scale factor for frontends. |
| `hasLinuxWorkers` | bool |  |  | Optional. Flag that displays whether an ASE has linux workers or not |
| `internalLoadBalancingMode` | string | `None` | `[None, Web, Publishing]` | Optional. Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing |
| `ipsslAddressCount` | int | `2` |  | Optional. Number of IP SSL addresses reserved for the App Service Environment. |
| `kind` | string | `ASEV2` |  | Optional. Kind of resource. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[AppServiceEnvironmentPlatformLogs]` | `[AppServiceEnvironmentPlatformLogs]` | Optional. The name of logs that will be streamed. |
| `multiRoleCount` | int | `2` |  | Optional. Number of frontend instances. |
| `multiSize` | string | `Standard_D1_V2` | `[Medium, Large, ExtraLarge, Standard_D2, Standard_D3, Standard_D4, Standard_D1_V2, Standard_D2_V2, Standard_D3_V2, Standard_D4_V2]` | Optional. Frontend VM size, e.g. Medium, Large |
| `name` | string |  |  | Required. Name of the App Service Environment |
| `networkAccessControlList` | array | `[]` |  | Optional. Access control list for controlling traffic to the App Service Environment.. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `subnetResourceId` | string |  |  | Required. ResourceId for the sub net |
| `suspended` | bool |  |  | Optional. true if the App Service Environment is suspended; otherwise, false. The environment can be suspended, e.g. when the management endpoint is no longer available (most likely because NSG blocked the incoming traffic). |
| `tags` | object | `{object}` |  | Optional. Resource tags. |
| `userWhitelistedIpRanges` | array | `[]` |  | Optional. User added ip ranges to whitelist on ASE db - string |
| `workerPools` | array | `[]` |  | Optional. Description of worker pools with worker size IDs, VM sizes, and number of workers in each pool.. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

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
| `appServiceEnvironmentName` | string | The name of the app service environment |
| `appServiceEnvironmentResourceGroup` | string | The resource group the app service environment was deployed into |
| `appServiceEnvironmentResourceId` | string | The resource ID of the app service environment |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Hostingenvironments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/hostingEnvironments)
