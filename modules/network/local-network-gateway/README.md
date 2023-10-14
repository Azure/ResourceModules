# Local Network Gateways `[Microsoft.Network/localNetworkGateways]`

This module deploys a Local Network Gateway.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/localNetworkGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/localNetworkGateways) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `localAddressPrefixes` | array | List of the local (on-premises) IP address ranges. |
| `localGatewayPublicIpAddress` | string | Public IP of the local gateway. |
| `name` | string | Name of the Local Network Gateway. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `fqdn` | string | `''` |  | FQDN of local network gateway. |
| `localAsn` | string | `''` |  | The BGP speaker's ASN. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |
| `localBgpPeeringAddress` | string | `''` |  | The BGP peering address and BGP identifier of this BGP speaker. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |
| `localPeerWeight` | string | `''` |  | The weight added to routes learned from this BGP speaker. This will only take effect if both the localAsn and the localBgpPeeringAddress values are provided. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the local network gateway. |
| `resourceGroupName` | string | The resource group the local network gateway was deployed into. |
| `resourceId` | string | The resource ID of the local network gateway. |

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
module localNetworkGateway './network/local-network-gateway/main.bicep' = {
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module localNetworkGateway './network/local-network-gateway/main.bicep' = {
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
