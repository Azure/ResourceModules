# Management groups

This template will prepare the Management group structure based on the provided parameter.

This module has some known **limitations**:

- It's not possible to change the display name of the root management group (the one that has the tenant GUID as ID)
- It can't manage the Root (/) management group

## Resource types

| Resource Type                           | ApiVersion |
| :-------------------------------------- | :--------- |
| `Microsoft.Management/managementGroups` | 2020-05-01 |
| `Microsoft.Resources/deployments`       | 2020-06-01 |

## Parameters

| Parameter Name               | Type   | Default Value | Possible values | Description                                                                 |
| :--------------------------- | :----- | :------------ | :-------------- | :-------------------------------------------------------------------------- |
| `managementGroupDisplayName` | string |               |                 | Optional. The management group display name. Defaults to managementGroupId. |
| `managementGroupId`          | string |               |                 | Required. The management group id.                                          |
| `parentId`                   | string |               |                 | Optional. The management group parent id. Defaults to current scope.        |
| `roleAssignments`            | array  |               |                 | Optional. Array of role assignment objects to define RBAC on this resource. |

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
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

| Parameter Name           | Type   | Default Value | Possible values | Description                                                                 |
| :----------------------- | :----- | :------------ | :-------------- | :-------------------------------------------------------------------------- |
| `roleDefinitionIdOrName` | string |               |                 | Mandatory. The name or the ID of the role to assign to the management group |
| `principalIds`           | array  |               |                 | Mandatory. An array of principal IDs                                        |

## Outputs

| Output Name           | Type | Description                  |
| :-------------------- | :--- | :--------------------------- |
| `managementGroupName` | int  | Name of the management group |
| `managementGroupId`   | int  | Id of the management group   |

## Considerations

This template is using a **Tenant level deployment**, meaning the user/principal deploying it needs to have the [proper access](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-tenant#required-access)

> If owner access is excessive, the following rights roles will grant enough rights:
> **Automation Job Operator** at **tenant** level (scope '/')<br>
> **Management Group Contributor** at the top management group that needs to be managed
>
>> Consider using the following script:<br>
>> `$PrincipalID = "<The id of the identity here>"`<br>
>> `$TopMGID = "<The id of the management group here>"`<br>
>> `New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/" -RoleDefinitionName "Automation Job Operator"`<br>
>> `New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/providers/Microsoft.Management/managementGroups/$TopMGID" -RoleDefinitionName "Management Group Contributor"`

## Additional resources

- [Management group](https://docs.microsoft.com/en-us/azure/governance/management-groups/)
- [Template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.management/managementgroups)
