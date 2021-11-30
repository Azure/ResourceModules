# Role Definitions `[Microsoft.Authorization/roleDefinitions]`

This module deploys custom RBAC Role Definitions.

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
| `managementGroupId` | string |  |  | Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. Cannot use when Subscription or Resource Groups Parameters are used. |
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

> The name of the Management Group in the deployment does not have to match the value of the `managementGroupId` in the input parameters.

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `roleDefinitionName` | string | The GUID of the Role Definition |
| `roleDefinitionResourceId` | string | The resource ID of the Role Definition |
| `roleDefinitionScope` | string | The scope this Role Definition applies to |

## Considerations

This module can be deployed both at subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter and an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the subscription level, provide an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the management group level, provide an existing management group ID in the `managementGroupId` parameter.

## Template references

- [Roledefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2018-01-01-preview/roleDefinitions)
