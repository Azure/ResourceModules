# AvailabilitySet

This template deploys an Availability Set

## Resource types

| Resource Type                                                  | ApiVersion         |
| :------------------------------------------------------------- | :----------------- |
| `Microsoft.Compute/availabilitySets`                           | 2021-04-01         |
| `Microsoft.Authorization/locks`                                | 2016-09-01         |
| `Microsoft.Compute/availabilitySets/providers/roleAssignments` | 2020-04-01-preview |

## Parameters

| Parameter Name                | Type   | Default Value | Possible values               | Description                                                                                                                                                                                                                                                                                                                                                                                                     |
| :---------------------------- | :----- | :------------ | :---------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `availabilitySetName`         | string |               |                               | Optional. The name of the availability set that is being created.                                                                                                                                                                                                                                                                                                                                               |
| `availabilitySetFaultDomain`  | int    | 2             |                               | Optional. The number of fault domains to use.                                                                                                                                                                                                                                                                                                                                                                   |
| `availabilitySetUpdateDomain` | int    | 5             |                               | Optional. The number of update domains to use.                                                                                                                                                                                                                                                                                                                                                                  |
| `availabilitySetSku`          | string | Aligned       |                               | Optional. Sku of the availability set. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks.                                                                                                                                                                                                                                                           |
| `proximityPlacementGroupId`   | string |               |                               | Optional. Resource Id of a proximity placement group.                                                                                                                                                                                                                                                                                                                                                           |
| `location`                    | string |               |                               | Optional. Resource location.                                                                                                                                                                                                                                                                                                                                                                                    |
| `lockForDeletion`             | bool   | `false`       |                               | Optional. Switch to lock the availability set from deletion.                                                                                                                                                                                                                                                                                                                                                    |
| `roleAssignments`             | array  | []            | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags`                        | object |               |                               | Optional. Tags of the availability set resource.                                                                                                                                                                                                                                                                                                                                                                |
| `cuaId`                       | string | ""            |                               | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.                                                                                                                                                                                                                                                                                                                        |

### Parameter Usage: `lockForDeletion`

Switch to lock Availability Set from deletion.

```json
"lockForDeletion": {
    "value": true
}
```

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

| Output Name                    | Type   | Description                                              |
| :----------------------------- | :----- | :------------------------------------------------------- |
| `availabilitySetResourceName`  | string | The Name of the Availability Set.                        |
| `availabilitySetResourceId`    | string | The Resource Id of the Availability Set.                 |
| `availabilitySetResourceGroup` | string | The Resource Group the Availability Set was deployed to. |

## Considerations

N/A

## Additional resources

- [Microsoft.Compute availabilitySets template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/availabilitysets)
