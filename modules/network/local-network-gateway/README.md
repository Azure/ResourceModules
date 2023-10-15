# Local Network Gateways `[Microsoft.Network/localNetworkGateways]`

This module deploys a Local Network Gateway.

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
| `Microsoft.Network/localNetworkGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/localNetworkGateways) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.local-network-gateway:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module localNetworkGateway 'br:bicep/modules/network.local-network-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nlngcom'
  params: {
    // Required parameters
    localAddressPrefixes: [
      '192.168.1.0/24'
    ]
    localGatewayPublicIpAddress: '8.8.8.8'
    name: 'nlngcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    localAsn: '65123'
    localBgpPeeringAddress: '192.168.1.5'
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
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "localAddressPrefixes": {
      "value": [
        "192.168.1.0/24"
      ]
    },
    "localGatewayPublicIpAddress": {
      "value": "8.8.8.8"
    },
    "name": {
      "value": "nlngcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "localAsn": {
      "value": "65123"
    },
    "localBgpPeeringAddress": {
      "value": "192.168.1.5"
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
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
module localNetworkGateway 'br:bicep/modules/network.local-network-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nlngmin'
  params: {
    // Required parameters
    localAddressPrefixes: [
      '192.168.1.0/24'
    ]
    localGatewayPublicIpAddress: '8.8.8.8'
    name: 'nlngmin001'
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
    "localAddressPrefixes": {
      "value": [
        "192.168.1.0/24"
      ]
    },
    "localGatewayPublicIpAddress": {
      "value": "8.8.8.8"
    },
    "name": {
      "value": "nlngmin001"
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
| [`localAddressPrefixes`](#parameter-localaddressprefixes) | array | List of the local (on-premises) IP address ranges. |
| [`localGatewayPublicIpAddress`](#parameter-localgatewaypublicipaddress) | string | Public IP of the local gateway. |
| [`name`](#parameter-name) | string | Name of the Local Network Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`fqdn`](#parameter-fqdn) | string | FQDN of local network gateway. |
| [`localAsn`](#parameter-localasn) | string | The BGP speaker's ASN. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |
| [`localBgpPeeringAddress`](#parameter-localbgppeeringaddress) | string | The BGP peering address and BGP identifier of this BGP speaker. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |
| [`localPeerWeight`](#parameter-localpeerweight) | string | The weight added to routes learned from this BGP speaker. This will only take effect if both the localAsn and the localBgpPeeringAddress values are provided. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `fqdn`

FQDN of local network gateway.
- Required: No
- Type: string
- Default: `''`

### Parameter: `localAddressPrefixes`

List of the local (on-premises) IP address ranges.
- Required: Yes
- Type: array

### Parameter: `localAsn`

The BGP speaker's ASN. Not providing this value will automatically disable BGP on this Local Network Gateway resource.
- Required: No
- Type: string
- Default: `''`

### Parameter: `localBgpPeeringAddress`

The BGP peering address and BGP identifier of this BGP speaker. Not providing this value will automatically disable BGP on this Local Network Gateway resource.
- Required: No
- Type: string
- Default: `''`

### Parameter: `localGatewayPublicIpAddress`

Public IP of the local gateway.
- Required: Yes
- Type: string

### Parameter: `localPeerWeight`

The weight added to routes learned from this BGP speaker. This will only take effect if both the localAsn and the localBgpPeeringAddress values are provided.
- Required: No
- Type: string
- Default: `''`

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

Name of the Local Network Gateway.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the local network gateway. |
| `resourceGroupName` | string | The resource group the local network gateway was deployed into. |
| `resourceId` | string | The resource ID of the local network gateway. |

## Cross-referenced modules

_None_
