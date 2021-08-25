# Azure Databricks

## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2020-06-01|
|`Microsoft.Databricks/workspaces`|2018-04-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Databricks/workspaces/providers/diagnosticsettings`|2017-05-01-preview|
|`Microsoft.Databricks/workspaces/providers/roleAssignments`|2020-04-01-preview|


### Resource dependency

The following resources are required to be able to deploy this resource.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticSettingName` | string | Optional. The name of the Diagnostic setting. |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `roleAssignments` | string | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |  |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False |  |
| `managedResourceGroupId` | string | Optional. The managed resource group Id |  |  |
| `pricingTier` | string | Optional. The pricing tier of workspace | premium | System.Object[] |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `workspaceName` | string | Required. The name of the Azure Databricks workspace to create. |  |  |
| `workspaceParameters` | string | Optional. The workspace's custom parameters. |  |  |




### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Contributor",
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
    ]
}
```

### Parameter Usage: `customPublicSubnetName` and `customPrivateSubnetName`

- Require Network Security Groups attached to the subnets
    - The rule don't have to be set, they are set through the deployment

- The two subnets also need the delegation to service `Microsoft.Databricks/workspaces`


### Parameter Usage: `workspaceParameters`

- Include only those elements (e.g. amlWorkspaceId) as object if specified, otherwise remove it

```json
"workspaceParameters": {
      "value": {
        "amlWorkspaceId": {
          "value": "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.MachineLearningServices/workspaces/xxx"
        },
        "customVirtualNetworkId": {
          "value": "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx"
        },
        "customPublicSubnetName": {
          "value": "xxx"
        },
        "customPrivateSubnetName": {
          "value": "xxx"
        },
        "enableNoPublicIp": {
          "value": true
        }
      }
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
| `databrickName` | string | The Name of the Azure Databricks |
| `databrickResourceGroup` | string | The name of the Resource Group with the Azure Databricks |
| `databrickResourceId` | string | The Resource Id of the Azure Databricks |

### References

### Template references

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2018-04-01/workspaces)

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2018-04-01/workspaces)