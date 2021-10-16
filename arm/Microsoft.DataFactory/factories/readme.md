# DataFactory

## Resource types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories` | 2018-06-01 |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 |
| `Microsoft.DataFactory/factories/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.DataFactory/factories/providers/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `providers/locks` | 2016-09-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

Only V2 is currently supported, not V1.

If you enable git Repository the repository including branch has to exist beforehand.


## Parameters
| Parameter Name | Type | DefaultValue | Possible values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Factory to create |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingName` | string | `service` |  | Optional. The name of the Diagnostic setting. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `gitAccountName` | string |  |  | Optional. The account name. |
| `gitCollaborationBranch` | string | `main` |  | Optional. The collaboration branch name. Default is 'main'. |
| `gitConfigureLater` | bool | `True` |  | Optional. Boolean to define whether or not to configure git during template deployment. |
| `gitProjectName` | string |  |  | Optional. The project name. Only relevant for 'FactoryVSTSConfiguration'. |
| `gitRepositoryName` | string |  |  | Optional. The repository name. |
| `gitRepoType` | string | `FactoryVSTSConfiguration` |  | Optional. Repo type - can be 'FactoryVSTSConfiguration' or 'FactoryGitHubConfiguration'. Default is 'FactoryVSTSConfiguration'. |
| `gitRootFolder` | string | `/` |  | Optional. The root folder path name. Default is '/'. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lockForDeletion` | bool |  |  | Optional. Switch to lock resource from deletion. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `publicNetworkAccess` | bool | `True` |  | Optional. Enable or disable public network access. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `vNetEnabled` | bool |  |  | Optional. Enable or disable managed virtual networks and related to that AutoResolveIntegrationRuntime. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

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

- Azure Data Factory supports two different private endpoints
    - `portal`: `privatelink.azure.com`
    - `dataFactory`: `privatelink.datafactory.azure.net`

- You can still access the Azure Data Factory portal through a public network after you create private endpoint for portal.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "dataFactory",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.datafactory.azure.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "portal"
        }
    ]
}
```


## Outputs
| Output Name | Type |
| :-- | :-- |
| `dataFactoryName` | string |
| `dataFactoryResourceGroup` | string |
| `dataFactoryResourceId` | string |

## Template references
- [Factories](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories)
- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)
- [Factories/Managedvirtualnetworks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/privateEndpoints/privateDnsZoneGroups)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/providers/2016-09-01/locks)
