# Role Definitions `[Microsoft.Authorization/roleDefinitions]`

This module deploys custom RBAC Role Definitions across the management group, subscription or resource group scope.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | 2018-01-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Optional. List of allowed actions. |
| `assignableScopes` | array | `[]` |  | Optional. Role definition assignable scopes. If not provided, will use the current scope provided. |
| `dataActions` | array | `[]` |  | Optional. List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes |
| `description` | string |  |  | Optional. Description of the custom RBAC role to be created. |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| `notActions` | array | `[]` |  | Optional. List of denied actions. |
| `notDataActions` | array | `[]` |  | Optional. List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes |
| `resourceGroupName` | string |  |  | Optional. The name of the Resource Group where the Role Definition and Target Scope will be applied to. |
| `roleName` | string |  |  | Required. Name of the custom RBAC role to be created. |
| `subscriptionId` | string |  |  | Optional. The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level. |

### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.

```json
"managementGroupId": {
    "value": "contoso-group"
}
```

> `managementGroupId` is an optional parameter. If not provided, the deployment will use the management group defined in the current deployment scope (i.e. `managementGroup().name`).

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
}
```

### Parameter Usage: `resourceGroupName`

To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
    "value": "target-resourceGroup"
}
```

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
module roledefinition 'yourpath/arm/Microsoft.Authorization.roleDefinitions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition |
| `resourceId` | string | The resource ID of the Role Definition |
| `roleDefinitionScope` | string | The scope this Role Definition applies to |

## Considerations

This module can be deployed both at subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter and an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the subscription level, provide an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the management group level, provide an existing management group ID in the `managementGroupId` parameter.

## Template references

- [Roledefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2018-01-01-preview/roleDefinitions)
