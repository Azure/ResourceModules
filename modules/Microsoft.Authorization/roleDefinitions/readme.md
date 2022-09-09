# Role Definitions `[Microsoft.Authorization/roleDefinitions]`

This module deploys custom RBAC Role Definitions across the management group, subscription or resource group scope.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Module Usage Guidance](#Module-Usage-Guidance)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | [2018-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2018-01-01-preview/roleDefinitions) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `roleName` | string | Name of the custom RBAC role to be created. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `actions` | array | `[]` | List of allowed actions. |
| `assignableScopes` | array | `[]` | Role definition assignable scopes. If not provided, will use the current scope provided. |
| `dataActions` | array | `[]` | List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes. |
| `description` | string | `''` | Description of the custom RBAC role to be created. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `managementGroupId` | string | `[managementGroup().name]` | The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| `notActions` | array | `[]` | List of denied actions. |
| `notDataActions` | array | `[]` | List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes. |
| `resourceGroupName` | string | `''` | The name of the Resource Group where the Role Definition and Target Scope will be applied to. |
| `subscriptionId` | string | `''` | The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level. |


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

## Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `deploy.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](deploy.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/deploy.bicep'](./subscription/deploy.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/deploy.bicep'](./subscription/deploy.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module roledefinition 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.roledefinitions.subscription:version' = {}
```
**Local Path Reference**
```bicep
module roledefinition 'yourpath/modules/Microsoft.Authorization.roleDefinitions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition. |
| `resourceId` | string | The resource ID of the Role Definition. |
| `scope` | string | The scope this Role Definition applies to. |

## Considerations

This module can be deployed both at subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter and an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the subscription level, provide an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the management group level, provide an existing management group ID in the `managementGroupId` parameter.

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Mg Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinitions './Microsoft.Authorization/roleDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleDefinitions'
  params: {
    // Required parameters
    roleName: '<<namePrefix>>-az-testRole-mg-min'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
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
      "value": "<<namePrefix>>-az-testRole-mg-min"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/read"
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 2: Mg</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinitions './Microsoft.Authorization/roleDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleDefinitions'
  params: {
    // Required parameters
    roleName: '<<namePrefix>>-az-testRole-mg'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      '/providers/Microsoft.Management/managementGroups/<<managementGroupId>>'
    ]
    dataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/*/read'
    ]
    description: 'Test Custom Role Definition Standard (management group scope)'
    managementGroupId: '<<managementGroupId>>'
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
      "value": "<<namePrefix>>-az-testRole-mg"
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
        "/providers/Microsoft.Management/managementGroups/<<managementGroupId>>"
      ]
    },
    "dataActions": {
      "value": [
        "Microsoft.Storage/storageAccounts/blobServices/*/read"
      ]
    },
    "description": {
      "value": "Test Custom Role Definition Standard (management group scope)"
    },
    "managementGroupId": {
      "value": "<<managementGroupId>>"
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

<h3>Example 3: Rg Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinitions './Microsoft.Authorization/roleDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleDefinitions'
  params: {
    // Required parameters
    roleName: '<<namePrefix>>-az-testRole-rg-min'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
    resourceGroupName: '<<resourceGroupName>>'
    subscriptionId: '<<subscriptionId>>'
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
      "value": "<<namePrefix>>-az-testRole-rg-min"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/read"
      ]
    },
    "resourceGroupName": {
      "value": "<<resourceGroupName>>"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>
<p>

<h3>Example 4: Rg</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinitions './Microsoft.Authorization/roleDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleDefinitions'
  params: {
    // Required parameters
    roleName: '<<namePrefix>>-az-testRole-rg'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/<<resourceGroupName>>'
    ]
    dataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/*/read'
    ]
    description: 'Test Custom Role Definition Standard (resource group scope)'
    notActions: [
      'Microsoft.Compute/images/delete'
      'Microsoft.Compute/images/write'
      'Microsoft.Network/virtualNetworks/subnets/join/action'
    ]
    notDataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
    ]
    resourceGroupName: '<<resourceGroupName>>'
    subscriptionId: '<<subscriptionId>>'
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
      "value": "<<namePrefix>>-az-testRole-rg"
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
        "/subscriptions/<<subscriptionId>>/resourceGroups/<<resourceGroupName>>"
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
    },
    "resourceGroupName": {
      "value": "<<resourceGroupName>>"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Sub Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinitions './Microsoft.Authorization/roleDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleDefinitions'
  params: {
    // Required parameters
    roleName: '<<namePrefix>>-az-testRole-sub-min'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
    subscriptionId: '<<subscriptionId>>'
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
      "value": "<<namePrefix>>-az-testRole-sub-min"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/read"
      ]
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>
<p>

<h3>Example 6: Sub</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinitions './Microsoft.Authorization/roleDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleDefinitions'
  params: {
    // Required parameters
    roleName: '<<namePrefix>>-az-testRole-sub'
    // Non-required parameters
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      '/subscriptions/<<subscriptionId>>'
    ]
    dataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/*/read'
    ]
    description: 'Test Custom Role Definition Standard (subscription scope)'
    notActions: [
      'Microsoft.Compute/images/delete'
      'Microsoft.Compute/images/write'
      'Microsoft.Network/virtualNetworks/subnets/join/action'
    ]
    notDataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
    ]
    subscriptionId: '<<subscriptionId>>'
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
      "value": "<<namePrefix>>-az-testRole-sub"
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
        "/subscriptions/<<subscriptionId>>"
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
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>
<p>
