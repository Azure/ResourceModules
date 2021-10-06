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
| `roleDescription` | string | [] | | Optional. Description of the custom RBAC role to be created.
| `actions` | array | [] | | Optional. List of allowed actions.
| `notActions` | array | [] | | Optional. List of denied actions.
| `dataActions` | array | [] | | Optional. List of allowed data actions.
| `notDataActions` | array | [] | | Optional. List of denied data actions.
| `managementGroupId` | string | "" | | Optional. The ID of the Management Group where the Role Definition and Target Scope will be applied to. Cannot use when Subscription or Resource Groups Parameters are used.
| `subscriptionId`    | string | ""            |                 | Optional. The Subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level.
| `resourceGroupName` | string | "" | | Optional. Name of the Resource Group to deploy the custom role in. If no Resource Group name is provided, the module deploys at subscription level, therefore registers the custom RBAC role definition in the subscription.
| `location` | string | "" | | Optional. Location for all resources. If not provided, will default to the deployment location.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `roleDefinitionId` | string | The id of the role definition that was created. |
| `roleDefinitionScope` | string | The scope this definition was created on. |

## Considerations

This module can be deployed both at subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter and an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the subscription level, provide an existing subscription ID in the `subscriptionId` parameter.
- To deploy the module at the management group level, provide an existing management group ID in the `managementGroupId` parameter.

## Additional resources

- [Understand Azure role definitions](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-definitions)
- [Microsoft.Authorization roleDefinitions template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/2018-01-01-preview/roledefinitions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)