# Express Route Gateways `[Microsoft.Network/expressRouteGateways]`

This module deploys an Express Route Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/expressRouteGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/expressRouteGateways) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.express-route-gateway:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteGateway 'br:bicep/modules/network.express-route-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nergcom'
  params: {
    // Required parameters
    name: 'nergcom001'
    virtualHubId: '<virtualHubId>'
    // Non-required parameters
    autoScaleConfigurationBoundsMax: 3
    autoScaleConfigurationBoundsMin: 2
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteGateway 'br:bicep/modules/network.express-route-gateway:1.0.0' = {
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Express Route Gateway. |
| [`virtualHubId`](#parameter-virtualhubid) | string | Resource ID of the Virtual Wan Hub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowNonVirtualWanTraffic`](#parameter-allownonvirtualwantraffic) | bool | Configures this gateway to accept traffic from non Virtual WAN networks. |
| [`autoScaleConfigurationBoundsMax`](#parameter-autoscaleconfigurationboundsmax) | int | Maximum number of scale units deployed for ExpressRoute gateway. |
| [`autoScaleConfigurationBoundsMin`](#parameter-autoscaleconfigurationboundsmin) | int | Minimum number of scale units deployed for ExpressRoute gateway. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`expressRouteConnections`](#parameter-expressrouteconnections) | array | List of ExpressRoute connections to the ExpressRoute gateway. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the Firewall policy resource. |

### Parameter: `allowNonVirtualWanTraffic`

Configures this gateway to accept traffic from non Virtual WAN networks.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `autoScaleConfigurationBoundsMax`

Maximum number of scale units deployed for ExpressRoute gateway.
- Required: No
- Type: int
- Default: `2`

### Parameter: `autoScaleConfigurationBoundsMin`

Minimum number of scale units deployed for ExpressRoute gateway.
- Required: No
- Type: int
- Default: `2`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `expressRouteConnections`

List of ExpressRoute connections to the ExpressRoute gateway.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Name of the Express Route Gateway.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the Firewall policy resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `virtualHubId`

Resource ID of the Virtual Wan Hub.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the ExpressRoute Gateway. |
| `resourceGroupName` | string | The resource group of the ExpressRoute Gateway was deployed into. |
| `resourceId` | string | The resource ID of the ExpressRoute Gateway. |

## Cross-referenced modules

_None_
