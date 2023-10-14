# Azure Databricks Workspaces `[Microsoft.Databricks/workspaces]`

This module deploys an Azure Databricks Workspace.

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
| `Microsoft.Databricks/workspaces` | [2023-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2023-02-01/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/databricks.workspace:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/databricks.workspace:1.0.0' = {
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

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/databricks.workspace:1.0.0' = {
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Azure Databricks workspace to create. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKManagedDisksKeyVaultResourceId`](#parameter-cmkmanageddiskskeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| [`cMKManagedServicesKeyVaultResourceId`](#parameter-cmkmanagedserviceskeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`amlWorkspaceResourceId`](#parameter-amlworkspaceresourceid) | string | The resource ID of a Azure Machine Learning workspace to link with Databricks workspace. |
| [`cMKManagedDisksKeyName`](#parameter-cmkmanageddiskskeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKManagedDisksKeyRotationToLatestKeyVersionEnabled`](#parameter-cmkmanageddiskskeyrotationtolatestkeyversionenabled) | bool | Enable Auto Rotation of Key. |
| [`cMKManagedDisksKeyVersion`](#parameter-cmkmanageddiskskeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`cMKManagedServicesKeyName`](#parameter-cmkmanagedserviceskeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKManagedServicesKeyVersion`](#parameter-cmkmanagedserviceskeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`customPrivateSubnetName`](#parameter-customprivatesubnetname) | string | The name of the Private Subnet within the Virtual Network. |
| [`customPublicSubnetName`](#parameter-custompublicsubnetname) | string | The name of a Public Subnet within the Virtual Network. |
| [`customVirtualNetworkResourceId`](#parameter-customvirtualnetworkresourceid) | string | The resource ID of a Virtual Network where this Databricks Cluster should be created. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`disablePublicIp`](#parameter-disablepublicip) | bool | Disable Public IP. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`loadBalancerBackendPoolName`](#parameter-loadbalancerbackendpoolname) | string | Name of the outbound Load Balancer Backend Pool for Secure Cluster Connectivity (No Public IP). |
| [`loadBalancerResourceId`](#parameter-loadbalancerresourceid) | string | Resource URI of Outbound Load balancer for Secure Cluster Connectivity (No Public IP) workspace. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`managedResourceGroupResourceId`](#parameter-managedresourcegroupresourceid) | string | The managed resource group ID. It is created by the module as per the to-be resource ID you provide. |
| [`natGatewayName`](#parameter-natgatewayname) | string | Name of the NAT gateway for Secure Cluster Connectivity (No Public IP) workspace subnets. |
| [`prepareEncryption`](#parameter-prepareencryption) | bool | Prepare the workspace for encryption. Enables the Managed Identity for managed storage account. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicIpName`](#parameter-publicipname) | string | Name of the Public IP for No Public IP workspace with managed vNet. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | 	The network access type for accessing workspace. Set value to disabled to access workspace only via private link. |
| [`requiredNsgRules`](#parameter-requirednsgrules) | string | Gets or sets a value indicating whether data plane (clusters) to control plane communication happen over private endpoint. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | bool | A boolean indicating whether or not the DBFS root file system will be enabled with secondary layer of encryption with platform managed keys for data at rest. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`skuName`](#parameter-skuname) | string | The pricing tier of workspace. |
| [`storageAccountName`](#parameter-storageaccountname) | string | Default DBFS storage account name. |
| [`storageAccountSkuName`](#parameter-storageaccountskuname) | string | Storage account SKU name. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vnetAddressPrefix`](#parameter-vnetaddressprefix) | string | Address prefix for Managed virtual network. |

### Parameter: `amlWorkspaceResourceId`

The resource ID of a Azure Machine Learning workspace to link with Databricks workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKManagedDisksKeyName`

The name of the customer managed key to use for encryption.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKManagedDisksKeyRotationToLatestKeyVersionEnabled`

Enable Auto Rotation of Key.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `cMKManagedDisksKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKManagedDisksKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKManagedServicesKeyName`

The name of the customer managed key to use for encryption.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKManagedServicesKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKManagedServicesKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customPrivateSubnetName`

The name of the Private Subnet within the Virtual Network.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customPublicSubnetName`

The name of a Public Subnet within the Virtual Network.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customVirtualNetworkResourceId`

The resource ID of a Virtual Network where this Databricks Cluster should be created.
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
- Allowed: `['', accounts, allLogs, clusters, dbfs, instancePools, jobs, notebook, secrets, sqlPermissions, ssh, workspace]`

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

### Parameter: `disablePublicIp`

Disable Public IP.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `loadBalancerBackendPoolName`

Name of the outbound Load Balancer Backend Pool for Secure Cluster Connectivity (No Public IP).
- Required: No
- Type: string
- Default: `''`

### Parameter: `loadBalancerResourceId`

Resource URI of Outbound Load balancer for Secure Cluster Connectivity (No Public IP) workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location for all Resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `managedResourceGroupResourceId`

The managed resource group ID. It is created by the module as per the to-be resource ID you provide.
- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the Azure Databricks workspace to create.
- Required: Yes
- Type: string

### Parameter: `natGatewayName`

Name of the NAT gateway for Secure Cluster Connectivity (No Public IP) workspace subnets.
- Required: No
- Type: string
- Default: `''`

### Parameter: `prepareEncryption`

Prepare the workspace for encryption. Enables the Managed Identity for managed storage account.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicIpName`

Name of the Public IP for No Public IP workspace with managed vNet.
- Required: No
- Type: string
- Default: `''`

### Parameter: `publicNetworkAccess`

	The network access type for accessing workspace. Set value to disabled to access workspace only via private link.
- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `requiredNsgRules`

Gets or sets a value indicating whether data plane (clusters) to control plane communication happen over private endpoint.
- Required: No
- Type: string
- Default: `'AllRules'`
- Allowed: `[AllRules, NoAzureDatabricksRules]`

### Parameter: `requireInfrastructureEncryption`

A boolean indicating whether or not the DBFS root file system will be enabled with secondary layer of encryption with platform managed keys for data at rest.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `skuName`

The pricing tier of workspace.
- Required: No
- Type: string
- Default: `'premium'`
- Allowed: `[premium, standard, trial]`

### Parameter: `storageAccountName`

Default DBFS storage account name.
- Required: No
- Type: string
- Default: `''`

### Parameter: `storageAccountSkuName`

Storage account SKU name.
- Required: No
- Type: string
- Default: `'Standard_GRS'`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `vnetAddressPrefix`

Address prefix for Managed virtual network.
- Required: No
- Type: string
- Default: `'10.139'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed databricks workspace. |
| `resourceGroupName` | string | The resource group of the deployed databricks workspace. |
| `resourceId` | string | The resource ID of the deployed databricks workspace. |

## Cross-referenced modules

_None_

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
