# Route Tables `[Microsoft.Network/routeTables]`

This module deploys a user defined route table.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Network/routeTables` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name given for the hub route table. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `disableBgpRoutePropagation` | bool | `False` |  | Switch to disable BGP route propagation. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `routes` | array | `[]` |  | An Array of Routes to be established within the hub route table. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `routes`

The `routes` parameter accepts a JSON Array of Route objects to deploy to the Route Table.

Here's an example of specifying a few routes:

```json
"routes": {
  "value": [
    {
      "name": "tojumpboxes",
      "properties": {
        "addressPrefix": "172.16.0.48/28",
        "nextHopType": "VnetLocal"
      }
    },
    {
      "name": "tosharedservices",
      "properties": {
        "addressPrefix": "172.16.0.64/27",
        "nextHopType": "VnetLocal"
      }
    },
    {
      "name": "toonprem",
      "properties": {
        "addressPrefix": "10.0.0.0/8",
        "nextHopType": "VirtualNetworkGateway"
      }
    },
    {
      "name": "tonva",
      "properties": {
        "addressPrefix": "172.16.0.0/18",
        "nextHopType": "VirtualAppliance",
        "nextHopIpAddress": "172.16.0.20"
      }
    }
  ]
}
```

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the route table |
| `resourceGroupName` | string | The resource group the route table was deployed into |
| `resourceId` | string | The resource ID of the route table |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Routetables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/routeTables)
