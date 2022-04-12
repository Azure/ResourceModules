# Automation Accounts `[Microsoft.Automation/automationAccounts]`

This module deploys an Azure Automation Account.

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
| `Microsoft.Automation/automationAccounts` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/jobSchedules` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/modules` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/runbooks` | 2019-06-01 |
| `Microsoft.Automation/automationAccounts/schedules` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | 2019-06-01 |
| `Microsoft.Automation/automationAccounts/variables` | 2020-01-13-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-05-01 |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2020-03-01-preview |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Automation Account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[JobLogs, JobStreams, DscNodeStatus]` | `[JobLogs, JobStreams, DscNodeStatus]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `encryptionKeySource` | string | `'Microsoft.Automation'` | `[Microsoft.Automation, Microsoft.Keyvault]` | Encryption Key Source. For security reasons it is recommended to use Microsoft.Keyvault if custom keys are available. |
| `encryptionUserAssignedIdentity` | string | `''` |  | User identity used for CMK. If you set encryptionKeySource as Microsoft.Keyvault encryptionUserAssignedIdentity is required. |
| `gallerySolutions` | array | `[]` |  | List of gallerySolutions to be created in the linked log analytics workspace |
| `jobSchedules` | _[jobSchedules](jobSchedules/readme.md)_ array | `[]` |  | List of jobSchedules to be created in the automation account. |
| `keyName` | string | `''` |  | The name of key used to encrypt data. This parameter is needed only if you enable Microsoft.Keyvault as encryptionKeySource. |
| `keyvaultUri` | string | `''` |  | The URI of the key vault key used to encrypt data. This parameter is needed only if you enable Microsoft.Keyvault as encryptionKeySource. |
| `keyVersion` | string | `''` |  | The key version of the key used to encrypt data. This parameter is needed only if you enable Microsoft.Keyvault as encryptionKeySource. |
| `linkedWorkspaceId` | string | `''` |  | ID of the log analytics workspace to be linked to the deployed automation account. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `modules` | _[modules](modules/readme.md)_ array | `[]` |  | List of modules to be created in the automation account. |
| `privateEndpoints` | array | `[]` |  | Configuration Details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `runbooks` | _[runbooks](runbooks/readme.md)_ array | `[]` |  | List of runbooks to be created in the automation account. |
| `schedules` | _[schedules](schedules/readme.md)_ array | `[]` |  | List of schedules to be created in the automation account. |
| `skuName` | string | `'Basic'` | `[Free, Basic]` | SKU name of the account. |
| `softwareUpdateConfigurations` | _[softwareUpdateConfigurations](softwareUpdateConfigurations/readme.md)_ array | `[]` |  | List of softwareUpdateConfigurations to be created in the automation account |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the Automation Account resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `variables` | _[variables](variables/readme.md)_ array | `[]` |  | List of variables to be created in the automation account. |


### Parameter Usage: `encryption`
Prerequsites:
- User Assigned Identity for Encryption needs `Get`, `List`, `Wrap` and `Unwrap` permissions on the key.
- User Assigned Identity have to be one of the defined identities in userAssignedIdentities parameter block.
- To use Azure Automation with customer managed keys, both `Soft Delete` and `Do Not Purge` features must be turned on to allow for recovery of keys in case of accidental deletion.

```json
"encryptionKeySource" : {
    "value" : "Microsoft.KeyVault"
},
"encryptionUserAssignedIdentity": {
    "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001" // this identity needs to be one of the identities defined in userAssignedIdentities section
},
"keyName" : {
        "value" : "keyEncryptionKey"
},
"keyvaultUri" : {
            "value" : "https://<<keyValutName>>.vault.azure.net/"
},
"keyVersion" : {
            "value" : "aa11b22c1234567890c3608c657cd5a2"
},

"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}, // same value as 'encryptionUserAssignedIdentity' parameter
        ...
    }
},
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
| `name` | string | The name of the deployed automation account |
| `resourceGroupName` | string | The resource group of the deployed automation account |
| `resourceId` | string | The resource ID of the deployed automation account |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Automationaccounts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts)
- [Automationaccounts/Jobschedules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/jobSchedules)
- [Automationaccounts/Modules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/modules)
- [Automationaccounts/Runbooks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/runbooks)
- [Automationaccounts/Schedules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/schedules)
- [Automationaccounts/Softwareupdateconfigurations](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations)
- [Automationaccounts/Variables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/variables)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Solutions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)
- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-03-01-preview/workspaces/linkedServices)
