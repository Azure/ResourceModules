# Automation Accounts `[Microsoft.Automation/automationAccounts]`

This module deploys an Azure Automation Account.

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

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `gallerySolutions` | array | `[]` |  | Optional. List of gallerySolutions to be created in the linked log analytics workspace |
| `jobSchedules` | _[jobSchedules](jobSchedules/readme.md)_ array | `[]` |  | Optional. List of jobSchedules to be created in the automation account. |
| `linkedWorkspaceId` | string |  |  | Optional. ID of the log analytics workspace to be linked to the deployed automation account. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[JobLogs, JobStreams, DscNodeStatus]` | `[JobLogs, JobStreams, DscNodeStatus]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `modules` | _[modules](modules/readme.md)_ array | `[]` |  | Optional. List of modules to be created in the automation account. |
| `name` | string |  |  | Required. Name of the Automation Account. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `runbooks` | _[runbooks](runbooks/readme.md)_ array | `[]` |  | Optional. List of runbooks to be created in the automation account. |
| `schedules` | _[schedules](schedules/readme.md)_ array | `[]` |  | Optional. List of schedules to be created in the automation account. |
| `skuName` | string | `Basic` | `[Free, Basic]` | Optional. SKU name of the account. |
| `softwareUpdateConfigurations` | _[softwareUpdateConfigurations](softwareUpdateConfigurations/readme.md)_ array | `[]` |  | Optional. List of softwareUpdateConfigurations to be created in the automation account |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the Automation Account resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `variables` | _[variables](variables/readme.md)_ array | `[]` |  | Optional. List of variables to be created in the automation account. |

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
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Solutions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)
- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-03-01-preview/workspaces/linkedServices)
