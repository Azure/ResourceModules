# Data Factories `[Microsoft.DataFactory/factories]`

This module deploys a Data Factory.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DataFactory/factories` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories) |
| `Microsoft.DataFactory/factories/integrationRuntimes` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes) |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks) |
| `Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks/managedPrivateEndpoints) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/data-factory.factory:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module factory 'br:bicep/modules/data-factory.factory:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dffcom'
  params: {
    // Required parameters
    name: 'dffcom001'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gitConfigureLater: true
    globalParameters: {
      testParameter1: {
        type: 'String'
        value: 'testValue1'
      }
    }
    integrationRuntimes: [
      {
        managedVirtualNetworkName: 'default'
        name: 'AutoResolveIntegrationRuntime'
        type: 'Managed'
        typeProperties: {
          computeProperties: {
            location: 'AutoResolve'
          }
        }
      }
      {
        name: 'TestRuntime'
        type: 'SelfHosted'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managedPrivateEndpoints: [
      {
        fqdns: [
          '<storageAccountBlobEndpoint>'
        ]
        groupId: 'blob'
        name: '<name>'
        privateLinkResourceId: '<privateLinkResourceId>'
      }
    ]
    managedVirtualNetworkName: 'default'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'dataFactory'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          application: 'CARML'
          'hidden-title': 'This is visible in the resource name'
        }
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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
    "name": {
      "value": "dffcom001"
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
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
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
    "gitConfigureLater": {
      "value": true
    },
    "globalParameters": {
      "value": {
        "testParameter1": {
          "type": "String",
          "value": "testValue1"
        }
      }
    },
    "integrationRuntimes": {
      "value": [
        {
          "managedVirtualNetworkName": "default",
          "name": "AutoResolveIntegrationRuntime",
          "type": "Managed",
          "typeProperties": {
            "computeProperties": {
              "location": "AutoResolve"
            }
          }
        },
        {
          "name": "TestRuntime",
          "type": "SelfHosted"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managedPrivateEndpoints": {
      "value": [
        {
          "fqdns": [
            "<storageAccountBlobEndpoint>"
          ],
          "groupId": "blob",
          "name": "<name>",
          "privateLinkResourceId": "<privateLinkResourceId>"
        }
      ]
    },
    "managedVirtualNetworkName": {
      "value": "default"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "dataFactory",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "application": "CARML",
            "hidden-title": "This is visible in the resource name"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module factory 'br:bicep/modules/data-factory.factory:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dffmin'
  params: {
    // Required parameters
    name: 'dffmin001'
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
    "name": {
      "value": "dffmin001"
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
| [`name`](#parameter-name) | string | The name of the Azure Factory to create. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`gitAccountName`](#parameter-gitaccountname) | string | The account name. |
| [`gitCollaborationBranch`](#parameter-gitcollaborationbranch) | string | The collaboration branch name. Default is 'main'. |
| [`gitConfigureLater`](#parameter-gitconfigurelater) | bool | Boolean to define whether or not to configure git during template deployment. |
| [`gitDisablePublish`](#parameter-gitdisablepublish) | bool | Disable manual publish operation in ADF studio to favor automated publish. |
| [`gitHostName`](#parameter-githostname) | string | The GitHub Enterprise Server host (prefixed with 'https://'). Only relevant for 'FactoryGitHubConfiguration'. |
| [`gitProjectName`](#parameter-gitprojectname) | string | The project name. Only relevant for 'FactoryVSTSConfiguration'. |
| [`gitRepositoryName`](#parameter-gitrepositoryname) | string | The repository name. |
| [`gitRepoType`](#parameter-gitrepotype) | string | Repository type - can be 'FactoryVSTSConfiguration' or 'FactoryGitHubConfiguration'. Default is 'FactoryVSTSConfiguration'. |
| [`gitRootFolder`](#parameter-gitrootfolder) | string | The root folder path name. Default is '/'. |
| [`globalParameters`](#parameter-globalparameters) | object | List of Global Parameters for the factory. |
| [`integrationRuntimes`](#parameter-integrationruntimes) | array | An array of objects for the configuration of an Integration Runtime. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedPrivateEndpoints`](#parameter-managedprivateendpoints) | array | An array of managed private endpoints objects created in the Data Factory managed virtual network. |
| [`managedVirtualNetworkName`](#parameter-managedvirtualnetworkname) | string | The name of the Managed Virtual Network. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

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

### Parameter: `cMKKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUserAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

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
- Allowed: `['', ActivityRuns, allLogs, PipelineRuns, SSISIntegrationRuntimeLogs, SSISPackageEventMessageContext, SSISPackageEventMessages, SSISPackageExecutableStatistics, SSISPackageExecutionComponentPhases, SSISPackageExecutionDataStatistics, TriggerRuns]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

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

### Parameter: `gitAccountName`

The account name.
- Required: No
- Type: string
- Default: `''`

### Parameter: `gitCollaborationBranch`

The collaboration branch name. Default is 'main'.
- Required: No
- Type: string
- Default: `'main'`

### Parameter: `gitConfigureLater`

Boolean to define whether or not to configure git during template deployment.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `gitDisablePublish`

Disable manual publish operation in ADF studio to favor automated publish.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `gitHostName`

The GitHub Enterprise Server host (prefixed with 'https://'). Only relevant for 'FactoryGitHubConfiguration'.
- Required: No
- Type: string
- Default: `''`

### Parameter: `gitProjectName`

The project name. Only relevant for 'FactoryVSTSConfiguration'.
- Required: No
- Type: string
- Default: `''`

### Parameter: `gitRepositoryName`

The repository name.
- Required: No
- Type: string
- Default: `''`

### Parameter: `gitRepoType`

Repository type - can be 'FactoryVSTSConfiguration' or 'FactoryGitHubConfiguration'. Default is 'FactoryVSTSConfiguration'.
- Required: No
- Type: string
- Default: `'FactoryVSTSConfiguration'`

### Parameter: `gitRootFolder`

The root folder path name. Default is '/'.
- Required: No
- Type: string
- Default: `'/'`

### Parameter: `globalParameters`

List of Global Parameters for the factory.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `integrationRuntimes`

An array of objects for the configuration of an Integration Runtime.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all Resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | No | bool | Optional. Enables system assigned managed identity on the resource. |
| [`userAssignedResourcesIds`](#parameter-managedidentitiesuserassignedresourcesids) | No | array | Optional. The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Optional. Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourcesIds`

Optional. The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `managedPrivateEndpoints`

An array of managed private endpoints objects created in the Data Factory managed virtual network.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `managedVirtualNetworkName`

The name of the Managed Virtual Network.
- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the Azure Factory to create.
- Required: Yes
- Type: string

### Parameter: `privateEndpoints`

Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the Azure Data Factory instance. |
| `resourceGroupName` | string | The name of the Resource Group with the Data factory. |
| `resourceId` | string | The Resource ID of the Data factory. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

## Notes

### Parameter Usage: `managedPrivateEndpoints`

To use Managed Private Endpoints the following dependencies must be deployed:

- The `managedVirtualNetworkName` property must be set to allow provisioning of a managed virtual network in Azure Data Factory.
- Destination private link resource must be created before and permissions allow requesting a private link connection to that resource.

<details>

<summary>Parameter JSON format</summary>

```json
"managedPrivateEndpoints": {
    "value": [
        {
            "name": "mystorageaccount-managed-privateEndpoint", // Required: The managed private endpoint resource name
            "groupId": "blob", // Required: The groupId to which the managed private endpoint is created
            "fqdns": [
                "mystorageaccount.blob.core.windows.net" // Required: Fully qualified domain names
            ],
            "privateLinkResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
            // Required: The ARM resource ID of the resource to which the managed private endpoint is created.
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
managedPrivateEndpoints:  [
    // Example showing all available fields
    {
        name: 'mystorageaccount-managed-privateEndpoint' // Required: The managed private endpoint resource name
        groupId: 'blob' // Required: The groupId to which the managed private endpoint is created
        fqdns: [
          'mystorageaccount.blob.core.windows.net' // Required: Fully qualified domain names
        ]
        privateLinkResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount'
    } // Required: The ARM resource ID of the resource to which the managed private endpoint is created.
]
```

</details>
<p>
