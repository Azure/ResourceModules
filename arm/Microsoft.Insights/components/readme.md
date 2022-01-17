# Application Insights `[Microsoft.Insights/components]`

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/components` | 2020-02-02 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightsPublicNetworkAccessForIngestion` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The network access type for accessing Application Insights ingestion. - Enabled or Disabled |
| `appInsightsPublicNetworkAccessForQuery` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The network access type for accessing Application Insights query. - Enabled or Disabled |
| `appInsightsType` | string | `web` | `[web, other]` | Optional. Application type |
| `appInsightsWorkspaceResourceId` | string |  |  | Required. Resource ID of the log analytics workspace which the data will be ingested to. This property is required to create an application with this API version. Applications from older versions will not have this property. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `kind` | string |  |  | Optional. The kind of application that this component refers to, used to customize UI. This value is a freeform string, values should typically be one of the following: web, ios, other, store, java, phone. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources |
| `name` | string |  |  | Required. Name of the Application Insights |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

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
| `appInsightsAppId` | string | The application ID of the application insights component |
| `appInsightsName` | string | The name of the application insights component |
| `appInsightsResourceGroup` | string | The resource group the application insights component was deployed into |
| `appInsightsResourceId` | string | The resource ID of the application insights component |

## Template references

- [Components](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-04-01-preview/roleAssignments)
