# Azure Container Registries (ACR) `[Microsoft.ContainerRegistry/registries]`

This module deploys an Azure Container Registry (ACR).

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
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/container-registry.registry:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Encr](#example-2-encr)
- [Using Maximum Parameters](#example-3-using-maximum-parameters)
- [Pe](#example-4-pe)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br:bicep/modules/container-registry.registry:1.0.0' = {
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

### Example 2: _Encr_

<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br:bicep/modules/container-registry.registry:1.0.0' = {
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

### Example 3: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br:bicep/modules/container-registry.registry:1.0.0' = {
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

### Example 4: _Pe_

<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br:bicep/modules/container-registry.registry:1.0.0' = {
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of your Azure container registry. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Note, CMK requires the 'acrSku' to be 'Premium'. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrAdminUserEnabled`](#parameter-acradminuserenabled) | bool | Enable admin user that have push / pull permission to the registry. |
| [`acrSku`](#parameter-acrsku) | string | Tier of your Azure container registry. |
| [`anonymousPullEnabled`](#parameter-anonymouspullenabled) | bool | Enables registry-wide pull from unauthenticated clients. It's in preview and available in the Standard and Premium service tiers. |
| [`azureADAuthenticationAsArmPolicyStatus`](#parameter-azureadauthenticationasarmpolicystatus) | string | The value that indicates whether the policy for using ARM audience token for a container registr is enabled or not. Default is enabled. |
| [`cacheRules`](#parameter-cacherules) | array | Array of Cache Rules. Note: This is a preview feature ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache#cache-for-acr-preview)). |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. Note, CMK requires the 'acrSku' to be 'Premium'. |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Note, CMK requires the 'acrSku' to be 'Premium'. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`dataEndpointEnabled`](#parameter-dataendpointenabled) | bool | Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. Note, requires the 'acrSku' to be 'Premium'. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`exportPolicyStatus`](#parameter-exportpolicystatus) | string | The value that indicates whether the export policy is enabled or not. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`networkRuleBypassOptions`](#parameter-networkrulebypassoptions) | string | Whether to allow trusted Azure services to access a network restricted registry. |
| [`networkRuleSetDefaultAction`](#parameter-networkrulesetdefaultaction) | string | The default action of allow or deny when no other rules match. |
| [`networkRuleSetIpRules`](#parameter-networkrulesetiprules) | array | The IP ACL rules. Note, requires the 'acrSku' to be 'Premium'. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'acrSku' to be 'Premium'. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'. |
| [`quarantinePolicyStatus`](#parameter-quarantinepolicystatus) | string | The value that indicates whether the quarantine policy is enabled or not. |
| [`replications`](#parameter-replications) | array | All replications to create. |
| [`retentionPolicyDays`](#parameter-retentionpolicydays) | int | The number of days to retain an untagged manifest after which it gets purged. |
| [`retentionPolicyStatus`](#parameter-retentionpolicystatus) | string | The value that indicates whether the retention policy is enabled or not. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`softDeletePolicyDays`](#parameter-softdeletepolicydays) | int | The number of days after which a soft-deleted item is permanently deleted. |
| [`softDeletePolicyStatus`](#parameter-softdeletepolicystatus) | string | Soft Delete policy status. Default is disabled. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`trustPolicyStatus`](#parameter-trustpolicystatus) | string | The value that indicates whether the trust policy is enabled or not. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`webhooks`](#parameter-webhooks) | array | All webhooks to create. |
| [`zoneRedundancy`](#parameter-zoneredundancy) | string | Whether or not zone redundancy is enabled for this container registry. |

### Parameter: `acrAdminUserEnabled`

Enable admin user that have push / pull permission to the registry.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `acrSku`

Tier of your Azure container registry.
- Required: No
- Type: string
- Default: `'Basic'`
- Allowed: `[Basic, Premium, Standard]`

### Parameter: `anonymousPullEnabled`

Enables registry-wide pull from unauthenticated clients. It's in preview and available in the Standard and Premium service tiers.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `azureADAuthenticationAsArmPolicyStatus`

The value that indicates whether the policy for using ARM audience token for a container registr is enabled or not. Default is enabled.
- Required: No
- Type: string
- Default: `'enabled'`
- Allowed: `[disabled, enabled]`

### Parameter: `cacheRules`

Array of Cache Rules. Note: This is a preview feature ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache#cache-for-acr-preview)).
- Required: No
- Type: array
- Default: `[]`

### Parameter: `cMKKeyName`

The name of the customer managed key to use for encryption. Note, CMK requires the 'acrSku' to be 'Premium'.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Note, CMK requires the 'acrSku' to be 'Premium'.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUserAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Note, CMK requires the 'acrSku' to be 'Premium'. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `dataEndpointEnabled`

Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. Note, requires the 'acrSku' to be 'Premium'.
- Required: No
- Type: bool
- Default: `False`

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
- Allowed: `['', allLogs, ContainerRegistryLoginEvents, ContainerRegistryRepositoryEvents]`

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

### Parameter: `exportPolicyStatus`

The value that indicates whether the export policy is enabled or not.
- Required: No
- Type: string
- Default: `'disabled'`
- Allowed: `[disabled, enabled]`

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

Name of your Azure container registry.
- Required: Yes
- Type: string

### Parameter: `networkRuleBypassOptions`

Whether to allow trusted Azure services to access a network restricted registry.
- Required: No
- Type: string
- Default: `'AzureServices'`
- Allowed: `[AzureServices, None]`

### Parameter: `networkRuleSetDefaultAction`

The default action of allow or deny when no other rules match.
- Required: No
- Type: string
- Default: `'Deny'`
- Allowed: `[Allow, Deny]`

### Parameter: `networkRuleSetIpRules`

The IP ACL rules. Note, requires the 'acrSku' to be 'Premium'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'acrSku' to be 'Premium'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `quarantinePolicyStatus`

The value that indicates whether the quarantine policy is enabled or not.
- Required: No
- Type: string
- Default: `'disabled'`
- Allowed: `[disabled, enabled]`

### Parameter: `replications`

All replications to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `retentionPolicyDays`

The number of days to retain an untagged manifest after which it gets purged.
- Required: No
- Type: int
- Default: `15`

### Parameter: `retentionPolicyStatus`

The value that indicates whether the retention policy is enabled or not.
- Required: No
- Type: string
- Default: `'enabled'`
- Allowed: `[disabled, enabled]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `softDeletePolicyDays`

The number of days after which a soft-deleted item is permanently deleted.
- Required: No
- Type: int
- Default: `7`

### Parameter: `softDeletePolicyStatus`

Soft Delete policy status. Default is disabled.
- Required: No
- Type: string
- Default: `'disabled'`
- Allowed: `[disabled, enabled]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `trustPolicyStatus`

The value that indicates whether the trust policy is enabled or not.
- Required: No
- Type: string
- Default: `'disabled'`
- Allowed: `[disabled, enabled]`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `webhooks`

All webhooks to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `zoneRedundancy`

Whether or not zone redundancy is enabled for this container registry.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `loginServer` | string | The reference to the Azure container registry. |
| `name` | string | The Name of the Azure container registry. |
| `resourceGroupName` | string | The name of the Azure container registry. |
| `resourceId` | string | The resource ID of the Azure container registry. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_
