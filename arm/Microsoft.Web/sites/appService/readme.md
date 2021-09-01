# App Services


## Resource types

|Resource Type| Api Version|
|:--|:--|
|`Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
|`Microsoft.Network/privateEndpoints` | 2020-05-01 |
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Web/serverfarms`|2018-02-01|
|`Microsoft.Web/sites`	|2018-02-01|
|`providers/locks`	|2016-09-01|
|`Microsoft.Web/sites/providers/diagnosticsettings`|2017-05-01-preview|


### Resource dependency

The following resources are required to be able to deploy this resource.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Allowed Values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `hostingPlanName` | string | Required. Name of the Application Service Plan |  |  |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False |  |
| `privateEndpoints` | array | System.Object[] |  | Optional. Configuration Details for private endpoints. |
| `sku` | string | Optional. The pricing tier for the hosting plan. | F1 |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `webAppPortalName` | string | Required. Name of the Web Application Portal Name |  |  |
| `workerSize` | int | Optional. Defines the number of workers from the worker pool that will be used by the app service plan | 2 |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |

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
| `appServiceName` | string | The Name of the Application Web Services |
| `appServiceResourceGroup` | string | The name of the Resource Group with the Application Web Services |
| `appServiceResourceId` | string | The Resource Id of the Application Web Services |

### References

### Template references

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [ServerfarmS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2018-02-01/serverfarms)
- [SiteS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2018-02-01/sites)

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [ServerfarmS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2018-02-01/serverfarms)
- [SiteS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2018-02-01/sites)
