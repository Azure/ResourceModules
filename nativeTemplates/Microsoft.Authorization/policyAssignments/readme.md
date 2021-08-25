# PolicyAssignment

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Authorization/policyAssignments`|2018-05-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `policyAssignmentName` | string | Required. Specifies the name of the policy assignment. |  | |
| `location` | string | Optional. Location for all resources. |  | |
| `resourceGroupName` | string | Optional. Specifies the name of the resource group where you want to assign the policy. |  | |
| `policyDefinitionID` | string | Required. Specifies the ID of the policy definition or policy set definition being assigned. |  | |
| `parameters` | object | Optional. Parameters for the policy assignment if needed. |  | |
| `identity` | string | Optional. The managed identity associated with the policy assignment. |  | |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  | |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `assignmentScope` | string | The scope (subscription or resource group) of the assignment. |
| `policyAssignmentName` | string | Name of the policy assignment. |

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/deployments)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/deployments)
