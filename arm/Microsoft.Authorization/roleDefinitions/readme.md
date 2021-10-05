# Role Definitions

This module deploys custom RBAC Role Definitions.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Authorization/roleDefinitions`|2018-01-01-preview|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `roleName` | string | | | Required. Name of the custom RBAC role to be created.|
| `roleDescription` | string | [] | | Optional. Description of the custom RBAC role to be created.|
| `actions` | array | [] | | Optional. List of allowed actions.|
| `notActions` | array | [] | | Optional. List of denied actions.|
| `dataActions` | array | [] | | Optional. List of allowed data actions.|
| `notDataActions` | array | [] | | Optional. List of denied data actions.|
| `managementGroupId` | string | "" | | Optional. The ID of the Management Group where the Role Definition and Target Scope will be applied to. Cannot use when Subscription or Resource Groups Parameters are used. |
| `subscriptionId`    | string | ""            |                 | Optional. The Subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level. |
| `resourceGroupName` | string | "" | | Optional. Name of the Resource Group to deploy the custom role in. If no Resource Group name is provided, the module deploys at subscription level, therefore registers the custom RBAC role definition in the subscription. |
| `location` | string | "" | | Optional. Location for all resources. If not provided, will default to the deployment location. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `roleDefinitionId` | string | The id of the role definition that was created. |
| `roleDefinitionScope` | string | The scope this definition was created on. |

## Modules Structure

| Module                             | Level | Type        | Target Scope     |
| :--------------------------------- | :---- | ----------- | :--------------- |
| `deploy.bicep`                     | 0     | Main Module | Management Group |
| `nested_roleDefinitions_mg.bicep`  | 1     | Sub Module  | Management Group |
| `nested_roleDefinitions_sub.bicep` | 1     | Sub Module  | Subscription     |
| `nested_roleDefinitions_rg.bicep`  | 1     | Sub Module  | Resource Group   |

## Considerations

This module can be deployed the management group, subscription or resource group level:

---

**Note**: The main `deploy.bicep` always deploys at the Management Group scope. That way it can perform deployments at lower scopes.

---

### Management Group Deployment

 To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module. **Example**:

```json
    "managementGroupId": {
    	"value": "contoso-group"
    }
```

> The name of the Management Group in the deployment does not have to match the value of the `managementGroupId` in the input parameters. 

### Subscription Deployment

 To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

```json
    "subscriptionId": {
    	"value": "12345678-b049-471c-95af-123456789012"
    }
```

### Resource Group Deployment

 To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

```json
    "subscriptionId": {
    	"value": "12345678-b049-471c-95af-123456789012"
    },
	"resourceGroupName": {
    	"value": "target-resourceGroup"
    }
```

>  The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).

## Additional resources

- [Understand Azure role definitions](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-definitions)
- [Microsoft.Authorization roleDefinitions template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/2018-01-01-preview/roledefinitions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)