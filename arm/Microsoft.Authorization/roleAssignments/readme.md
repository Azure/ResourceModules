# Role Assignments `[Microsoft.Authorization/roleAssignments]`

This module deploys Role Assignments.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `condition` | string |  |  | Optional. The conditions on the role assignment. This limits the resources it can be assigned to |
| `conditionVersion` | string | `2.0` | `[2.0]` | Optional. Version of the condition. Currently accepted value is "2.0" |
| `delegatedManagedIdentityResourceId` | string |  |  | Optional. ID of the delegated managed identity resource |
| `description` | string |  |  | Optional. Description of role assignment |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string |  |  | Optional. Group ID of the Management Group to assign the RBAC role to. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided RBAC role to the management group. |
| `principalId` | string |  |  | Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity) |
| `principalType` | string | '' | `[ServicePrincipal, Group, User, ForeignGroup, Device, ]` | Optional. The principal type of the assigned principal ID. |
| `resourceGroupName` | string |  |  | Optional. Name of the Resource Group to assign the RBAC role to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |
| `roleDefinitionIdOrName` | string |  |  | Required. You can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `subscriptionId` | string |  |  | Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |

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
| `roleAssignmentName` | string | The GUID of the Role Assignment |
| `roleAssignmentResourceId` | string | The resource ID of the Role Assignment |
| `roleAssignmentScope` | string | The scope this Role Assignment applies to |

## Considerations

This module can be deployed at the management group, subscription or resource group level

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-08-01-preview/roleAssignments)
