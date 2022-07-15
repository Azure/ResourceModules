# Synapse Workspaces `[Microsoft.Synapse/workspaces]`

This module deploys a Synapse Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2016-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2021-04-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2020-04-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies) |
| `Microsoft.Network/privateEndpoints` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Synapse/workspaces` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces) |
| `Microsoft.Synapse/workspaces/keys` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `defaultDataLakeStorageAccountName` | string | Name of the default ADLS Gen2 storage account. |
| `defaultDataLakeStorageFilesystem` | string | The default ADLS Gen2 file system. |
| `name` | string | The name of the Synapse Workspace. |
| `sqlAdministratorLogin` | string | Login for administrator access to the workspace's SQL pools. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowedAadTenantIdsForLinking` | array | `[]` |  | Allowed Aad Tenant Ids For Linking. |
| `azureADOnlyAuthentication` | bool | `False` |  | Enable or Disable AzureADOnlyAuthentication on All Workspace subresource |
| `defaultDataLakeStorageCreateManagedPrivateEndpoint` | bool | `False` |  | Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[SynapseRbacOperations, GatewayApiRequests, BuiltinSqlReqsEnded, IntegrationPipelineRuns, IntegrationActivityRuns, IntegrationTriggerRuns]` | `[SynapseRbacOperations, GatewayApiRequests, BuiltinSqlReqsEnded, IntegrationPipelineRuns, IntegrationActivityRuns, IntegrationTriggerRuns]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `encryption` | bool | `False` |  | Double encryption using a customer-managed key. |
| `encryptionActivateWorkspace` | bool | `False` |  | Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace. |
| `encryptionKeyName` | string | `''` |  | The encryption key name in KeyVault. |
| `encryptionKeyVaultName` | string | `''` |  | Keyvault where the encryption key is stored. |
| `encryptionKeyVaultResourceGroupName` | string | `''` |  | Keyvault resource group name. |
| `encryptionUserAssignedIdentity` | string | `''` |  | The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `encryptionUseSystemAssignedIdentity` | bool | `False` |  | Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `initialWorkspaceAdminObjectID` | string | `''` |  | AAD object ID of initial workspace admin. |
| `linkedAccessCheckOnTargetResource` | bool | `False` |  | Linked Access Check On Target Resource. |
| `location` | string | `[resourceGroup().location]` |  | The geo-location where the resource lives. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `managedResourceGroupName` | string | `''` |  | Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.' |
| `managedVirtualNetwork` | bool | `False` |  | Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources. |
| `preventDataExfiltration` | bool | `False` |  | Prevent Data Exfiltration. |
| `privateEndpoints` | array | `[]` |  | Configuration Details for private endpoints. |
| `publicNetworkAccess` | string | `'Enabled'` | `[Enabled, Disabled]` | Enable or Disable public network access to workspace. |
| `purviewResourceID` | string | `''` |  | Purview Resource ID. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sqlAdministratorLoginPassword` | string | `''` |  | Password for administrator access to the workspace's SQL pools. If you don't provide a password, one will be automatically generated. You can change the password later. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>", // e.g. vault, registry, file, blob, queue, table etc.
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

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
        privateDnsZoneResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
            '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
        ]
        // Optional
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
    }
]
```

