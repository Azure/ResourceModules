# Role Definitions

This module deploys custom RBAC Role Definitions.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Authorization/roleDefinitions`|2018-07-01|
|`Microsoft.Resources/deployments`|2018-02-01|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `roleName` | string | | | Required. Name of the custom RBAC role to be created.
| `resourceGroupName` | string | "" | | Optional. Name of the Resource Group to deploy the custom role in. If no Resource Group name is provided, the module deploys at subscription level, therefore registers the custom RBAC role definition in the subscription.
| `roleDescription` | string | [] | | Optional. Description of the custom RBAC role to be created.
| `actions` | array | [] | | Optional. List of allowed actions.
| `notActions` | array | [] | | Optional. List of denied actions.
| `dataActions` | array | [] | | Optional. List of allowed data actions.
| `notDataActions` | array | [] | | Optional. List of denied data actions.
| `cuaId` | string | "" | | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `definitionId` | string | The id of the role definition that was created. |
| `definitionScope` | string | The scope (subscription or resource group) this definition was created on. |

## Considerations

This module can be deployed both at subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter.
- To deploy the module at the subscription level, leave the `resourceGroupName` parameter empty.

## Additional resources

- [Understand Azure role definitions](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-definitions)
- [Microsoft.Authorization roleDefinitions template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/2018-01-01-preview/roledefinitions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)