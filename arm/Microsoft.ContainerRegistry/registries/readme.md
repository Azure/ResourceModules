# ContainerRegistry

Azure Container Registry is a managed, private Docker registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your private Docker container images and related artifacts.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.ContainerRegistry/registries` | 2020-11-01-preview |
| `Microsoft.ContainerRegistry/registries/providers/roleAssignments` | 2020-04-01-preview |
| `Microsoft.ContainerRegistry/registries/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Allowed Values |
| :-- | :-- | :-- | :-- | :-- |
| `acrName` | string | Required. Name of the container registry. |  |  |
| `acrAdminUserEnabled` | bool | Required. The value that indicates whether the admin user is enabled. | false | true, false |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `privateEndpoints` | array | System.Object[] |  | Optional. Configuration Details for private endpoints. |
| `acrSku` | enum | Required. The SKU name of the container registry. Required for registry creation. | Basic |  Classic, Basic, Standard, Premium |
| `quarantinePolicyStatus` | string | Optional. The value that indicates whether the policy is enabled or not. |  | Enabled, Disabled |
| `trustPolicyStatus` | string | Optional. The value that indicates whether the policy is enabled or not. |  | Enabled, Disabled |
| `retentionPolicyStatus` | string | Optional. The value that indicates whether the policy is enabled or not.|  | Enabled, Disabled |
| `retentionPolicyDays` | string | Optional. The number of days to retain an untagged manifest after which it gets purged. |  |  |
| `dataEndpointEnabled` | bool | Optional. Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. | false | true, false |
| `publicNetworkAccess` | string | Optional. Whether or not public network access is allowed for the container registry. | Enabled | Enabled, Disabled |
| `networkRuleBypassOptions` | string | Optional. Whether to allow trusted Azure services to access a network restricted registry. Not relevant in case of public access. | AzureServices | AzureServices, None |
| `lockForDeletion` | bool | Optional. Switch to lock resource from deletion. | False |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticSettingName` | string | Optional. The name of the Diagnostic setting. | service |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |

### Parameter Usage: `imageRegistryCredentials`

The image registry credentials by which the container group is created from.

```json
    "acrName": {
      "value": {
          "server": "acrx001",
        }
    },
    "acrAdminUserEnabled": {
      "value": false
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
            "service": "vault",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
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
| `acrName` | string | The Name of the Azure Container Registry. |
| `acrLoginServer` | string | The reference to the Azure Container Registry login server. |
| `acrResourceGroup` | string | The name of the Resource Group the Azure Container Registry was created in. |
| `acrResourceId` | string | The Resource Id of the Azure Container Registry. |

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [ContainerRegistry](https://docs.microsoft.com/en-us/azure/templates/microsoft.containerregistry/2019-05-01/registries)
