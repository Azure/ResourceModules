# Azure Monitor Private Link Scope

This module deploys Azure Monitor Private Link Scope

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Insights/privateLinkScopes` | 2019-10-17-preview |
| `microsoft.insights/privatelinkscopes/scopedresources` | 2019-10-17-preview |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.Insights/privateLinkScopes/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `privateLinkScopeName` | string | | | Required. Name of the Private Link Scope.
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `lockForDeletion` | bool | `true` | | Optional. Switch to lock Private Link Scope from deletion.
| `roleAssignments` | array | [] | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
| `scopedResources` | array | [] | Complex structure, see below. | Optional. Configuration Details for Azure Monitor Resources.
| `privateEndpoints` | array | System.Object[] | Complex structure, see below. | Optional. Configuration Details for private endpoints. |
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

### Parameter Usage: `scopedResources`

```json
"scopedResources": {
    "value": [
        {
            "linkedResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourcegroups/prd-monitoring-rg/providers/microsoft.operationalinsights/workspaces/z1-prd-law-01"
        }
    ]
}
```

### Parameter Usage: `privateEndpoints`

To use Private Endpoints the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.

- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "azuremonitor",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.agentsvc.azure-automation.net",
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.monitor.azure.com",
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.ods.opinsights.azure.com",
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.oms.opinsights.azure.com"
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
            "service": "azuremonitor"
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
| `privateLinkScopeResourceId` | string | The Resource Id of the Private Link Scope. |
| `privateLinkScopeResourceGroup` | string | The name of the Resource Group the Private Link Scope was created in. |
| `privateLinkScopeName` | string | The Name of the Private Link Scope. |

## Considerations

**N/A*

## Additional resources

- [Azure Monitor Private Link Scope Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/private-link-security)
- [Microsoft.Insights privateLinkScopes template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/privatelinkscopes)
- [Microsoft.Insights privateLinkScopes scopedResources template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/privatelinkscopes/scopedresources)
- [Microsoft.Network privateEndpoints template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints)
- [Microsoft.Network privateEndpoints privateDnsZoneGroups template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints/privatednszonegroups)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)