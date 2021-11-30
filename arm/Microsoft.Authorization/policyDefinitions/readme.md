# Policy Definitions `[Microsoft.Authorization/policyDefinitions]`

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The policy definition description. |
| `displayName` | string |  |  | Optional. The display name of the policy definition. |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string |  |  | Optional. The group ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. '/') |
| `metadata` | object | `{object}` |  | Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `mode` | string | `All` | `[All, Indexed, Microsoft.KeyVault.Data, Microsoft.ContainerService.Data, Microsoft.Kubernetes.Data]` | Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. |
| `name` | string |  |  | Required. Specifies the name of the policy definition. |
| `parameters` | object | `{object}` |  | Optional. The policy definition parameters that can be used in policy definition references. |
| `policyRule` | object |  |  | Required. The Policy Rule details for the Policy Definition |
| `subscriptionId` | string |  |  | Optional. The subscription ID of the subscription (Scope). Cannot be used with managementGroupId |

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `policyDefinitionName` | string | Policy Definition Name |
| `policyDefinitionResourceId` | string | Policy Definition resource ID |
| `roleDefinitionIds` | array | Policy Definition Role Definition IDs |

## Template references

- [Policydefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions)
