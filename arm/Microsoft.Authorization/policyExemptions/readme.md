# Policy Exemptions `[Microsoft.Authorization/policyExemptions]`

With this module you can create policy exemptions across the management group, subscription or resource group scope.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | 2020-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. Use when scope target is resource group. |
| `description` | string |  |  | Optional. The description of the policy exemption. |
| `displayName` | string |  |  | Optional. The display name of the policy exemption. Maximum length is 128 characters. |
| `exemptionCategory` | string | `Mitigated` | `[Mitigated, Waiver]` | Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated |
| `expiresOn` | string |  |  | Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z  |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string |  |  | Optional. The group ID of the management group to be exempted from the policy assignment. Cannot use with subscription ID parameter. |
| `metadata` | object | `{object}` |  | Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy exemption. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes. |
| `policyAssignmentId` | string |  |  | Required. The resource ID of the policy assignment that is being exempted. |
| `policyDefinitionReferenceIds` | array | `[]` |  | Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| `resourceGroupName` | string |  |  | Optional. The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter. |
| `subscriptionId` | string |  |  | Optional. The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter. |

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
module policyexemption 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policyexemptions.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policyexemption 'yourpath/arm/Microsoft.Authorization.policyExemptions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name |
| `resourceId` | string | Policy Exemption resource ID |
| `scope` | string | Policy Exemption Scope |

## Considerations

- Policy Exemptions have a dependency on Policy Assignments being applied before creating an exemption. You can use the Policy Assignment [Module](../policyAssignments/deploy.bicep) to deploy a Policy Assignment and then create the exemption for it on the required scope.

## Template references

- [Policyexemptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-07-01-preview/policyExemptions)
