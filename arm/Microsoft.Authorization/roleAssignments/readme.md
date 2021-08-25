# Role Assignments

This module deploys Role Assignments.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Authorization/roleAssignments`|2018-09-01-preview|
|`Microsoft.Resources/deployments`|2018-02-01|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `roleAssignments` | array | [] | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
| `resourceGroupName` | string | "" | | Optional. Name of the Resource Group to deploy the custom role in. If no Resource Group name is provided, the module deploys at subscription level, therefore registers the custom RBAC role definition in the subscription.
| `cuaId` | string | "" | | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `location` | string | [deployment().location] | | Optional. Location for all resources. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/subscriptions/78945612-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `assignmentScope` | string | The scope (subscription or resource group) of the assignments defined in this module were created on. |
| `roleAssignments` | array | Array of role assignment objects. |

## Considerations

This module can be deployed both at subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter.
- To deploy the module at the subscription level, leave the `resourceGroupName` parameter empty.

## Additional resources

- [What is Azure role-based access control (Azure RBAC)?](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview)
- [Microsoft.Authorization roleAssignments template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/2018-09-01-preview/roleassignments)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)