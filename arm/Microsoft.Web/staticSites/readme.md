# Static Web Sites `[Microsoft.Web/staticSites]`

This module deploys a Static Web Site.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-05-01 |
| `Microsoft.Web/staticSites` | 2021-03-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the static site. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowConfigFileUpdates` | bool | `True` |  | If config file is locked for this static web app. |
| `branch` | string | `''` |  | The branch name of the GitHub repo. |
| `buildProperties` | object | `{object}` |  | Build properties for the static site. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enterpriseGradeCdnStatus` | string | `'Disabled'` | `[Disabled, Disabling, Enabled, Enabling]` | State indicating the status of the enterprise grade CDN serving traffic to the static web app. |
| `location` | string | `[resourceGroup().location]` |  | Location to deploy static site. The following locations are supported: CentralUS, EastUS2, EastAsia, WestEurope, WestUS2 |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. |
| `provider` | string | `'None'` |  | The provider that submitted the last deployment to the primary environment of the static site. |
| `repositoryToken` | secureString | `''` |  | The Personal Access Token for accessing the GitHub repo. |
| `repositoryUrl` | string | `''` |  | The name of the GitHub repo. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | string | `'Free'` | `[Free, Standard]` | Type of static site to deploy. |
| `stagingEnvironmentPolicy` | string | `'Enabled'` | `[Enabled, Disabled]` | State indicating whether staging environments are allowed or not allowed for a static web app. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `templateProperties` | object | `{object}` |  | Template Options for the static site. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `buildProperties`

[StaticSiteBuildProperties - Microsoft.Web/staticSites 2021-03-01 - Bicep & ARM template reference | Microsoft Docs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-03-01/staticSites?tabs=bicep#staticsitebuildproperties)

```bicep
    buildProperties: {
      apiBuildCommand: 'string'
      apiLocation: 'string'
      appArtifactLocation: 'string'
      appBuildCommand: 'string'
      appLocation: 'string'
      githubActionSecretNameOverride: 'string'
      outputLocation: 'string'
      skipGithubActionWorkflowGeneration: bool
    }
```

### Parameter Usage: `templateProperties`

[StaticSiteTemplateOptions - Microsoft.Web/staticSites 2021-03-01 - Bicep & ARM template reference | Microsoft Docs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-03-01/staticSites?tabs=bicep#staticsitetemplateoptions)

```bicep
    buildProperties: {
      apiBuildCommand: 'string'
      apiLocation: 'string'
      appArtifactLocation: 'string'
      appBuildCommand: 'string'
      appLocation: 'string'
      githubActionSecretNameOverride: 'string'
      outputLocation: 'string'
      skipGithubActionWorkflowGeneration: bool
    }
```

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>" // e.g. vault, registry, file, blob, queue, table etc.
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
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
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>" // e.g. vault, registry, file, blob, queue, table etc.
        }
    ]
}
```

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static site. |
| `resourceGroupName` | string | The resource group the static site was deployed into. |
| `resourceId` | string | The resource ID of the static site. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Staticsites](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-03-01/staticSites)
