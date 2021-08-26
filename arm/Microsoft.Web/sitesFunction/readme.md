# FunctionApp

This module deploys an Function App.

## Resource types

|ResourceType|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Web/sites`|2019-08-01|
|`microsoft.insights/components`|2015-05-01|
|`config`|2016-03-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Web/sites/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `appServiceEnvironmentId` | string | Optional. The Resource Id of the App Service Environment to use for the Function App. |  |  |
| `appServicePlanId` | string | Optional. The Resource Id of the App Service Plan to use for the Function App. |  |  |       
| `clientAffinityEnabled` | bool | Optional. If Client Affinity is enabled. | True |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `enableMonitoring` | bool | Optional. If true, ApplicationInsights will be configured for the Function App. | True |  |    
| `functionAppName` | string | Required. Name of the Function App |  |  |
| `functionsExtensionVersion` | string | Optional. Version if the function extension. | ~3 |  |
| `functionsWorkerRuntime` | string | Required. Runtime of the function worker. |  | System.Object[] |
| `httpsOnly` | bool | Optional. Configures a web site to accept only https requests. Issues redirect for http requests. | True |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Function App from deletion. | False |  |
| `managedServiceIdentity` | string | Optional. Type of managed service identity. | None | System.Object[] |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `siteConfig` | object | Required. Configuration of the app. |  |  |
| `storageAccountName` | string | Required. The name of the storage account to managing triggers and logging function executions. |  |  |
| `storageAccountResourceGroupName` | string | Optional. Resource group of the storage account to use. Required if the storage account is in a different resource group than the function app itself. |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `userAssignedIdentities` | object | Optional. Mandatory 'managedServiceIdentity' contains UserAssigned. The identy to assign to the resource. |  |  |

### Parameter usage: `userAssignedIdentities`

```json
"userAssignedIdentities":{
    "value":  
        {
            "/subscriptions/<subscriptionID>/resourcegroups/<resourceGroup>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identityName1>":{},
            "/subscriptions/<subscriptionID>/resourcegroups/<resourceGroup>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identityName2>":{}
    }
}
```
Use the managed identity id as key, value must be empty.

### Parameter Usage: `siteConfig`

```json
"siteConfig": {
    "value": {
        "alwaysOn": true
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
| `functionAppName` | string | The Name of the created function. Same as functionAppName parameter |
| `functionAppResourceGroup` | string | Name of the resource group where the resource was created |
| `functionResourceId` | string | The full resource ID of the created resource |
| `assignedIdentityID` | string | The object ID of the identity assigned to the resource. Blank if system assigned identity was not requested |

## Considerations

*N/A*

## Additional resources

- [An introduction to Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
- [Microsoft.Web sites template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/2019-08-01/sites)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)