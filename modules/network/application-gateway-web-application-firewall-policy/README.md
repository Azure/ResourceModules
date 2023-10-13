# Application Gateway Web Application Firewall (WAF) Policies `[Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies]`

This module deploys an Application Gateway Web Application Firewall (WAF) Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/ApplicationGatewayWebApplicationFirewallPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Application Gateway WAF policy. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `customRules` | array | `[]` | The custom rules inside the policy. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `managedRules` | object | `{object}` | Describes the managedRules structure. |
| `policySettings` | object | `{object}` | The PolicySettings for policy. |
| `tags` | object | `{object}` | Resource tags. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the application gateway WAF policy. |
| `resourceGroupName` | string | The resource group the application gateway WAF policy was deployed into. |
| `resourceId` | string | The resource ID of the application gateway WAF policy. |

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
module applicationGatewayWebApplicationFirewallPolicy './network/application-gateway-web-application-firewall-policy/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpcom'
  params: {
    // Required parameters
    name: 'nagwafpcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedRules: {
      managedRuleSets: [
        {
          ruleGroupOverrides: []
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleGroupOverrides: []
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
    }
    policySettings: {
      fileUploadLimitInMb: 10
      mode: 'Prevention'
      state: 'Enabled'
    }
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
      "value": "nagwafpcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedRules": {
      "value": {
        "managedRuleSets": [
          {
            "ruleGroupOverrides": [],
            "ruleSetType": "OWASP",
            "ruleSetVersion": "3.2"
          },
          {
            "ruleGroupOverrides": [],
            "ruleSetType": "Microsoft_BotManagerRuleSet",
            "ruleSetVersion": "0.1"
          }
        ]
      }
    },
    "policySettings": {
      "value": {
        "fileUploadLimitInMb": 10,
        "mode": "Prevention",
        "state": "Enabled"
      }
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
