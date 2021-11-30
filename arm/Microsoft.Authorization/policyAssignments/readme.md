# Policy Assignments `[Microsoft.Authorization/policyAssignments]`

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | 2021-06-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. This message will be part of response in case of policy violation. |
| `displayName` | string |  |  | Optional. The display name of the policy assignment. |
| `enforcementMode` | string | `Default` | `[Default, DoNotEnforce]` | Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce |
| `identity` | string | `SystemAssigned` | `[SystemAssigned, None]` | Optional. The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string |  |  | Optional. The Target Scope for the Policy. The name of the management group for the policy assignment |
| `metadata` | object | `{object}` |  | Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy assignment. |
| `nonComplianceMessage` | string |  |  | Optional. The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | Optional. The policy excluded scopes |
| `parameters` | object | `{object}` |  | Optional. Parameters for the policy assignment if needed. |
| `policyDefinitionId` | string |  |  | Required. Specifies the ID of the policy definition or policy set definition being assigned. |
| `resourceGroupName` | string |  |  | Optional. The Target Scope for the Policy. The name of the resource group for the policy assignment |
| `roleDefinitionIds` | array | `[]` |  | Required. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition |
| `subscriptionId` | string |  |  | Optional. The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment |

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
| `policyAssignmentName` | string | Policy Assignment Name |
| `policyAssignmentPrincipalId` | string | Policy Assignment principal ID |
| `policyAssignmentResourceId` | string | Policy Assignment resource ID |

## Template references

- [Policyassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyAssignments)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
