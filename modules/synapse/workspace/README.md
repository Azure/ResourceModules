# Synapse Workspaces `[Microsoft.Synapse/workspaces]`

This module deploys a Synapse Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Synapse/workspaces` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces) |
| `Microsoft.Synapse/workspaces/integrationRuntimes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/integrationRuntimes) |
| `Microsoft.Synapse/workspaces/keys` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/synapse.workspace:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Encrwsai](#example-2-encrwsai)
- [Encrwuai](#example-3-encrwuai)
- [Managedvnet](#example-4-managedvnet)
- [Using only defaults](#example-5-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/synapse.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-swcom'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swcom001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogCategoriesToEnable: [
      'BuiltinSqlReqsEnded'
      'GatewayApiRequests'
      'IntegrationActivityRuns'
      'IntegrationPipelineRuns'
      'IntegrationTriggerRuns'
      'SQLSecurityAuditEvents'
      'SynapseLinkEvent'
      'SynapseRbacOperations'
    ]
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    initialWorkspaceAdminObjectID: '<initialWorkspaceAdminObjectID>'
    integrationRuntimes: [
      {
        name: 'shir01'
        type: 'SelfHosted'
      }
    ]
    managedVirtualNetwork: true
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'SQL'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swcom001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogCategoriesToEnable": {
      "value": [
        "BuiltinSqlReqsEnded",
        "GatewayApiRequests",
        "IntegrationActivityRuns",
        "IntegrationPipelineRuns",
        "IntegrationTriggerRuns",
        "SQLSecurityAuditEvents",
        "SynapseLinkEvent",
        "SynapseRbacOperations"
      ]
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "initialWorkspaceAdminObjectID": {
      "value": "<initialWorkspaceAdminObjectID>"
    },
    "integrationRuntimes": {
      "value": [
        {
          "name": "shir01",
          "type": "SelfHosted"
        }
      ]
    },
    "managedVirtualNetwork": {
      "value": true
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "SQL",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Encrwsai_

<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/synapse.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-swensa'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swensa001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUseSystemAssignedIdentity: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swensa001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUseSystemAssignedIdentity": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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

### Example 3: _Encrwuai_

<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/synapse.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-swenua'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swenua001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryption: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swenua001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryption": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 4: _Managedvnet_

<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/synapse.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-swmanv'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swmanv001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    allowedAadTenantIdsForLinking: [
      '<tenantId>'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedVirtualNetwork: true
    preventDataExfiltration: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swmanv001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "allowedAadTenantIdsForLinking": {
      "value": [
        "<tenantId>"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedVirtualNetwork": {
      "value": true
    },
    "preventDataExfiltration": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 5: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/synapse.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-swmin'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swmin001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swmin001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultDataLakeStorageAccountResourceId`](#parameter-defaultdatalakestorageaccountresourceid) | string | Resource ID of the default ADLS Gen2 storage account. |
| [`defaultDataLakeStorageFilesystem`](#parameter-defaultdatalakestoragefilesystem) | string | The default ADLS Gen2 file system. |
| [`name`](#parameter-name) | string | The name of the Synapse Workspace. |
| [`sqlAdministratorLogin`](#parameter-sqladministratorlogin) | string | Login for administrator access to the workspace's SQL pools. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAadTenantIdsForLinking`](#parameter-allowedaadtenantidsforlinking) | array | Allowed AAD Tenant IDs For Linking. |
| [`azureADOnlyAuthentication`](#parameter-azureadonlyauthentication) | bool | Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource. |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| [`cMKUseSystemAssignedIdentity`](#parameter-cmkusesystemassignedidentity) | bool | Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| [`defaultDataLakeStorageCreateManagedPrivateEndpoint`](#parameter-defaultdatalakestoragecreatemanagedprivateendpoint) | bool | Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`encryption`](#parameter-encryption) | bool | Double encryption using a customer-managed key. |
| [`encryptionActivateWorkspace`](#parameter-encryptionactivateworkspace) | bool | Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace. |
| [`initialWorkspaceAdminObjectID`](#parameter-initialworkspaceadminobjectid) | string | AAD object ID of initial workspace admin. |
| [`integrationRuntimes`](#parameter-integrationruntimes) | array | The Integration Runtimes to create. |
| [`linkedAccessCheckOnTargetResource`](#parameter-linkedaccesscheckontargetresource) | bool | Linked Access Check On Target Resource. |
| [`location`](#parameter-location) | string | The geo-location where the resource lives. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`managedResourceGroupName`](#parameter-managedresourcegroupname) | string | Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.'. |
| [`managedVirtualNetwork`](#parameter-managedvirtualnetwork) | bool | Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources. |
| [`preventDataExfiltration`](#parameter-preventdataexfiltration) | bool | Prevent Data Exfiltration. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Enable or Disable public network access to workspace. |
| [`purviewResourceID`](#parameter-purviewresourceid) | string | Purview Resource ID. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sqlAdministratorLoginPassword`](#parameter-sqladministratorloginpassword) | string | Password for administrator access to the workspace's SQL pools. If you don't provide a password, one will be automatically generated. You can change the password later. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`workspaceRepositoryConfiguration`](#parameter-workspacerepositoryconfiguration) | object | Git integration settings. |

### Parameter: `allowedAadTenantIdsForLinking`

Allowed AAD Tenant IDs For Linking.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `azureADOnlyAuthentication`

Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `cMKKeyName`

The name of the customer managed key to use for encryption.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUserAssignedIdentityResourceId`

The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUseSystemAssignedIdentity`

Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultDataLakeStorageAccountResourceId`

Resource ID of the default ADLS Gen2 storage account.
- Required: Yes
- Type: string

### Parameter: `defaultDataLakeStorageCreateManagedPrivateEndpoint`

Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultDataLakeStorageFilesystem`

The default ADLS Gen2 file system.
- Required: Yes
- Type: string

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, BuiltinSqlReqsEnded, GatewayApiRequests, IntegrationActivityRuns, IntegrationPipelineRuns, IntegrationTriggerRuns, SQLSecurityAuditEvents, SynapseLinkEvent, SynapseRbacOperations]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryption`

Double encryption using a customer-managed key.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `encryptionActivateWorkspace`

Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `initialWorkspaceAdminObjectID`

AAD object ID of initial workspace admin.
- Required: No
- Type: string
- Default: `''`

### Parameter: `integrationRuntimes`

The Integration Runtimes to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `linkedAccessCheckOnTargetResource`

Linked Access Check On Target Resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

The geo-location where the resource lives.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `managedResourceGroupName`

Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.'.
- Required: No
- Type: string
- Default: `''`

### Parameter: `managedVirtualNetwork`

Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `name`

The name of the Synapse Workspace.
- Required: Yes
- Type: string

### Parameter: `preventDataExfiltration`

Prevent Data Exfiltration.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Enable or Disable public network access to workspace.
- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `purviewResourceID`

Purview Resource ID.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sqlAdministratorLogin`

Login for administrator access to the workspace's SQL pools.
- Required: Yes
- Type: string

### Parameter: `sqlAdministratorLoginPassword`

Password for administrator access to the workspace's SQL pools. If you don't provide a password, one will be automatically generated. You can change the password later.
- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workspaceRepositoryConfiguration`

Git integration settings.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `connectivityEndpoints` | object | The workspace connectivity endpoints. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Synapse Workspace. |
| `resourceGroupName` | string | The resource group of the deployed Synapse Workspace. |
| `resourceID` | string | The resource ID of the deployed Synapse Workspace. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
