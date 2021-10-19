# ProximityPlacementGroup

This template deploys a Proximity Placement Group

## Resource types

| Resource Type                                                          | ApiVersion         |
| :--------------------------------------------------------------------- | :----------------- |
| `Microsoft.Compute/proximityPlacementGroups`                           | 2021-04-01         |
| `Microsoft.Authorization/locks`                                        | 2016-09-01         |
| `Microsoft.Compute/proximityPlacementGroups/providers/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Resources/deployments`                                      | 2020-06-01         |

## Parameters

| Parameter Name                | Type   | Default Value | Possible values               | Description                                                                                                                                                                                                                                                                                                                                                                                                     |
| :---------------------------- | :----- | :------------ | :---------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `proximityPlacementGroupName` | string |               |                               | Required. The name of the proximity placement group that is being created.                                                                                                                                                                                                                                                                                                                                      |
| `proximityPlacementGroupType` | string | `Standard`    | `Standard`/`Ultra`            | Optional. Specifies the type of the proximity placement group.                                                                                                                                                                                                                                                                                                                                                  |
| `location`                    | string |               |                               | Optional. Resource location.                                                                                                                                                                                                                                                                                                                                                                                    |
| `lock` | string | Optional. Specify the type of lock. | 'NotSpecified' | 'CanNotDelete', 'NotSpecified', 'ReadOnly' |
| `roleAssignments`             | array  | []            | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags`                        | object |               |                               | Optional. Tags of the proximity placement group resource.                                                                                                                                                                                                                                                                                                                                                       |
| `cuaId`                       | string | ""            |                               | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.                                                                                                                                                                                                                                                                                                                        |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
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

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name                            | Type   | Description                                                       |
| :------------------------------------- | :----- | :---------------------------------------------------------------- |
| `proximityPlacementGroupResourceName`  | string | The Name of the Proximity Placement Group.                        |
| `proximityPlacementGroupResourceId`    | string | The Resource Id of the Proximity Placement Group.                 |
| `proximityPlacementGroupResourceGroup` | string | The Resource Group the Proximity Placement Group was deployed to. |

## Considerations

N/A

## Additional resources

- [Microsoft.Compute proximityPlacementGroups template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/proximityPlacementGroups)
