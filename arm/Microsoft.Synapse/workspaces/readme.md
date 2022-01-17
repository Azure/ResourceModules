# Synapse PrivateLinkHubs `[Microsoft.Synapse/workspaces]`

This module deploys Synapse PrivateLinkHubs.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-03-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-03-01 |
| `Microsoft.Synapse/workspaces` | 2021-06-01 |
| `Microsoft.Synapse/workspaces/keys` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowedAadTenantIdsForLinking` | array | `[]` |  | Optional. Allowed Aad Tenant Ids For Linking. |
| `azureADOnlyAuthentication` | bool |  |  | Optional. Enable or Disable AzureADOnlyAuthentication on All Workspace subresource |
| `defaultDataLakeStorageAccountName` | string |  |  | Required. Name of the default ADLS Gen2 storage account. |
| `defaultDataLakeStorageCreateManagedPrivateEndpoint` | bool |  |  | Optional. Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account. |
| `defaultDataLakeStorageFilesystem` | string |  |  | Required. The default ADLS Gen2 file system. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `encryption` | bool |  |  | Optional. Double encryption using a customer-managed key. |
| `encryptionActivateWorkspace` | bool |  |  | Optional. Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace. |
| `encryptionKeyName` | string |  |  | Optional. The encryption key name in KeyVault. |
| `encryptionKeyVaultName` | string |  |  | Optional. Keyvault where the encryption key is stored. |
| `encryptionKeyVaultResourceGroupName` | string |  |  | Optional. Keyvault resource group name. |
| `encryptionUserAssignedIdentity` | string |  |  | Optional. The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `encryptionUseSystemAssignedIdentity` | bool |  |  | Optional. Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `initialWorkspaceAdminObjectId` | string |  |  | Optional. AAD object Id of initial workspace admin. |
| `linkedAccessCheckOnTargetResource` | bool |  |  | Optional. Linked Access Check On Target Resource. |
| `location` | string | `[resourceGroup().location]` |  | Optional. The geo-location where the resource lives. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[]` | `[SynapseRbacOperations, GatewayApiRequests, BuiltinSqlReqsEnded, IntegrationPipelineRuns, IntegrationActivityRuns, IntegrationTriggerRuns]` | Optional. The name of logs that will be streamed. |
| `managedResourceGroupName` | string |  |  | Optional. Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.' |
| `managedVirtualNetwork` | bool |  |  | Optional. Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources. |
| `name` | string |  |  | Required. The name of the Synapse Workspace. |
| `preventDataExfiltration` | bool |  |  | Optional. Prevent Data Exfiltration. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `publicNetworkAccess` | string | `Enabled` | `[Enabled, Disabled]` | Optional. Enable or Disable public network access to workspace. |
| `purviewResourceId` | string |  |  | Optional. Purview Resource ID. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sqlAdministratorLogin` | string |  |  | Required. Login for administrator access to the workspace's SQL pools. |
| `sqlAdministratorLoginPassword` | string |  |  | Optional. Password for administrator access to the workspace's SQL pools. If you don't provide a password, one will be automatically generated. You can change the password later. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

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
| `workspaceConnectivityEndpoints` | object | Connectivity endpoints. |
| `workspaceName` | string | The name of the deployed Synapse Workspace. |
| `workspaceResourceGroup` | string | The resource group of the deployed Synapse Workspace. |
| `workspaceResourceId` | string | The resource ID of the deployed Synapse Workspace. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces)
- [Workspaces/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys)
