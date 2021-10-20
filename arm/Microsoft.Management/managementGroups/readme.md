# Management groups `[Microsoft.Management/managementGroups]`

This template will prepare the Management group structure based on the provided parameter.

This module has some known **limitations**:

- It's not possible to change the display name of the root management group (the one that has the tenant GUID as ID)
- It can't manage the Root (/) management group

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Management/managementGroups` | 2021-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `managementGroupId` | string |  |  | Required. The management group id. |
| `managementGroupName` | string |  |  | Optional. The management group display name. Defaults to managementGroupId.  |
| `parentId` | string |  |  | Optional. The management group parent id. Defaults to current scope. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects to define RBAC on this resource. |

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

| Output Name | Type |
| :-- | :-- |
| `managementGroupId` | string |
| `managementGroupName` | string |

## Considerations

This template is using a **Tenant level deployment**, meaning the user/principal deploying it needs to have the [proper access](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-tenant#required-access)

If owner access is excessive, the following rights roles will grant enough rights:
- **Automation Job Operator** at **tenant** level (scope '/')
- **Management Group Contributor** at the top management group that needs to be managed

Consider using the following script:
```powershell
$PrincipalID = "<The id of the identity here>"
$TopMGID = "<The id of the management group here>"
New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/" -RoleDefinitionName "Automation Job Operator"
New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/providers/Microsoft.Management/managementGroups/$TopMGID" -RoleDefinitionName "Management Group Contributor"
```

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Managementgroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups)
