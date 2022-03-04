# Policy Set Definitions `[Microsoft.Authorization/policySetDefinitions]`

With this module you can create policy set definitions across the management group or subscription scope.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policySetDefinitions` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The description name of the Set Definition (Initiative) |
| `displayName` | string |  |  | Optional. The display name of the Set Definition (Initiative). Maximum length is 128 characters. |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | Optional. The group ID of the Management Group (Scope). If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | Optional. The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy Set Definition (Initiative). Maximum length is 24 characters for management group scope and 64 characters for subscription scope. |
| `parameters` | object | `{object}` |  | Optional. The Set Definition (Initiative) parameters that can be used in policy definition references. |
| `policyDefinitionGroups` | array | `[]` |  | Optional. The metadata describing groups of policy definition references within the Policy Set Definition (Initiative). |
| `policyDefinitions` | array |  |  | Required. The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters |
| `subscriptionId` | string |  |  | Optional. The subscription ID of the subscription (Scope). Cannot be used with managementGroupId |

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

## Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `deploy.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](deploy.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/deploy.bicep'](./subscription/deploy.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/deploy.bicep'](./subscription/deploy.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module policysetdefinition 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policysetdefinitions.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policysetdefinition 'yourpath/arm/Microsoft.Authorization.policySetDefinitions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Set Definition Name |
| `resourceId` | string | Policy Set Definition resource ID |

## Considerations

- Policy Set Definitions (Initiatives) have a dependency on Policy Assignments being applied before creating an initiative. You can use the Policy Assignment [Module](../policyDefinitions/deploy.bicep) to deploy a Policy Definition and then create an initiative for it on the required scope.

## Template references

- [Policysetdefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policySetDefinitions)
