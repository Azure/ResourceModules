# App Service Environment

This module deploys App Service Environment, with resource lock.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Web/hostingEnvironments` | 2020-06-01 |
| `Microsoft.Web/hostingEnvironments/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.Web/hostingEnvironments/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `appServiceEnvironmentName` | string | | | Required. Name of the Azure App Service Environment
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `kind` | string | `ASEV2` | | Optional. Kind of resource.
| `subnetResourceId` | string | | | Required. ResourceId for the sub net.
| `internalLoadBalancingMode` | string | `None` | ` "None", "Web", "Publishing" ` | Optional. Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing
| `multiSize` | string | `Standard_D1_V2` | `  "Medium","Large","ExtraLarge","Standard_D2","Standard_D3", "Standard_D4","Standard_D1_V2","Standard_D2_V2", "Standard_D3_V2","Standard_D4_V2"` | Optional: Front-end VM size, e.g. Medium, Large
| `multiRoleCount` | int | `2` | | Optional. Number of front-end instances
| `ipsslAddressCount` | int | `2` | | Optional. Number of IP SSL addresses reserved for the App Service Environment.
| `workerPools` | array | `[]` | Complex structure, see below. | Optional. Description of worker pools with worker size IDs, VM sizes, and number of workers in each pool.
| `dnsSuffix` | string | `""` | | Optional. DNS suffix of the App Service Environment.
| `networkAccessControlList` | array | `[]` | | Optional. Access control list for controlling traffic to the App Service Environment.
| `frontEndScaleFactor` | int | `15` | | Optional. Scale factor for front-ends.
| `apiManagementAccountId` | string | `""` | | Optional. API Management Account associated with the App Service Environment.
| `suspended` | bool | `false` | | Optional. true if the App Service Environment is suspended; otherwise, false. The environment can be suspended, e.g. when the management endpoint is no longer available (most likely because NSG blocked the incoming traffic).
| `dynamicCacheEnabled` | bool | `false` | | Optional. True/false indicating whether the App Service Environment is suspended. The environment can be suspended e.g. when the management endpoint is no longer available(most likely because NSG blocked the incoming traffic).
| `userWhitelistedIpRanges` | array | `[]` | | Optional. User added ip ranges to whitelist on ASE db - string.
| `hasLinuxWorkers` | bool | `false` | | Optional. Flag that displays whether an ASE has linux workers or not
| `clusterSettings` | array | `[]` | | Optional. Custom settings for changing the behavior of the App Service Environment.
| `diagnosticLogsRetentionInDays` | int | `365` | | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.
| `diagnosticStorageAccountId` | string | "" | | Optional. Resource identifier of the Diagnostic Storage Account.
| `workspaceId` | string | "" | | Optional. Resource identifier of Log Analytics.
| `eventHubAuthorizationRuleId` | string | "" | | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
| `eventHubName` | string | "" | | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
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
| `appServiceEnvironmentName` | string | The Name of the AppServiceEnvironment |
| `appServiceEnvironmentResourceGroup` | string | The name of the Resource Group the AppServiceEnvironment was created in. |
| `appServiceEnvironmentResourceId` | string | The Resource Id of the AppServiceEnvironment. |

## Considerations

**N/A*

## Additional resources

- [Introduction to App Service Environment?](https://docs.microsoft.com/en-us/azure/app-service/environment/intro)
- [Microsoft.Web hostingEnvironments template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/2020-06-01/hostingenvironments)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)

