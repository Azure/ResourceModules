# Application Insights

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.Insights/components` | 2020-02-02-preview |
| `Microsoft.Insights/components/providers/roleAssignments` | 2020-04-01-preview |



### Resource dependency

The following resources are required to be able to deploy this resource.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightsName` | string | Required. Name of the Application Insights |  |  |
| `appInsightsType` | string | Optional. Application type | web | System.Object[] |
| `appInsightsWorkspaceResourceId` | string | Required. Resource Id of the log analytics workspace which the data will be ingested to. This property is required to create an application with this API version. Applications from older versions will not have this property | | |
| `appInsightsPublicNetworkAccessForIngestion` | string | Optional. The network access type for accessing Application Insights ingestion | Enabled | Enabled, Disabled |
| `appInsightsPublicNetworkAccessForQuery` | string | Optional. The network access type for accessing Application Insights query | Enabled | Enabled, Disabled |
| `location` | string | Optional. Location for all Resources | [resourceGroup().location] |  |
| `roleAssignments` | string | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |


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
| `appInsightsAppId` | string | Application Insights Application Id |
| `appInsightsKey` | string | Application Insights Resource Instrumentation Key |
| `appInsightsName` | string | Application Insights Resource Name |
| `appInsightsResourceGroup` | string | Application Insights ResourceGroup |
| `appInsightsResourceId` | string | Application Insights Resource Id |

### References

### Template references

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Components](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/[variables('appInsightsApiVersion')]/components)


## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Components](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/[variables('appInsightsApiVersion')]/components)