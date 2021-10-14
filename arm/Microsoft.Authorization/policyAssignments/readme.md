# PolicyAssignment

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2019-10-01|
|`Microsoft.Authorization/policyAssignments`|2020-09-01|
|`Microsoft.Authorization/roleAssignments`|2020-04-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `policyAssignmentName` | string | Required. Specifies the name of the policy assignment. |  | |
| `policyDefinitionID` | string | Required. Specifies the ID of the policy definition or policy set definition being assigned. |  | |
| `parameters` | array | Optional. Parameters for the policy assignment if needed. |  | |
| `identity` | string | Optional. The managed identity associated with the policy assignment. |  | |
| `roleDefinitionIds` | array | Optional. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built in Roles. They must match on what is on the policy definition |  | |
| `policyAssignmentDescription` | string | Optional. This message will be part of response in case of policy violation. |  | |
| `displayName` | string | Optional. The display name of the policy assignment. |  | |
| `metadata` | object | Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key value pairs. |  | |
| `nonComplianceMessage` | string | Optional. The messages that describe why a resource is non-compliant with the policy. If not provided will be replaced with empty |  | |
| `enforcementMode` | string | Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce |  | |
| `notScopes` | array | Optional. The policy excluded scopes |  | |
| `location` | string | Optional. Location for all resources. |  | |
| `resourceGroupName` | string | Optional. Specifies the name of the resource group where you want to assign the policy. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. | | 
| `subscriptionId` | string | Optional. ID of the Subscription where you want to assign the policy. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided policy to the subscription. | | 
| `managementGroupId` | string | Optional. ID of the Management Group where you want to assign the policy. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided policy to the management group. | | 


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
| `policyAssignmentId` | string | The ID of the Policy Assignment |
| `policyAssignmentPrincipalId` | string | The Principal ID Of the Managed Identity for the Policy Assignment |
| `policyAssignmentName` | string | Name of the Policy Assignment. |

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Policy Assignments](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments?tabs=bicep)
- [Role Assignments](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments?tabs=bicep)
