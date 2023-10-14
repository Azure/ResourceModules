# Machine Learning Services Workspaces `[Microsoft.MachineLearningServices/workspaces]`

This module deploys a Machine Learning Services Workspace.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.MachineLearningServices/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/machine-learning-services.workspace:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Encr](#example-2-encr)
- [Using Maximum Parameters](#example-3-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/machine-learning-services.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mlswcom'
  params: {
    // Required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    name: 'mlswcom001'
    sku: 'Premium'
    // Non-required parameters
    computes: [
      {
        computeLocation: 'westeurope'
        computeType: 'AmlCompute'
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        location: 'westeurope'
        name: 'DefaultCPU'
        properties: {
          enableNodePublicIp: true
          isolatedNetwork: false
          osType: 'Linux'
          remoteLoginPortPublicAccess: 'Disabled'
          scaleSettings: {
            maxNodeCount: 3
            minNodeCount: 0
            nodeIdleTimeBeforeScaleDown: 'PT5M'
          }
          vmPriority: 'Dedicated'
          vmSize: 'STANDARD_DS11_V2'
        }
        sku: 'Basic'
        systemAssignedIdentity: false
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
      }
    ]
    description: 'The cake is a lie.'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    discoveryUrl: 'http://example.com'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    imageBuildCompute: 'testcompute'
    lock: 'CanNotDelete'
    primaryUserAssignedIdentity: '<primaryUserAssignedIdentity>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'amlworkspace'
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
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: false
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "name": {
      "value": "mlswcom001"
    },
    "sku": {
      "value": "Premium"
    },
    // Non-required parameters
    "computes": {
      "value": [
        {
          "computeLocation": "westeurope",
          "computeType": "AmlCompute",
          "description": "Default CPU Cluster",
          "disableLocalAuth": false,
          "location": "westeurope",
          "name": "DefaultCPU",
          "properties": {
            "enableNodePublicIp": true,
            "isolatedNetwork": false,
            "osType": "Linux",
            "remoteLoginPortPublicAccess": "Disabled",
            "scaleSettings": {
              "maxNodeCount": 3,
              "minNodeCount": 0,
              "nodeIdleTimeBeforeScaleDown": "PT5M"
            },
            "vmPriority": "Dedicated",
            "vmSize": "STANDARD_DS11_V2"
          },
          "sku": "Basic",
          "systemAssignedIdentity": false,
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          }
        }
      ]
    },
    "description": {
      "value": "The cake is a lie."
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
    "discoveryUrl": {
      "value": "http://example.com"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "imageBuildCompute": {
      "value": "testcompute"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "primaryUserAssignedIdentity": {
      "value": "<primaryUserAssignedIdentity>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "amlworkspace",
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
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": false
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
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

### Example 2: _Encr_

<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/machine-learning-services.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mlswecr'
  params: {
    // Required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    name: 'mlswecr001'
    sku: 'Basic'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    primaryUserAssignedIdentity: '<primaryUserAssignedIdentity>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'amlworkspace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    systemAssignedIdentity: false
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "name": {
      "value": "mlswecr001"
    },
    "sku": {
      "value": "Basic"
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
    "primaryUserAssignedIdentity": {
      "value": "<primaryUserAssignedIdentity>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "amlworkspace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": false
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
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

### Example 3: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/machine-learning-services.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mlswmin'
  params: {
    // Required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    name: 'mlswmin001'
    sku: 'Basic'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    systemAssignedIdentity: true
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
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "name": {
      "value": "mlswmin001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "systemAssignedIdentity": {
      "value": true
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
| [`associatedApplicationInsightsResourceId`](#parameter-associatedapplicationinsightsresourceid) | string | The resource ID of the associated Application Insights. |
| [`associatedKeyVaultResourceId`](#parameter-associatedkeyvaultresourceid) | string | The resource ID of the associated Key Vault. |
| [`associatedStorageAccountResourceId`](#parameter-associatedstorageaccountresourceid) | string | The resource ID of the associated Storage Account. |
| [`name`](#parameter-name) | string | The name of the machine learning workspace. |
| [`sku`](#parameter-sku) | string | Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| [`primaryUserAssignedIdentity`](#parameter-primaryuserassignedidentity) | string | The user assigned identity resource ID that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. Required if `userAssignedIdentities` is not provided. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. Required if `systemAssignedIdentity` is set to false. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowPublicAccessWhenBehindVnet`](#parameter-allowpublicaccesswhenbehindvnet) | bool | The flag to indicate whether to allow public access when behind VNet. |
| [`associatedContainerRegistryResourceId`](#parameter-associatedcontainerregistryresourceid) | string | The resource ID of the associated Container Registry. |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first. |
| [`computes`](#parameter-computes) | array | Computes to create respectively attach to the workspace. |
| [`description`](#parameter-description) | string | The description of this workspace. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`discoveryUrl`](#parameter-discoveryurl) | string | URL for the discovery service to identify regional endpoints for machine learning experimentation services. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`hbiWorkspace`](#parameter-hbiworkspace) | bool | The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. |
| [`imageBuildCompute`](#parameter-imagebuildcompute) | string | The compute name for image build. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`serviceManagedResourcesSettings`](#parameter-servicemanagedresourcessettings) | object | The service managed resource settings. |
| [`sharedPrivateLinkResources`](#parameter-sharedprivatelinkresources) | array | The list of shared private link resources in this workspace. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `allowPublicAccessWhenBehindVnet`

The flag to indicate whether to allow public access when behind VNet.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `associatedApplicationInsightsResourceId`

The resource ID of the associated Application Insights.
- Required: Yes
- Type: string

### Parameter: `associatedContainerRegistryResourceId`

The resource ID of the associated Container Registry.
- Required: No
- Type: string
- Default: `''`

### Parameter: `associatedKeyVaultResourceId`

The resource ID of the associated Key Vault.
- Required: Yes
- Type: string

### Parameter: `associatedStorageAccountResourceId`

The resource ID of the associated Storage Account.
- Required: Yes
- Type: string

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

User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first.
- Required: No
- Type: string
- Default: `''`

### Parameter: `computes`

Computes to create respectively attach to the workspace.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `description`

The description of this workspace.
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
- Allowed: `['', allLogs, AmlComputeClusterEvent, AmlComputeClusterNodeEvent, AmlComputeCpuGpuUtilization, AmlComputeJobEvent, AmlRunStatusChangedEvent]`

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

### Parameter: `discoveryUrl`

URL for the discovery service to identify regional endpoints for machine learning experimentation services.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `hbiWorkspace`

The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `imageBuildCompute`

The compute name for image build.
- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the machine learning workspace.
- Required: Yes
- Type: string

### Parameter: `primaryUserAssignedIdentity`

The user assigned identity resource ID that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled.
- Required: No
- Type: string
- Default: `''`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
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
- Default: `[]`

### Parameter: `serviceManagedResourcesSettings`

The service managed resource settings.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `sharedPrivateLinkResources`

The list of shared private link resources in this workspace.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sku`

Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace.
- Required: Yes
- Type: string
- Allowed: `[Basic, Free, Premium, Standard]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource. Required if `userAssignedIdentities` is not provided.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource. Required if `systemAssignedIdentity` is set to false.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the machine learning service. |
| `principalId` | string | The principal ID of the system assigned identity. |
| `resourceGroupName` | string | The resource group the machine learning service was deployed into. |
| `resourceId` | string | The resource ID of the machine learning service. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

## Notes

### Parameter Usage: `computes`

Array to specify the compute resources to create respectively attach.
In case you provide a resource ID, it will attach the resource and ignore "properties". In this case "computeLocation", "sku", "systemAssignedIdentity", "userAssignedIdentities" as well as "tags" don't need to be provided respectively are being ignored.
Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML. I.e. for the first run set "deploy" to true, and after successful deployment to false.
For more information see https://learn.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep

<details>

<summary>Parameter JSON format</summary>

```json
"computes": {
    "value": [
        // Attach existing resources
        {
            "name": "DefaultAKS",
            "location": "westeurope",
            "description": "Default AKS Cluster",
            "disableLocalAuth": false,
            "deployCompute": true,
            "computeType": "AKS",
            "resourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx"
        },
        // Create new compute resource
        {
            "name": "DefaultCPU",
            "location": "westeurope",
            "computeLocation": "westeurope",
            "sku": "Basic",
            "systemAssignedIdentity": true,
            "userAssignedIdentities": {
                "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-[[namePrefix]]-az-msi-x-001": {}
            },
            "description": "Default CPU Cluster",
            "disableLocalAuth": false,
            "computeType": "AmlCompute",
            "properties": {
                "enableNodePublicIp": true,
                "isolatedNetwork": false,
                "osType": "Linux",
                "remoteLoginPortPublicAccess": "Disabled",
                "scaleSettings": {
                    "maxNodeCount": 3,
                    "minNodeCount": 0,
                    "nodeIdleTimeBeforeScaleDown": "PT5M"
                },
                "vmPriority": "Dedicated",
                "vmSize": "STANDARD_DS11_V2"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
computes: [
    // Attach existing resources
    {
        name: 'DefaultAKS'
        location: 'westeurope'
        description: 'Default AKS Cluster'
        disableLocalAuth: false
        deployCompute: true
        computeType: 'AKS'
        resourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx'
    }
    // Create new compute resource
    {
        name: 'DefaultCPU'
        location: 'westeurope'
        computeLocation: 'westeurope'
        sku: 'Basic'
        systemAssignedIdentity: true
        userAssignedIdentities: {
            '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-[[namePrefix]]-az-msi-x-001': {}
        }
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        computeType: 'AmlCompute'
        properties: {
            enableNodePublicIp: true
            isolatedNetwork: false
            osType: 'Linux'
            remoteLoginPortPublicAccess: 'Disabled'
            scaleSettings: {
                maxNodeCount: 3
                minNodeCount: 0
                nodeIdleTimeBeforeScaleDown: 'PT5M'
            }
            vmPriority: 'Dedicated'
            vmSize: 'STANDARD_DS11_V2'
        }
    }
]
```

</details>
<p>
