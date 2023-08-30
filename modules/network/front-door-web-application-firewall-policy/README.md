# Front Door Web Application Firewall (WAF) Policies `[Microsoft.Network/FrontDoorWebApplicationFirewallPolicies]`

This module deploys a Front Door Web Application Firewall (WAF) Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/FrontDoorWebApplicationFirewallPolicies` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/2022-05-01/frontdoorwebapplicationfirewallpolicies?pivots=deployment-language-bicep) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Front Door WAF policy. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `sku` | string | `Premium_AzureFrontDoor` | The pricing tier of the WAF profile. |
| `customRules` | array | `[]` | The custom rules inside the policy. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `global` | Location for all resources. |
| `managedRules` | object | `{object}` | Describes the managedRules structure. |
| `policySettings` | object | `{object}` | The PolicySettings for policy. |
| `tags` | object | `{object}` | Resource tags. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

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
| `name` | string | The name of the front door WAF policy. |
| `resourceGroupName` | string | The resource group the front door WAF policy was deployed into. |
| `resourceId` | string | The resource ID of the front door WAF policy. |

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
module applicationGatewayWebApplicationFirewallPolicy './network/front-door-web-application-firewall-policy/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nfdwafpcom'
  params: {
    // Required parameters
    name: 'nfdwafpcom001'
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
      "value": "nfdwafpcom001"
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
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>
