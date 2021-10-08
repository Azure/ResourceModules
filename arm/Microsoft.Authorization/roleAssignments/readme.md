# Role Assignments

This module deploys Role Assignments.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Authorization/roleAssignments`|2020-04-01-preview|
|`Microsoft.Resources/deployments`|2019-10-01|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `roleDefinitionIdOrName` | string |  | Owner | Required. You can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
| `principalId` | string | | abcdefgh-1234-1234-1234-ec99e51285a3 | Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity)
| `resourceGroupName` | string | "" | | Optional. Name of the Resource Group to assign the RBAC role to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.
| `subscriptionId` | string | "" | | Optional. ID of the Subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.
| `managementGroupId` | string | "" | | Optional. ID of the Management Group to assign the RBAC role to. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided RBAC role to the management group.
| `location` | string | [deployment().location] | | Optional. Location for all resources. |

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
| `roleAssignmentName` | string | The name of the role assignment |
| `roleAssignmentScope` | string | The scope of the assignments defined in this module were created on. |
| `roleAssignmentId` | array | Role Assignment Resource ID |

## Considerations

This module can be deployed at the management group, subscription or resource group level

## Additional resources

- [What is Azure role-based access control (Azure RBAC)?](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview)
- [Microsoft.Authorization roleAssignments template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/2018-09-01-preview/roleassignments)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)