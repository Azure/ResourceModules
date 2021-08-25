# Machine Learning Services

This module deploys a Machine Learning Services Workspace.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.MachineLearningServices/workspaces` | 2021-04-01 |
| `providers/locks` | 2016-09-01 |
| `Microsoft.MachineLearningServices/workspaces/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.MachineLearningServices/workspaces/providers/roleAssignments` | 2018-09-01-preview |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `workspaceName` | string | Required. The name of the machine learning workspace. |  |  |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `sku` | string | Required. Specifies the sku, also referred as 'edition' of the Azure Machine Learning workspace. | Basic | Basic, Enterprise |
| `associatedStorageAccountResourceId` | string | Required. The resource id of the associated Storage Account. | |  |
| `associatedKeyVaultResourceId` | string | Required. The resource id of the associated Key Vault. | |  |
| `associatedApplicationInsightsResourceId` | string | Required. The resource id of the associated Application Insights. | |  |
| `associatedContainerRegistryResourceId` | string | Optional. The resource id of the associated Container Registry. | "" |  |
| `hbiWorkspace` | bool | Optional. The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. | false |  |
| `allowPublicAccessWhenBehindVnet` | bool | Optional. The flag to indicate whether to allow public access when behind VNet. | false |  |
| `roleAssignments` | string | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |  |
| `privateEndpoints` | array | Optional. Configuration Details for private endpoints. | System.Object[] | |
| `lockForDeletion` | bool | Optional. Switch to lock resource from deletion. | false |  |
| `tags` | object | Optional. Tags of the resource. | {} |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticSettingName` | string | Optional. The name of the Diagnostic setting. | service |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. | "" |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. | "" |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. | "" |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. | "" |  |

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

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.

- Although not strictly required, it is highly recommened to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "amlworkspace",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/xxx-xxx-xxx-xxx-xxx/resourcegroups/iacs/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms",
                "/subscriptions/xxx-xxx-xxx-xxx-xxx/resourcegroups/iacs/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `machineLearningServiceResourceId` | string | The Resource Id of the Machine Learning Service workspace. |
| `machineLearningServiceResourceGroup` | string | The name of the Resource Group the Machine Learning Service workspace was created in. |
| `machineLearningServiceName` | string | The name of the Machine Learning Service workspace. |

## Considerations

## Additional resources

- [What is Azure Machine Learning?](https://docs.microsoft.com/en-us/azure/machine-learning/overview-what-is-azure-ml)