# Front Door Web Application Firewall (WAF) Policies `[Microsoft.Network/FrontDoorWebApplicationFirewallPolicies]`

This module deploys a Front Door Web Application Firewall (WAF) Policy.

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
| `Microsoft.Network/FrontDoorWebApplicationFirewallPolicies` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/FrontDoorWebApplicationFirewallPolicies) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.front-door-web-application-firewall-policy:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoorWebApplicationFirewallPolicy 'br:bicep/modules/network.front-door-web-application-firewall-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpcom'
  params: {
    // Required parameters
    name: 'nagwafpcom001'
    // Non-required parameters
    customRules: {
      rules: [
        {
          action: 'Block'
          enabledState: 'Enabled'
          matchConditions: [
            {
              matchValue: [
                'CH'
              ]
              matchVariable: 'RemoteAddr'
              negateCondition: false
              operator: 'GeoMatch'
              selector: '<selector>'
              transforms: []
            }
            {
              matchValue: [
                'windows'
              ]
              matchVariable: 'RequestHeader'
              negateCondition: false
              operator: 'Contains'
              selector: 'UserAgent'
              transforms: []
            }
            {
              matchValue: [
                '?>'
                '<?php'
              ]
              matchVariable: 'QueryString'
              negateCondition: false
              operator: 'Contains'
              transforms: [
                'Lowercase'
                'UrlDecode'
              ]
            }
          ]
          name: 'CustomRule1'
          priority: 2
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 10
          ruleType: 'MatchRule'
        }
      ]
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
        }
      ]
    }
    policySettings: {
      customBlockResponseBody: 'PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=='
      customBlockResponseStatusCode: 200
      mode: 'Prevention'
      redirectUrl: 'http://www.bing.com'
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
    sku: 'Premium_AzureFrontDoor'
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
    "customRules": {
      "value": {
        "rules": [
          {
            "action": "Block",
            "enabledState": "Enabled",
            "matchConditions": [
              {
                "matchValue": [
                  "CH"
                ],
                "matchVariable": "RemoteAddr",
                "negateCondition": false,
                "operator": "GeoMatch",
                "selector": "<selector>",
                "transforms": []
              },
              {
                "matchValue": [
                  "windows"
                ],
                "matchVariable": "RequestHeader",
                "negateCondition": false,
                "operator": "Contains",
                "selector": "UserAgent",
                "transforms": []
              },
              {
                "matchValue": [
                  "?>",
                  "<?php"
                ],
                "matchVariable": "QueryString",
                "negateCondition": false,
                "operator": "Contains",
                "transforms": [
                  "Lowercase",
                  "UrlDecode"
                ]
              }
            ],
            "name": "CustomRule1",
            "priority": 2,
            "rateLimitDurationInMinutes": 1,
            "rateLimitThreshold": 10,
            "ruleType": "MatchRule"
          }
        ]
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "managedRules": {
      "value": {
        "managedRuleSets": [
          {
            "ruleSetType": "Microsoft_BotManagerRuleSet",
            "ruleSetVersion": "1.0"
          }
        ]
      }
    },
    "policySettings": {
      "value": {
        "customBlockResponseBody": "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg==",
        "customBlockResponseStatusCode": 200,
        "mode": "Prevention",
        "redirectUrl": "http://www.bing.com"
      }
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
    "sku": {
      "value": "Premium_AzureFrontDoor"
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

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoorWebApplicationFirewallPolicy 'br:bicep/modules/network.front-door-web-application-firewall-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpmin'
  params: {
    // Required parameters
    name: 'nagwafpmin001'
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
      "value": "nagwafpmin001"
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
| [`name`](#parameter-name) | string | Name of the Front Door WAF policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customRules`](#parameter-customrules) | object | The custom rules inside the policy. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`managedRules`](#parameter-managedrules) | object | Describes the managedRules structure. |
| [`policySettings`](#parameter-policysettings) | object | The PolicySettings for policy. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sku`](#parameter-sku) | string | The pricing tier of the WAF profile. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `customRules`

The custom rules inside the policy.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `'global'`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `managedRules`

Describes the managedRules structure.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `name`

Name of the Front Door WAF policy.
- Required: Yes
- Type: string

### Parameter: `policySettings`

The PolicySettings for policy.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sku`

The pricing tier of the WAF profile.
- Required: No
- Type: string
- Default: `'Standard_AzureFrontDoor'`
- Allowed: `[Premium_AzureFrontDoor, Standard_AzureFrontDoor]`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Front Door WAF policy. |
| `resourceGroupName` | string | The resource group the Front Door WAF policy was deployed into. |
| `resourceId` | string | The resource ID of the Front Door WAF policy. |

## Cross-referenced modules

_None_
