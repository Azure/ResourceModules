# DNS Resolvers `[Microsoft.Network/dnsResolvers]`

This module deploys a DNS Resolver.

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
| `Microsoft.Network/dnsResolvers` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers) |
| `Microsoft.Network/dnsResolvers/inboundEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers/inboundEndpoints) |
| `Microsoft.Network/dnsResolvers/outboundEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers/outboundEndpoints) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Private DNS Resolver. |
| `virtualNetworkId` | string | ResourceId of the virtual network to attach the Private DNS Resolver to. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `inboundEndpoints` | array | `[]` |  | Inbound Endpoints for Private DNS Resolver. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `outboundEndpoints` | array | `[]` |  | Outbound Endpoints for Private DNS Resolver. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Private DNS Resolver. |
| `resourceGroupName` | string | The resource group the Private DNS Resolver was deployed into. |
| `resourceId` | string | The resource ID of the Private DNS Resolver. |

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
module dnsResolver './network/dns-resolver/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ndrcom'
  params: {
    // Required parameters
    name: 'ndrcom001'
    virtualNetworkId: '<virtualNetworkId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    inboundEndpoints: [
      {
        name: 'az-pdnsin-x-001'
        subnetId: '<subnetId>'
      }
    ]
    outboundEndpoints: [
      {
        name: 'az-pdnsout-x-001'
        subnetId: '<subnetId>'
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
    "name": {
      "value": "ndrcom001"
    },
    "virtualNetworkId": {
      "value": "<virtualNetworkId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "inboundEndpoints": {
      "value": [
        {
          "name": "az-pdnsin-x-001",
          "subnetId": "<subnetId>"
        }
      ]
    },
    "outboundEndpoints": {
      "value": [
        {
          "name": "az-pdnsout-x-001",
          "subnetId": "<subnetId>"
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
