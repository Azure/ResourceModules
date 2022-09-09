# Synapse Workspaces `[Microsoft.Synapse/workspaces]`

This module deploys a Synapse Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies) |
| `Microsoft.Network/privateEndpoints` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints/privateDnsZoneGroups) |
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
| `allowedAadTenantIdsForLinking` | array | `[]` |  | Allowed AAD Tenant IDs For Linking. |
| `azureADOnlyAuthentication` | bool | `False` |  | Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. |
| `cMKUserAssignedIdentityResourceId` | bool | `False` |  | Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `defaultDataLakeStorageCreateManagedPrivateEndpoint` | bool | `False` |  | Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[BuiltinSqlReqsEnded, GatewayApiRequests, IntegrationActivityRuns, IntegrationPipelineRuns, IntegrationTriggerRuns, SynapseRbacOperations]` | `[BuiltinSqlReqsEnded, GatewayApiRequests, IntegrationActivityRuns, IntegrationPipelineRuns, IntegrationTriggerRuns, SynapseRbacOperations]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `encryption` | bool | `False` |  | Double encryption using a customer-managed key. |
| `encryptionActivateWorkspace` | bool | `False` |  | Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace. |
| `encryptionUserAssignedIdentity` | string | `''` |  | The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `initialWorkspaceAdminObjectID` | string | `''` |  | AAD object ID of initial workspace admin. |
| `linkedAccessCheckOnTargetResource` | bool | `False` |  | Linked Access Check On Target Resource. |
| `location` | string | `[resourceGroup().location]` |  | The geo-location where the resource lives. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedResourceGroupName` | string | `''` |  | Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.'. |
| `managedVirtualNetwork` | bool | `False` |  | Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources. |
| `preventDataExfiltration` | bool | `False` |  | Prevent Data Exfiltration. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | Enable or Disable public network access to workspace. |
| `purviewResourceID` | string | `''` |  | Purview Resource ID. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
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
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
                ]
            },
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
        privateDnsZoneGroups: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
            ]
        }
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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Synapse Workspace. |
| `resourceGroupName` | string | The resource group of the deployed Synapse Workspace. |
| `resourceID` | string | The resource ID of the deployed Synapse Workspace. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Encryptionwsai</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-Workspaces'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsasynapse001'
    defaultDataLakeStorageFilesystem: 'synapsews'
    name: '<<namePrefix>>-az-synws-encryptwsai-001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    cMKKeyName: 'keyEncryptionKey'
    cMKKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002'
    cMKUserAssignedIdentityResourceId: true
    encryption: true
    encryptionActivateWorkspace: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsasynapse001"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "name": {
      "value": "<<namePrefix>>-az-synws-encryptwsai-001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "keyEncryptionKey"
    },
    "cMKKeyVaultResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": true
    },
    "encryption": {
      "value": true
    },
    "encryptionActivateWorkspace": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 2: Encryptionwuai</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-Workspaces'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsasynapse001'
    defaultDataLakeStorageFilesystem: 'synapsews'
    name: '<<namePrefix>>-az-synws-encryptwuai-001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    cMKKeyName: 'keyEncryptionKey'
    cMKKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002'
    encryption: true
    encryptionUserAssignedIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsasynapse001"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "name": {
      "value": "<<namePrefix>>-az-synws-encryptwuai-001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "keyEncryptionKey"
    },
    "cMKKeyVaultResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002"
    },
    "encryption": {
      "value": true
    },
    "encryptionUserAssignedIdentity": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
    }
  }
}
```

</details>
<p>

<h3>Example 3: Managedvnet</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-Workspaces'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsasynapse002'
    defaultDataLakeStorageFilesystem: 'synapsews'
    name: '<<namePrefix>>-az-synws-managedvnet-001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    allowedAadTenantIdsForLinking: [
      '<<tenantId>>'
    ]
    managedVirtualNetwork: true
    preventDataExfiltration: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsasynapse002"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "name": {
      "value": "<<namePrefix>>-az-synws-managedvnet-001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "allowedAadTenantIdsForLinking": {
      "value": [
        "<<tenantId>>"
      ]
    },
    "managedVirtualNetwork": {
      "value": true
    },
    "preventDataExfiltration": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 4: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-Workspaces'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsasynapse001'
    defaultDataLakeStorageFilesystem: 'synapsews'
    name: '<<namePrefix>>-az-synws-min-001'
    sqlAdministratorLogin: 'synwsadmin'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsasynapse001"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "name": {
      "value": "<<namePrefix>>-az-synws-min-001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.Synapse/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-Workspaces'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountName: 'adp<<namePrefix>>azsasynapse001'
    defaultDataLakeStorageFilesystem: 'synapsews'
    name: '<<namePrefix>>-az-synws-x-001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    diagnosticLogCategoriesToEnable: [
      'BuiltinSqlReqsEnded'
      'GatewayApiRequests'
      'IntegrationActivityRuns'
      'IntegrationPipelineRuns'
      'IntegrationTriggerRuns'
      'SynapseRbacOperations'
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsalaw001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    initialWorkspaceAdminObjectId: '<<deploymentSpId>>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.sql.azuresynapse.net'
          ]
        }
        service: 'SQL'
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<<deploymentSpId>>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "defaultDataLakeStorageAccountName": {
      "value": "adp<<namePrefix>>azsasynapse001"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "synapsews"
    },
    "name": {
      "value": "<<namePrefix>>-az-synws-x-001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
    },
    "diagnosticEventHubName": {
      "value": "adp-<<namePrefix>>-az-evh-x-001"
    },
    "diagnosticLogCategoriesToEnable": {
      "value": [
        "BuiltinSqlReqsEnded",
        "GatewayApiRequests",
        "IntegrationActivityRuns",
        "IntegrationPipelineRuns",
        "IntegrationTriggerRuns",
        "SynapseRbacOperations"
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
    "initialWorkspaceAdminObjectId": {
      "value": "<<deploymentSpId>>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.sql.azuresynapse.net"
            ]
          },
          "service": "SQL",
          "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<<deploymentSpId>>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "userAssignedIdentities": {
      "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
      }
    }
  }
}
```

</details>
<p>