</details>
<p>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `connectivityEndpoints` | object | The workspace connectivity endpoints. |
| `name` | string | The name of the deployed Synapse Workspace. |
| `resourceGroupName` | string | The resource group of the deployed Synapse Workspace. |
| `resourceID` | string | The resource ID of the deployed Synapse Workspace. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Vaults/Accesspolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces)
- [Workspaces/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys)

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<<namePrefix>>-az-synws-basic-001"
    },
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsaweux004"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    "initialWorkspaceAdminObjectId": {
      "value": "<<deploymentSpId>>"
    },
    "userAssignedIdentities": {
      "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
      }
    },
    "roleAssignments": {
      "value": [
        {
          "roleDefinitionIdOrName": "Reader",
          "principalIds": [
            "<<deploymentSpId>>"
          ]
        }
      ]
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsalaw001"
    },
    "diagnosticWorkspaceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
    },
    "diagnosticEventHubName": {
      "value": "adp-<<namePrefix>>-az-evh-x-001"
    },
    "diagnosticLogCategoriesToEnable": {
      "value": [
        "SynapseRbacOperations",
        "GatewayApiRequests",
        "BuiltinSqlReqsEnded",
        "IntegrationPipelineRuns",
        "IntegrationActivityRuns",
        "IntegrationTriggerRuns"
      ]
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-synws-basic-001'
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsaweux004'
    defaultDataLakeStorageFilesystem: 'synapsews'
    sqlAdministratorLogin: 'synwsadmin'
    initialWorkspaceAdminObjectId: '<<deploymentSpId>>'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsalaw001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    diagnosticLogCategoriesToEnable: [
      'SynapseRbacOperations'
      'GatewayApiRequests'
      'BuiltinSqlReqsEnded'
      'IntegrationPipelineRuns'
      'IntegrationActivityRuns'
      'IntegrationTriggerRuns'
    ]
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<<namePrefix>>-az-synws-encryptwsai-001"
    },
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsaweux004"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    "encryption": {
      "value": true
    },
    "encryptionKeyVaultName": {
      "value": "adp-<<namePrefix>>-az-kv-nopr-002"
    },
    "encryptionKeyVaultResourceGroupName": {
      "value": "validation-rg"
    },
    "encryptionKeyName": {
      "value": "keyEncryptionKey"
    },
    "encryptionUseSystemAssignedIdentity": {
      "value": true
    },
    "encryptionActivateWorkspace": {
      "value": true
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-synws-encryptwsai-001'
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsaweux004'
    defaultDataLakeStorageFilesystem: 'synapsews'
    sqlAdministratorLogin: 'synwsadmin'
    encryption: true
    encryptionKeyVaultName: 'adp-<<namePrefix>>-az-kv-nopr-002'
    encryptionKeyVaultResourceGroupName: 'validation-rg'
    encryptionKeyName: 'keyEncryptionKey'
    encryptionUseSystemAssignedIdentity: true
    encryptionActivateWorkspace: true
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<<namePrefix>>-az-synws-encryptwuai-001"
    },
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsaweux004"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    "encryption": {
      "value": true
    },
    "encryptionKeyVaultName": {
      "value": "adp-<<namePrefix>>-az-kv-nopr-002"
    },
    "encryptionKeyVaultResourceGroupName": {
      "value": "validation-rg"
    },
    "encryptionKeyName": {
      "value": "keyEncryptionKey"
    },
    "encryptionUserAssignedIdentity": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-synws-encryptwuai-001'
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsaweux004'
    defaultDataLakeStorageFilesystem: 'synapsews'
    sqlAdministratorLogin: 'synwsadmin'
    encryption: true
    encryptionKeyVaultName: 'adp-<<namePrefix>>-az-kv-nopr-002'
    encryptionKeyVaultResourceGroupName: 'validation-rg'
    encryptionKeyName: 'keyEncryptionKey'
    encryptionUserAssignedIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
  }
}
```

</details>
<p>

<h3>Example 4</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<<namePrefix>>-az-synws-managedvnet-001"
    },
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsaweux005"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    "managedVirtualNetwork": {
      "value": true
    },
    "preventDataExfiltration": {
      "value": true
    },
    "allowedAadTenantIdsForLinking": {
      "value": ["<<tenantId>>"]
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-synws-managedvnet-001'
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsaweux005'
    defaultDataLakeStorageFilesystem: 'synapsews'
    sqlAdministratorLogin: 'synwsadmin'
    managedVirtualNetwork: true
    preventDataExfiltration: true
    allowedAadTenantIdsForLinking: [
      '<<tenantId>>'
    ]
  }
}
```

</details>
<p>

<h3>Example 5</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<<namePrefix>>-az-synws-min-001"
    },
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsaweux004"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workspaces'
  params: {
    name: '<<namePrefix>>-az-synws-min-001'
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsaweux004'
    defaultDataLakeStorageFilesystem: 'synapsews'
    sqlAdministratorLogin: 'synwsadmin'
  }
}
```

</details>
<p>
