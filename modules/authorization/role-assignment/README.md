# Role Assignments (All scopes) `[Microsoft.Authorization/roleAssignments]`

This module deploys a Role Assignment at a Management Group, Subscription or Resource Group scope.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/authorization.role-assignment:1.0.0`.

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
module roleAssignment 'br:bicep/modules/authorization.role-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-aramgcom'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Backup Reader'
    // Non-required parameters
    description: 'Role Assignment (management group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managementGroupId: '<managementGroupId>'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Backup Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (management group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managementGroupId": {
      "value": "<managementGroupId>"
    },
    "principalType": {
      "value": "ServicePrincipal"
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
module roleAssignment 'br:bicep/modules/authorization.role-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-aramgmin'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Storage Queue Data Reader"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "principalType": {
      "value": "ServicePrincipal"
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
module roleAssignment 'br:bicep/modules/authorization.role-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-arargcom'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Backup Reader'
    // Non-required parameters
    description: 'Role Assignment (resource group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    principalType: 'ServicePrincipal'
    resourceGroupName: '<resourceGroupName>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Backup Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (resource group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
module roleAssignment 'br:bicep/modules/authorization.role-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-arargmin'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    principalType: 'ServicePrincipal'
    resourceGroupName: '<resourceGroupName>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Storage Queue Data Reader"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
module roleAssignment 'br:bicep/modules/authorization.role-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-arasubcom'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Backup Reader'
    // Non-required parameters
    description: 'Role Assignment (subscription scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Backup Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (subscription scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
module roleAssignment 'br:bicep/modules/authorization.role-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-arasubmin'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Storage Queue Data Reader"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "principalType": {
      "value": "ServicePrincipal"
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
| [`principalId`](#parameter-principalid) | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | string | You can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-condition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. |
| [`conditionVersion`](#parameter-conditionversion) | string | Version of the condition. Currently accepted value is "2.0". |
| [`delegatedManagedIdentityResourceId`](#parameter-delegatedmanagedidentityresourceid) | string | ID of the delegated managed identity resource. |
| [`description`](#parameter-description) | string | The description of the role assignment. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the assigned principal ID. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group. |
| [`subscriptionId`](#parameter-subscriptionid) | string | Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |

### Parameter: `condition`

The conditions on the role assignment. This limits the resources it can be assigned to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `conditionVersion`

Version of the condition. Currently accepted value is "2.0".
- Required: No
- Type: string
- Default: `'2.0'`
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `delegatedManagedIdentityResourceId`

ID of the delegated managed identity resource.
- Required: No
- Type: string
- Default: `''`

### Parameter: `description`

The description of the role assignment.
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

Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `principalId`

The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).
- Required: Yes
- Type: string

### Parameter: `principalType`

The principal type of the assigned principal ID.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `resourceGroupName`

Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleDefinitionIdOrName`

You can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: Yes
- Type: string

### Parameter: `subscriptionId`

Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment. |
| `resourceId` | string | The resource ID of the Role Assignment. |
| `scope` | string | The scope this Role Assignment applies to. |

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
module roleassignment 'br:bicepregistry.azurecr.io/bicep/modules/authorization.role-assignment.subscription:version' = {}
```
**Local Path Reference**
```bicep
module roleassignment 'yourpath/module/authorization/role-assignment/subscription/main.bicep' = {}
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
