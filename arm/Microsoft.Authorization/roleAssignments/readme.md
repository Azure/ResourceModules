# Role Assignments `[Microsoft.Authorization/roleAssignments]`

This module deploys Role Assignments across the management group, subscription or resource group scope.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `condition` | string |  |  | Optional. The conditions on the role assignment. This limits the resources it can be assigned to |
| `conditionVersion` | string | `2.0` | `[2.0]` | Optional. Version of the condition. Currently accepted value is "2.0" |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution Id (GUID). This GUID must be previously registered. Use when scope target is resource group. |
| `delegatedManagedIdentityResourceId` | string |  |  | Optional. Id of the delegated managed identity resource |
| `description` | string |  |  | Optional. Description of role assignment |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string |  |  | Optional. Group Id of the Management Group to assign the RBAC role to. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided RBAC role to the management group. |
| `principalId` | string |  |  | Required. The Principal or Object Id of the Security Principal (User, Group, Service Principal, Managed Identity) |
| `principalType` | string |  | `[ServicePrincipal, Group, User, ForeignGroup, Device, ]` | Optional. The principal type of the assigned principal Id. |
| `resourceGroupName` | string |  |  | Optional. Name of the Resource Group to assign the RBAC role to. If no Resource Group name is provided, and Subscription Id is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |
| `roleDefinitionIdOrName` | string |  |  | Required. You can provide either the display name of the role definition, or its fully qualified Id in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `subscriptionId` | string |  |  | Optional. Subscription Id of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |

### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.

```json
"managementGroupId": {
    "value": "contoso-group"
}
```

> The name of the Management Group in the deployment does not have to match the value of the `managementGroupId` in the input parameters. For example, you can trigger the initial deployment at the root management group, but the parameter file has another management group mentioned, hence the real target is the one in the parameter file.

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

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module with other modules with lower scopes? This will not work as the [root](deploy.bicep) is defined at a higher scope (i.e. management group), hence the module can no longer be used. That is simply because you cannot have your own bicep file that has a target of subscription, and this root module is at a higher scope than that. This is the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/deploy.bicep'](./subscription/deploy.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module roleassignment 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.roleassignments.subscription:version' = {}
```
**Local Path Reference**
```bicep
module roleassignment 'yourpath/arm/Microsoft.Authorization.roleAssignments/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment |
| `resourceId` | string | The resource Id of the Role Assignment |
| `scope` | string | The scope this Role Assignment applies to |

## Considerations

This module can be deployed at the management group, subscription or resource group level

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
