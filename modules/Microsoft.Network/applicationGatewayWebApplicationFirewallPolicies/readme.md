# `[Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies]`

This module deploys .
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-01-01/ApplicationGatewayWebApplicationFirewallPolicies) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Application Gateway WAF policy. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `customRules` | array | `[]` | The custom rules inside the policy. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `managedRules` | object | `{object}` | Describes the managedRules structure. |
| `policySettings` | object | `{object}` | The PolicySettings for policy. |
| `tags` | object | `{object}` | Resource tags. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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
| `name` | string | The name of the application gateway WAF policy. |
| `resourceGroupName` | string | The resource group the application gateway WAF policy was deployed into. |
| `resourceId` | string | The resource ID of the application gateway WAF policy. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module applicationGatewayWebApplicationFirewallPolicies './Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-ApplicationGatewayWebApplicationFirewallPolicies'
  params: {
    // Required parameters
    name: '<<namePrefix>>-az-apgwpolicy-x-001'
    // Non-required parameters
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
      "value": "<<namePrefix>>-az-apgwpolicy-x-001"
    },
    // Non-required parameters
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
    }
  }
}
```

</details>
<p>
