# Azure Databricks Workspaces `[Microsoft.Databricks/workspaces]`

This module deploys an Azure Databricks Workspace.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)
- [Notes](#Notes)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Databricks/workspaces` | [2023-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2023-02-01/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Azure Databricks workspace to create. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKManagedDisksKeyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| `cMKManagedServicesKeyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `amlWorkspaceResourceId` | string | `''` |  | The resource ID of a Azure Machine Learning workspace to link with Databricks workspace. |
| `cMKManagedDisksKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKManagedDisksKeyRotationToLatestKeyVersionEnabled` | bool | `True` |  | Enable Auto Rotation of Key. |
| `cMKManagedDisksKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `cMKManagedServicesKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKManagedServicesKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `customPrivateSubnetName` | string | `''` |  | The name of the Private Subnet within the Virtual Network. |
| `customPublicSubnetName` | string | `''` |  | The name of a Public Subnet within the Virtual Network. |
| `customVirtualNetworkResourceId` | string | `''` |  | The resource ID of a Virtual Network where this Databricks Cluster should be created. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', accounts, allLogs, clusters, dbfs, instancePools, jobs, notebook, secrets, sqlPermissions, ssh, workspace]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disablePublicIp` | bool | `False` |  | Disable Public IP. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `loadBalancerBackendPoolName` | string | `''` |  | Name of the outbound Load Balancer Backend Pool for Secure Cluster Connectivity (No Public IP). |
| `loadBalancerResourceId` | string | `''` |  | Resource URI of Outbound Load balancer for Secure Cluster Connectivity (No Public IP) workspace. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedResourceGroupResourceId` | string | `''` |  | The managed resource group ID. It is created by the module as per the to-be resource ID you provide. |
| `natGatewayName` | string | `''` |  | Name of the NAT gateway for Secure Cluster Connectivity (No Public IP) workspace subnets. |
| `prepareEncryption` | bool | `False` |  | Prepare the workspace for encryption. Enables the Managed Identity for managed storage account. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicIpName` | string | `''` |  | Name of the Public IP for No Public IP workspace with managed vNet. |
| `publicNetworkAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | 	The network access type for accessing workspace. Set value to disabled to access workspace only via private link. |
| `requiredNsgRules` | string | `'AllRules'` | `[AllRules, NoAzureDatabricksRules]` | Gets or sets a value indicating whether data plane (clusters) to control plane communication happen over private endpoint. |
| `requireInfrastructureEncryption` | bool | `False` |  | A boolean indicating whether or not the DBFS root file system will be enabled with secondary layer of encryption with platform managed keys for data at rest. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `skuName` | string | `'premium'` | `[premium, standard, trial]` | The pricing tier of workspace. |
| `storageAccountName` | string | `''` |  | Default DBFS storage account name. |
| `storageAccountSkuName` | string | `'Standard_GRS'` |  | Storage account SKU name. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vnetAddressPrefix` | string | `'10.139'` |  | Address prefix for Managed virtual network. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed databricks workspace. |
| `resourceGroupName` | string | The resource group of the deployed databricks workspace. |
| `resourceId` | string | The resource ID of the deployed databricks workspace. |

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
module workspace './databricks/workspace/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dwcom'
  params: {
    // Required parameters
    name: 'dwcom001'
    // Non-required parameters
    amlWorkspaceResourceId: '<amlWorkspaceResourceId>'
    cMKManagedDisksKeyName: '<cMKManagedDisksKeyName>'
    cMKManagedDisksKeyRotationToLatestKeyVersionEnabled: true
    cMKManagedDisksKeyVaultResourceId: '<cMKManagedDisksKeyVaultResourceId>'
    cMKManagedServicesKeyName: '<cMKManagedServicesKeyName>'
    cMKManagedServicesKeyVaultResourceId: '<cMKManagedServicesKeyVaultResourceId>'
    customPrivateSubnetName: '<customPrivateSubnetName>'
    customPublicSubnetName: '<customPublicSubnetName>'
    customVirtualNetworkResourceId: '<customVirtualNetworkResourceId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogCategoriesToEnable: [
      'jobs'
      'notebook'
    ]
    diagnosticSettingsName: 'diagdwcom001'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disablePublicIp: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    loadBalancerBackendPoolName: '<loadBalancerBackendPoolName>'
    loadBalancerResourceId: '<loadBalancerResourceId>'
    location: '<location>'
    lock: 'CanNotDelete'
    managedResourceGroupResourceId: '<managedResourceGroupResourceId>'
    natGatewayName: 'nat-gateway'
    prepareEncryption: true
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'databricks_ui_api'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicIpName: 'nat-gw-public-ip'
    publicNetworkAccess: 'Disabled'
    requiredNsgRules: 'NoAzureDatabricksRules'
    requireInfrastructureEncryption: true
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    skuName: 'premium'
    storageAccountName: 'sadwcom001'
    storageAccountSkuName: 'Standard_ZRS'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vnetAddressPrefix: '10.100'
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
      "value": "dwcom001"
    },
    // Non-required parameters
    "amlWorkspaceResourceId": {
      "value": "<amlWorkspaceResourceId>"
    },
    "cMKManagedDisksKeyName": {
      "value": "<cMKManagedDisksKeyName>"
    },
    "cMKManagedDisksKeyRotationToLatestKeyVersionEnabled": {
      "value": true
    },
    "cMKManagedDisksKeyVaultResourceId": {
      "value": "<cMKManagedDisksKeyVaultResourceId>"
    },
    "cMKManagedServicesKeyName": {
      "value": "<cMKManagedServicesKeyName>"
    },
    "cMKManagedServicesKeyVaultResourceId": {
      "value": "<cMKManagedServicesKeyVaultResourceId>"
    },
    "customPrivateSubnetName": {
      "value": "<customPrivateSubnetName>"
    },
    "customPublicSubnetName": {
      "value": "<customPublicSubnetName>"
    },
    "customVirtualNetworkResourceId": {
      "value": "<customVirtualNetworkResourceId>"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogCategoriesToEnable": {
      "value": [
        "jobs",
        "notebook"
      ]
    },
    "diagnosticSettingsName": {
      "value": "diagdwcom001"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "disablePublicIp": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "loadBalancerBackendPoolName": {
      "value": "<loadBalancerBackendPoolName>"
    },
    "loadBalancerResourceId": {
      "value": "<loadBalancerResourceId>"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "managedResourceGroupResourceId": {
      "value": "<managedResourceGroupResourceId>"
    },
    "natGatewayName": {
      "value": "nat-gateway"
    },
    "prepareEncryption": {
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
          "service": "databricks_ui_api",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicIpName": {
      "value": "nat-gw-public-ip"
    },
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "requiredNsgRules": {
      "value": "NoAzureDatabricksRules"
    },
    "requireInfrastructureEncryption": {
      "value": true
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
    "skuName": {
      "value": "premium"
    },
    "storageAccountName": {
      "value": "sadwcom001"
    },
    "storageAccountSkuName": {
      "value": "Standard_ZRS"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vnetAddressPrefix": {
      "value": "10.100"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './databricks/workspace/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dwmin'
  params: {
    // Required parameters
    name: 'dwmin001'
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
      "value": "dwmin001"
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


## Notes

### Parameter Usage: `customPublicSubnetName` and `customPrivateSubnetName`

- Require Network Security Groups attached to the subnets (Note: Rule don't have to be set, they are set through the deployment)

- The two subnets also need the delegation to service `Microsoft.Databricks/workspaces`

### Parameter Usage: `parameters`

- Include only those elements (e.g. amlWorkspaceId) as object if specified, otherwise remove it.

<details>

<summary>Parameter JSON format</summary>

```json
"parameters": {
    "value": {
        "amlWorkspaceId": {
            "value": "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.MachineLearningServices/workspaces/xxx"
        },
        "customVirtualNetworkId": {
            "value": "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx"
        },
        "customPublicSubnetName": {
            "value": "xxx"
        },
        "customPrivateSubnetName": {
            "value": "xxx"
        },
        "enableNoPublicIp": {
            "value": true
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
parameters: {
    amlWorkspaceId: {
        value: '/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.MachineLearningServices/workspaces/xxx'
    }
    customVirtualNetworkId: {
        value: '/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx'
    }
    customPublicSubnetName: {
        value: 'xxx'
    }
    customPrivateSubnetName: {
        value: 'xxx'
    }
    enableNoPublicIp: {
        value: true
    }
}
```

</details>
<p>
