# Express Route Gateways `[Microsoft.Network/expressRouteGateways]`

This module deploys an Express Route Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/expressRouteGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/expressRouteGateways) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Express Route Gateway. |
| `virtualHubId` | string | Resource ID of the Virtual Wan Hub. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowNonVirtualWanTraffic` | bool | `False` |  | Configures this gateway to accept traffic from non Virtual WAN networks. |
| `autoScaleConfigurationBoundsMax` | int | `2` |  | Maximum number of scale units deployed for ExpressRoute gateway. |
| `autoScaleConfigurationBoundsMin` | int | `2` |  | Minimum number of scale units deployed for ExpressRoute gateway. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `expressRouteConnections` | array | `[]` |  | List of ExpressRoute connections to the ExpressRoute gateway. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the Firewall policy resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the ExpressRoute Gateway. |
| `resourceGroupName` | string | The resource group of the ExpressRoute Gateway was deployed into. |
| `resourceId` | string | The resource ID of the ExpressRoute Gateway. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteGateway './network/express-route-gateway/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nergcom'
  params: {
    // Required parameters
    name: 'nergcom001'
    virtualHubId: '<virtualHubId>'
    // Non-required parameters
    autoScaleConfigurationBoundsMax: 3
    autoScaleConfigurationBoundsMin: 2
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      hello: 'world'
      'hidden-title': 'This is visible in the resource name'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nergcom001"
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    },
    // Non-required parameters
    "autoScaleConfigurationBoundsMax": {
      "value": 3
    },
    "autoScaleConfigurationBoundsMin": {
      "value": 2
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "hello": "world",
        "hidden-title": "This is visible in the resource name"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteGateway './network/express-route-gateway/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nergmin'
  params: {
    // Required parameters
    name: 'nergmin001'
    virtualHubId: '<virtualHubId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nergmin001"
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>
