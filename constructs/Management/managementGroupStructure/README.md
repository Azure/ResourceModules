# Management groups

This template will prepare the Management group structure based on the provided parameter.

This module has some known **limitations**:

- It's not possible to change the display name of the root management group (the one that has the tenant GUID as ID)
- It can't manage the Root (/) management group

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Management/managementGroups`|2021-04-01|
|`Microsoft.Resources/deployments`|2020-06-01|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `mgStructure` | Array of objects | | Complex structure, see below | Required. The structure of the management groups |

### Parameter Usage: mgStructure

Describes the Management groups to be created. Each management group is represented by an element of the array

``` json
"mgStructure": {
    "value": [
        {
            "name":"tst1",
            "parentId":"test-mg",
            "parentNotManagedInThisTemplate": true
        },
        {
            "name":"child1",
            "parentId":"tst1",
            "roleAssignments":[
                {
                    "roleDefinitionIdOrName": "Desktop Virtualization User",
                    "principalIds": [
                        "12345567-890a-bcde-f012-456789000000", // object 1
                        "12345567-890a-bcde-f012-456789000001" // object 2
                    ]
                }
            ]
        },
        {
            "name":"child2",
            "displayName": "anotherName",
            "parentId":"tst1",
            "parentNotManagedInThisTemplate": false
        },
        {
            "name":"nephew1",
            "parentId":"child1",
            "parentNotManagedInThisTemplate": false
        }
    ]
}
```

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `name` | string | | | Required. The group ID of the Management group |
| `parentId` | string | | A MG name | Required. The template will concatenate `/providers/Microsoft.Management/managementGroups/` to create the resource ID of the parent management group the deployed one is child of |
| `displayName` | string | `name` | | Optional. The display name of the management group. If not specified, the ID (name) will be used |
| `parentNotManagedInThisTemplate` | bool | `false` | | Optional. `true` if the parent management group is existing and defined elsewhere, `false` if the parent MG is also managed in this template. This parameter is used to define the deployment sequence |
| `roleAssignments` | array | | | Optional. Array of role assignment objects |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managementGroupCount` | int | Number of management groups considered in the deployment |

## Considerations

This template is using a **Tenant level deployment**, meaning the user/principal deploying it needs to have the [proper access](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-tenant#required-access)

> If owner access is excessive, the following rights roles will grant enough rights:
> **Automation Job Operator** at **tenant** level (scope '/')<br>
> **Management Group Contributor** at the top management group that needs to be managed
>
>> Consider using the following script:<br>
>> `$PrincipalID = "<The object ID of the identity here>"`<br>
>> `$TopMGID = "<The group ID of the management group here>"`<br>
>> `New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/" -RoleDefinitionName "Automation Job Operator"`<br>
>> `New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/providers/Microsoft.Management/managementGroups/$TopMGID" -RoleDefinitionName "Management Group Contributor"`
