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
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Synapse/workspaces` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces) |
| `Microsoft.Synapse/workspaces/integrationRuntimes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/integrationRuntimes) |
| `Microsoft.Synapse/workspaces/keys` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `defaultDataLakeStorageAccountResourceId` | string | Resource ID of the default ADLS Gen2 storage account. |
| `defaultDataLakeStorageFilesystem` | string | The default ADLS Gen2 file system. |
| `name` | string | The name of the Synapse Workspace. |
| `sqlAdministratorLogin` | string | Login for administrator access to the workspace's SQL pools. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKKeyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowedAadTenantIdsForLinking` | array | `[]` |  | Allowed AAD Tenant IDs For Linking. |
| `azureADOnlyAuthentication` | bool | `False` |  | Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKUserAssignedIdentityResourceId` | string | `''` |  | The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `cMKUseSystemAssignedIdentity` | bool | `False` |  | Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault. |
| `defaultDataLakeStorageCreateManagedPrivateEndpoint` | bool | `False` |  | Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, BuiltinSqlReqsEnded, GatewayApiRequests, IntegrationActivityRuns, IntegrationPipelineRuns, IntegrationTriggerRuns, SQLSecurityAuditEvents, SynapseLinkEvent, SynapseRbacOperations]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `encryption` | bool | `False` |  | Double encryption using a customer-managed key. |
| `encryptionActivateWorkspace` | bool | `False` |  | Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace. |
| `initialWorkspaceAdminObjectID` | string | `''` |  | AAD object ID of initial workspace admin. |
| `integrationRuntimes` | array | `[]` |  | The Integration Runtimes to create. |
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
| `workspaceRepositoryConfiguration` | object | `{object}` |  | Git integration settings. |


## Outputs

| Output Name | Type | Description |
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
| `network/private-endpoint` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './synapse/workspace/main.bicep' = {
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
            '<privateDNSResourceId>'
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
              "<privateDNSResourceId>"
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

<h3>Example 2: Encrwsai</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './synapse/workspace/main.bicep' = {
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

<h3>Example 3: Encrwuai</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './synapse/workspace/main.bicep' = {
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

<h3>Example 4: Managedvnet</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './synapse/workspace/main.bicep' = {
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

<h3>Example 5: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './synapse/workspace/main.bicep' = {
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
