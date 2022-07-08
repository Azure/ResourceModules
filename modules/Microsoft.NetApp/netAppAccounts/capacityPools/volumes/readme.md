# Azure NetApp Files Capacity Pool Volumes `[Microsoft.NetApp/netAppAccounts/capacityPools/volumes]`

This template deploys volumes in a capacity pool of an Azure NetApp files.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2021-06-01/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the pool volume. |
| `subnetResourceId` | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| `usageThreshold` | int | Maximum storage quota allowed for a file system in bytes. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `capacityPoolName` | string | The name of the parent capacity pool. Required if the template is used in a standalone deployment. |
| `netAppAccountName` | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `creationToken` | string | `[parameters('name')]` |  | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `exportPolicyRules` | array | `[]` |  | Export policy rules. |
| `location` | string | `[resourceGroup().location]` |  | Location of the pool volume. |
| `protocolTypes` | array | `[]` |  | Set of protocol types. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serviceLevel` | string | `'Standard'` | `[Premium, Standard, StandardZRS, Ultra]` | The pool service level. Must match the one of the parent capacity pool. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Volume. |
| `resourceGroupName` | string | The name of the Resource Group the Volume was created in. |
| `resourceId` | string | The Resource ID of the Volume. |
