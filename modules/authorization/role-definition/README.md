# Role Definitions (All scopes) `[Microsoft.Authorization/roleDefinitions]`

This module deploys a Role Definition at a Management Group, Subscription or Resource Group scope.

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
| `Microsoft.Authorization/roleDefinitions` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleDefinitions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/authorization.role-definition:1.0.0`.

- [Mg.Common](#example-1-mgcommon)
- [Mg.Min](#example-2-mgmin)
- [Rg.Common](#example-3-rgcommon)
- [Rg.Min](#example-4-rgmin)
- [Sub.Common](#example-5-subcommon)
- [Sub.Min](#example-6-submin)

### Example 1: _Mg.Common_

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br:bicep/modules/authorization.role-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-ardmgcom'
  params: {
    // Required parameters
    roleName: 'testRole-ardmgcom'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      '<id>'
    ]
    description: 'Test Custom Role Definition Standard (management group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    notActions: [
      'Microsoft.Compute/images/delete'
      'Microsoft.Compute/images/write'
      'Microsoft.Network/virtualNetworks/subnets/join/action'
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
    "roleName": {
      "value": "testRole-ardmgcom"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/*",
        "Microsoft.Network/virtualNetworks/read"
      ]
    },
    "assignableScopes": {
      "value": [
        "<id>"
      ]
    },
    "description": {
      "value": "Test Custom Role Definition Standard (management group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "notActions": {
      "value": [
        "Microsoft.Compute/images/delete",
        "Microsoft.Compute/images/write",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
```

</details>
<p>

### Example 2: _Mg.Min_

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br:bicep/modules/authorization.role-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-ardmgmin'
  params: {
    // Required parameters
    roleName: 'testRole-ardmgmin'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
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
    "roleName": {
      "value": "testRole-ardmgmin"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/read"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 3: _Rg.Common_

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br:bicep/modules/authorization.role-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-ardrgcom'
  params: {
    // Required parameters
    roleName: 'testRole-ardrgcom'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      '<id>'
    ]
    dataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/*/read'
    ]
    description: 'Test Custom Role Definition Standard (resource group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    notActions: [
      'Microsoft.Compute/images/delete'
      'Microsoft.Compute/images/write'
      'Microsoft.Network/virtualNetworks/subnets/join/action'
    ]
    notDataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
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
    "roleName": {
      "value": "testRole-ardrgcom"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/*",
        "Microsoft.Network/virtualNetworks/read"
      ]
    },
    "assignableScopes": {
      "value": [
        "<id>"
      ]
    },
    "dataActions": {
      "value": [
        "Microsoft.Storage/storageAccounts/blobServices/*/read"
      ]
    },
    "description": {
      "value": "Test Custom Role Definition Standard (resource group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "notActions": {
      "value": [
        "Microsoft.Compute/images/delete",
        "Microsoft.Compute/images/write",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    },
    "notDataActions": {
      "value": [
        "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
      ]
    }
  }
}
```

</details>
<p>

### Example 4: _Rg.Min_

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br:bicep/modules/authorization.role-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-ardrgmin'
  params: {
    // Required parameters
    roleName: 'testRole-ardrgmin'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
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
    "roleName": {
      "value": "testRole-ardrgmin"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/read"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 5: _Sub.Common_

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br:bicep/modules/authorization.role-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-ardsubcom'
  params: {
    // Required parameters
    roleName: 'testRole-ardsubcom'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      '<id>'
    ]
    dataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/*/read'
    ]
    description: 'Test Custom Role Definition Standard (subscription scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    notActions: [
      'Microsoft.Compute/images/delete'
      'Microsoft.Compute/images/write'
      'Microsoft.Network/virtualNetworks/subnets/join/action'
    ]
    notDataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
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
    "roleName": {
      "value": "testRole-ardsubcom"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/*",
        "Microsoft.Network/virtualNetworks/read"
      ]
    },
    "assignableScopes": {
      "value": [
        "<id>"
      ]
    },
    "dataActions": {
      "value": [
        "Microsoft.Storage/storageAccounts/blobServices/*/read"
      ]
    },
    "description": {
      "value": "Test Custom Role Definition Standard (subscription scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "notActions": {
      "value": [
        "Microsoft.Compute/images/delete",
        "Microsoft.Compute/images/write",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    },
    "notDataActions": {
      "value": [
        "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
      ]
    }
  }
}
```

</details>
<p>

### Example 6: _Sub.Min_

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br:bicep/modules/authorization.role-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-ardsubmin'
  params: {
    // Required parameters
    roleName: 'testRole-ardsubmin'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    subscriptionId: '<subscriptionId>'
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
    "roleName": {
      "value": "testRole-ardsubmin"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/read"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
| [`roleName`](#parameter-rolename) | string | Name of the custom RBAC role to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | List of allowed actions. |
| [`assignableScopes`](#parameter-assignablescopes) | array | Role definition assignable scopes. If not provided, will use the current scope provided. |
| [`dataActions`](#parameter-dataactions) | array | List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes. |
| [`description`](#parameter-description) | string | Description of the custom RBAC role to be created. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| [`notActions`](#parameter-notactions) | array | List of denied actions. |
| [`notDataActions`](#parameter-notdataactions) | array | List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The name of the Resource Group where the Role Definition and Target Scope will be applied to. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level. |

### Parameter: `actions`

List of allowed actions.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `assignableScopes`

Role definition assignable scopes. If not provided, will use the current scope provided.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `dataActions`

List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `description`

Description of the custom RBAC role to be created.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `notActions`

List of denied actions.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `notDataActions`

List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `resourceGroupName`

The name of the Resource Group where the Role Definition and Target Scope will be applied to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleName`

Name of the custom RBAC role to be created.
- Required: Yes
- Type: string

### Parameter: `subscriptionId`

The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition. |
| `resourceId` | string | The resource ID of the Role Definition. |
| `scope` | string | The scope this Role Definition applies to. |

## Cross-referenced modules

_None_

## Notes

### Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `main.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](main.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/main.bicep'](./subscription/main.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/main.bicep'](./subscription/main.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module roledefinition 'br:bicepregistry.azurecr.io/bicep/modules/authorization.role-definition.subscription:version' = {}
```
**Local Path Reference**
```bicep
module roledefinition 'yourpath/module/authorization/role-definition/subscription/main.bicep' = {}
```

### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.

<details>

<summary>Parameter JSON format</summary>

```json
"managementGroupId": {
    "value": "contoso-group"
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
managementGroupId: 'contoso-group'
```

</details>
<p>

> `managementGroupId` is an optional parameter. If not provided, the deployment will use the management group defined in the current deployment scope (i.e. `managementGroup().name`).

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:


<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
```

</details>
<p>

### Parameter Usage: `resourceGroupName`

To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
    "value": "target-resourceGroup"
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
resourceGroupName: 'target-resourceGroup'
```

</details>
<p>

> The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).
