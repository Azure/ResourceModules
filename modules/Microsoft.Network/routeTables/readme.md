# Route Tables `[Microsoft.Network/routeTables]`

This module deploys a user defined route table.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Network/routeTables` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/routeTables) |

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
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `routes` | array | `[]` |  | An Array of Routes to be established within the hub route table. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `routes`

The `routes` parameter accepts a JSON Array of Route objects to deploy to the Route Table.

Here's an example of specifying a few routes:

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
routes: [
    {
      name: 'tojumpboxes'
      properties: {
        addressPrefix: '172.16.0.48/28'
        nextHopType: 'VnetLocal'
      }
    }
    {
      name: 'tosharedservices'
      properties: {
        addressPrefix: '172.16.0.64/27'
        nextHopType: 'VnetLocal'
      }
    }
    {
      name: 'toonprem'
      properties: {
        addressPrefix: '10.0.0.0/8'
        nextHopType: 'VirtualNetworkGateway'
      }
    }
    {
      name: 'tonva'
      properties: {
        addressPrefix: '172.16.0.0/18'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: '172.16.0.20'
      }
    }
]
```

</details>
<p>

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

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the route table. |
| `resourceGroupName` | string | The resource group the route table was deployed into. |
| `resourceId` | string | The resource ID of the route table. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-udr-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "routes": {
            "value": [
                {
                    "name": "default",
                    "properties": {
                        "addressPrefix": "0.0.0.0/0",
                        "nextHopType": "VirtualAppliance",
                        "nextHopIpAddress": "172.16.0.20"
                    }
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module routeTables './Microsoft.Network/routeTables/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-routeTables'
  params: {
    name: '<<namePrefix>>-az-udr-x-001'
    lock: 'CanNotDelete'
    routes: [
      {
        name: 'default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '172.16.0.20'
        }
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>
