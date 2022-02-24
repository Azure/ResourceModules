# Key Vaults `[Microsoft.KeyVault/vaults]`

This module deploys a key vault and its child resources.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.KeyVault/vaults` | 2019-09-01 |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2021-06-01-preview |
| `Microsoft.KeyVault/vaults/keys` | 2019-09-01 |
| `Microsoft.KeyVault/vaults/secrets` | 2019-09-01 |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accessPolicies` | _[accessPolicies](accessPolicies/readme.md)_ array | `[]` |  | Optional. Array of access policies object |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules. |
| `createMode` | string | `default` |  | Optional. The vault's create mode to indicate whether the vault need to be recovered or not. - recover or default. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.  |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `enablePurgeProtection` | bool |  |  | Optional. Provide 'true' to enable Key Vault's purge protection feature. |
| `enableRbacAuthorization` | bool |  |  | Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC. |
| `enableSoftDelete` | bool | `True` |  | Optional. Switch to enable/disable Key Vault's soft delete feature. |
| `enableVaultForDeployment` | bool | `True` | `[True, False]` | Optional. Specifies if the vault is enabled for deployment by script or compute |
| `enableVaultForDiskEncryption` | bool | `True` | `[True, False]` | Optional. Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. |
| `enableVaultForTemplateDeployment` | bool | `True` | `[True, False]` | Optional. Specifies if the vault is enabled for a template deployment |
| `keys` | _[keys](keys/readme.md)_ array | `[]` |  | Optional. All keys to create |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[AuditEvent]` | `[AuditEvent]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Optional. Name of the Key Vault. If no name is provided, then unique name will be created. |
| `networkAcls` | object | `{object}` |  | Optional. Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `secrets` | _[secrets](secrets/readme.md)_ object | `[]` |  | Optional. All secrets to create |
| `softDeleteRetentionInDays` | int | `90` |  | Optional. softDelete data retention days. It accepts >=7 and <=90. |
| `tags` | object | `{object}` |  | Optional. Resource tags. |
| `vaultSku` | string | `premium` | `[premium, standard]` | Optional. Specifies the SKU for the vault |
| `vNetId` | string |  |  | Optional. Virtual Network resource identifier, if networkAcls is passed, this value must be passed as well |

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

### Parameter Usage: `networkAcls`

```json
"networkAcls": {
    "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "virtualNetworkRules": [
            {
                "subnet": "sharedsvcs"
            }
        ],
        "ipRules": []
    }
}
```

### Parameter Usage: `vNetId`

```json
"vNetId": {
    "value": "/subscriptions/00000000/resourceGroups/resourceGroup"
}
```

### Parameter Usage: `accessPolicies`

```json
"accessPolicies": {
    "value": [
        {
            "tenantId": null, // Optional
            "applicationId": null, // Optional
            "objectId": null,
            "permissions": {
                "certificates": [
                    "All"
                ],
                "keys": [
                    "All"
                ],
                "secrets": [
                    "All"
                ]
            }
        }
    ]
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
            "service": "blob",
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
            "service": "file"
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key vault. |
| `resourceGroupName` | string | The name of the resource group the key vault was created in. |
| `resourceId` | string | The resource ID of the key vault. |
| `uri` | string | The URI of the key vault. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Vaults](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults)
- [Vaults/Accesspolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies)
- [Vaults/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/keys)
- [Vaults/Secrets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/secrets)
