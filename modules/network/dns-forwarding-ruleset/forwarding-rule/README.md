# Dns Forwarding Rulesets Forwarding Rules `[Microsoft.Network/dnsForwardingRulesets/forwardingRules]`

This template deploys Forwarding Rule in a Dns Forwarding Ruleset.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/dnsForwardingRulesets/forwardingRules` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/forwardingRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `domainName` | string | The domain name for the forwarding rule. |
| `name` | string | Name of the Forwarding Rule. |
| `targetDnsServers` | array | DNS servers to forward the DNS query to. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `dnsForwardingRulesetName` | string | Name of the parent DNS Forwarding Ruleset. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forwardingRuleState` | string | `'Enabled'` | `[Disabled, Enabled]` | The state of forwarding rule. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `metadata` | object | `{object}` |  | Metadata attached to the forwarding rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Forwarding Rule. |
| `resourceGroupName` | string | The resource group the Forwarding Rule was deployed into. |
| `resourceId` | string | The resource ID of the Forwarding Rule. |

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
module dnsForwardingRulesets './Microsoft.Network/dnsForwardingRulesets/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ndfrscom'
  params: {
    // Required parameters
    dnsResolverOutboundEndpointId: '<dnsResolverOutboundEndpointId>'
    name: '[[namePrefix]]ndfrscom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    tags: {
      Environment: 'Non-Prod'
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
    "dnsResolverOutboundEndpointId": {
      "value": "<dnsResolverOutboundEndpointId>"
    },
    "name": {
      "value": "[[namePrefix]]ndfrscom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>
