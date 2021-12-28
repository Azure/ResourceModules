# Policy Exemptions `[Microsoft.Authorization/policyExemptions]`

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | 2020-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The description of the policy exemption. |
| `displayName` | string |  |  | Optional. The display name of the policy exemption. |
| `exemptionCategory` | string | `Mitigated` | `[Mitigated, Waiver]` | Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated |
| `expiresOn` | string |  |  | Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z  |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string |  |  | Optional. The group ID of the management group to be exempted from the policy assignment. Cannot use with subscription ID parameter. |
| `metadata` | object | `{object}` |  | Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy exemption. |
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
| `policyExemptionName` | string | Policy Exemption Name |
| `policyExemptionResourceId` | string | Policy Exemption resource ID |
| `policyExemptionScope` | string | Policy Exemption Scope |

## Considerations

- Policy Exemptions have a dependency on Policy Assignments being applied before creating an exemption. You can use the Policy Assignment [Module](../policyAssignments/deploy.bicep) to deploy a Policy Assignment and then create the exemption for it on the required scope.

## Template references

- [Policyexemptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-07-01-preview/policyExemptions)
