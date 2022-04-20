# Policy Assignments `[Microsoft.Authorization/policyAssignments]`

With this module you can perform policy assignments across the management group, subscription or resource group scope.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Module Usage Guidance](#Module-Usage-Guidance)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | 2021-06-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes. |
| `policyDefinitionId` | string | Specifies the ID of the policy definition or policy set definition being assigned. |
| `roleDefinitionIds` | array | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | This message will be part of response in case of policy violation. |
| `displayName` | string | `''` |  | The display name of the policy assignment. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enforcementMode` | string | `'Default'` | `[Default, DoNotEnforce]` | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce |
| `identity` | string | `'SystemAssigned'` | `[SystemAssigned, None]` | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[deployment().location]` |  | Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `nonComplianceMessage` | string | `''` |  | The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | The policy excluded scopes |
| `parameters` | object | `{object}` |  | Parameters for the policy assignment if needed. |
| `resourceGroupName` | string | `''` |  | The Target Scope for the Policy. The name of the resource group for the policy assignment |
| `subscriptionId` | string | `''` |  | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment |


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
module policyassignment 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policyassignments.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policyassignment 'yourpath/arm/Microsoft.Authorization.policyAssignments/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Assignment Name |
| `principalId` | string | Policy Assignment principal ID |
| `resourceId` | string | Policy Assignment resource ID |

## Template references

- [Policyassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyAssignments)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
