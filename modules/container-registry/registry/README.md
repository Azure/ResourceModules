# Azure Container Registries (ACR) `[Microsoft.ContainerRegistry/registries]`

This module deploys an Azure Container Registry (ACR).

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of your Azure container registry. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKUserAssignedIdentityResourceId` | string | `''` | User assigned identity to use when fetching the customer managed key. Note, CMK requires the 'acrSku' to be 'Premium'. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `acrAdminUserEnabled` | bool | `False` |  | Enable admin user that have push / pull permission to the registry. |
| `acrSku` | string | `'Basic'` | `[Basic, Premium, Standard]` | Tier of your Azure container registry. |
| `anonymousPullEnabled` | bool | `False` |  | Enables registry-wide pull from unauthenticated clients. It's in preview and available in the Standard and Premium service tiers. |
| `azureADAuthenticationAsArmPolicyStatus` | string | `'enabled'` | `[disabled, enabled]` | The value that indicates whether the policy for using ARM audience token for a container registr is enabled or not. Default is enabled. |
| `cacheRules` | _[cacheRules](cache-rules/README.md)_ array | `[]` |  | Array of Cache Rules. Note: This is a preview feature ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache#cache-for-acr-preview)). |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. Note, CMK requires the 'acrSku' to be 'Premium'. |
| `cMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. Note, CMK requires the 'acrSku' to be 'Premium'. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `dataEndpointEnabled` | bool | `False` |  | Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. Note, requires the 'acrSku' to be 'Premium'. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, ContainerRegistryLoginEvents, ContainerRegistryRepositoryEvents]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `exportPolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | The value that indicates whether the export policy is enabled or not. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `networkRuleBypassOptions` | string | `'AzureServices'` | `[AzureServices, None]` | Whether to allow trusted Azure services to access a network restricted registry. |
| `networkRuleSetDefaultAction` | string | `'Deny'` | `[Allow, Deny]` | The default action of allow or deny when no other rules match. |
| `networkRuleSetIpRules` | array | `[]` |  | The IP ACL rules. Note, requires the 'acrSku' to be 'Premium'. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'acrSku' to be 'Premium'. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'. |
| `quarantinePolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | The value that indicates whether the quarantine policy is enabled or not. |
| `replications` | array | `[]` |  | All replications to create. |
| `retentionPolicyDays` | int | `15` |  | The number of days to retain an untagged manifest after which it gets purged. |
| `retentionPolicyStatus` | string | `'enabled'` | `[disabled, enabled]` | The value that indicates whether the retention policy is enabled or not. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `softDeletePolicyDays` | int | `7` |  | The number of days after which a soft-deleted item is permanently deleted. |
| `softDeletePolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | Soft Delete policy status. Default is disabled. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `trustPolicyStatus` | string | `'disabled'` | `[disabled, enabled]` | The value that indicates whether the trust policy is enabled or not. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `webhooks` | array | `[]` |  | All webhooks to create. |
| `zoneRedundancy` | string | `'Disabled'` | `[Disabled, Enabled]` | Whether or not zone redundancy is enabled for this container registry. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `loginServer` | string | The reference to the Azure container registry. |
| `name` | string | The Name of the Azure container registry. |
| `resourceGroupName` | string | The name of the Azure container registry. |
| `resourceId` | string | The resource ID of the Azure container registry. |
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
module registry './container-registry/registry/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crrcom'
  params: {
    // Required parameters
    name: 'crrcom001'
    // Non-required parameters
    acrAdminUserEnabled: false
    acrSku: 'Premium'
    azureADAuthenticationAsArmPolicyStatus: 'enabled'
    cacheRules: [
      {
        name: 'customRule'
        sourceRepository: 'docker.io/library/hello-world'
        targetRepository: 'cached-docker-hub/hello-world'
      }
      {
        sourceRepository: 'docker.io/library/hello-world'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exportPolicyStatus: 'enabled'
    lock: 'CanNotDelete'
    networkRuleSetIpRules: [
      {
        action: 'Allow'
        value: '40.74.28.0/23'
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'registry'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    quarantinePolicyStatus: 'enabled'
    replications: [
      {
        location: '<location>'
        name: '<name>'
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
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    trustPolicyStatus: 'enabled'
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    webhooks: [
      {
        name: 'acrx001webhook'
        serviceUri: 'https://www.contoso.com/webhook'
      }
    ]
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
      "value": "crrcom001"
    },
    // Non-required parameters
    "acrAdminUserEnabled": {
      "value": false
    },
    "acrSku": {
      "value": "Premium"
    },
    "azureADAuthenticationAsArmPolicyStatus": {
      "value": "enabled"
    },
    "cacheRules": {
      "value": [
        {
          "name": "customRule",
          "sourceRepository": "docker.io/library/hello-world",
          "targetRepository": "cached-docker-hub/hello-world"
        },
        {
          "sourceRepository": "docker.io/library/hello-world"
        }
      ]
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
    "exportPolicyStatus": {
      "value": "enabled"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "networkRuleSetIpRules": {
      "value": [
        {
          "action": "Allow",
          "value": "40.74.28.0/23"
        }
      ]
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "registry",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "quarantinePolicyStatus": {
      "value": "enabled"
    },
    "replications": {
      "value": [
        {
          "location": "<location>",
          "name": "<name>"
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
    "softDeletePolicyDays": {
      "value": 7
    },
    "softDeletePolicyStatus": {
      "value": "disabled"
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "trustPolicyStatus": {
      "value": "enabled"
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "webhooks": {
      "value": [
        {
          "name": "acrx001webhook",
          "serviceUri": "https://www.contoso.com/webhook"
        }
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 2: Encr</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module registry './container-registry/registry/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crrencr'
  params: {
    // Required parameters
    name: 'crrencr001'
    // Non-required parameters
    acrSku: 'Premium'
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicNetworkAccess: 'Disabled'
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
    "name": {
      "value": "crrencr001"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Premium"
    },
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
    "publicNetworkAccess": {
      "value": "Disabled"
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

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module registry './container-registry/registry/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crrmin'
  params: {
    // Required parameters
    name: 'crrmin001'
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
      "value": "crrmin001"
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

<h3>Example 4: Pe</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module registry './container-registry/registry/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-crrpe'
  params: {
    // Required parameters
    name: 'crrpe001'
    // Non-required parameters
    acrSku: 'Premium'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'registry'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
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
      "value": "crrpe001"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Premium"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "registry",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
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
