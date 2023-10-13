# Dns Forwarding Rulesets `[Microsoft.Network/dnsForwardingRulesets]`

This template deploys an dns forwarding ruleset.

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
| `Microsoft.Network/dnsForwardingRulesets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets) |
| `Microsoft.Network/dnsForwardingRulesets/forwardingRules` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/forwardingRules) |
| `Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/virtualNetworkLinks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `dnsResolverOutboundEndpointResourceIds` | array | The reference to the DNS resolver outbound endpoints that are used to route DNS queries matching the forwarding rules in the ruleset to the target DNS servers. |
| `name` | string | Name of the DNS Forwarding Ruleset. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forwardingRules` | array | `[]` |  | Array of forwarding rules. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vNetLinks` | array | `[]` |  | Array of virtual network links. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the DNS Forwarding Ruleset. |
| `resourceGroupName` | string | The resource group the DNS Forwarding Ruleset was deployed into. |
| `resourceId` | string | The resource ID of the DNS Forwarding Ruleset. |

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
module dnsForwardingRuleset './network/dns-forwarding-ruleset/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ndfrscom'
  params: {
    // Required parameters
    dnsResolverOutboundEndpointResourceIds: [
      '<dnsResolverOutboundEndpointsId>'
    ]
    name: 'ndfrscom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    forwardingRules: [
      {
        domainName: 'contoso.'
        forwardingRuleState: 'Enabled'
        name: 'rule1'
        targetDnsServers: [
          {
            ipAddress: '192.168.0.1'
            port: '53'
          }
        ]
      }
    ]
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
    vNetLinks: [
      '<virtualNetworkResourceId>'
    ]
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
    "dnsResolverOutboundEndpointResourceIds": {
      "value": [
        "<dnsResolverOutboundEndpointsId>"
      ]
    },
    "name": {
      "value": "ndfrscom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "forwardingRules": {
      "value": [
        {
          "domainName": "contoso.",
          "forwardingRuleState": "Enabled",
          "name": "rule1",
          "targetDnsServers": [
            {
              "ipAddress": "192.168.0.1",
              "port": "53"
            }
          ]
        }
      ]
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
    },
    "vNetLinks": {
      "value": [
        "<virtualNetworkResourceId>"
      ]
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
module dnsForwardingRuleset './network/dns-forwarding-ruleset/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ndfrsmin'
  params: {
    // Required parameters
    dnsResolverOutboundEndpointResourceIds: [
      '<dnsResolverOutboundEndpointsResourceId>'
    ]
    name: 'ndfrsmin001'
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
    "dnsResolverOutboundEndpointResourceIds": {
      "value": [
        "<dnsResolverOutboundEndpointsResourceId>"
      ]
    },
    "name": {
      "value": "ndfrsmin001"
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
