# PolicyExemption

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2019-10-01|
|`Microsoft.Authorization/policyExemptions`|2020-09-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `policyExemptionName` | string | Required. Specifies the name of the policy exemption. Space characters will be replaced by (-) and converted to lowercase |  | |
| `displayName` | string | Optional. The display name of the policy exemption. |  | |
| `policyExemptionDescription` | string | Optional. The description of the policy exemption. |  | |
| `metadata` | object | Optional. The policy Exemption metadata. Metadata is an open ended object and is typically a collection of key value pairs. |  | |
| `exemptionCategory` | string | Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated | Mitigated |Mitigated,Waiver |
| `policyAssignmentId` | string | Required. The ID of the policy assignment that is being exempted. |  | |
| `policyDefinitionReferenceIds` | array | Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.|  | |
| `expiresOn` | string | Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z  |  | 2021-10-02T03:57:00.000Z |
| `resourceGroupName` | string | Optional. The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter. | | 
| `subscriptionId` | string | Optional. The ID of the azure subscription to be exempted from the policy assignment. Cannot use with management group id parameter. | | 
| `managementGroupId` | string | Optional. The ID of the management group to be exempted from the policy assignment. Cannot use with subscription id parameter. | | 
| `location` | string | Optional. Location for all resources. |  | |

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
| `policyExemptionId` | string | The ID of the Policy Exemption |
| `policyExemptionName` | string | Name of the Policy Exemption |
| `policyExemptionScope` | string | The scope where the Policy Exemption is applied at |

## Considerations

- Policy Exemptions have a dependency on Policy Assignments being applied before creating an exemption. You can use the Policy Assignment [Module](../policyAssignments/deploy.bicep) to deploy a Policy Assignment and then create the exemption for it on the required scope.

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Policy Exemption](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyexemptions)
