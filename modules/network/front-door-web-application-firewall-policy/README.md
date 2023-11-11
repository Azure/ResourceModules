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

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.front-door-web-application-firewall-policy:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoorWebApplicationFirewallPolicy 'br:bicep/modules/network.front-door-web-application-firewall-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpmax'
  params: {
    // Required parameters
    name: 'nagwafpmax001'
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
        principalId: '<principalId>'
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
      "value": "nagwafpmax001"
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
          "principalId": "<principalId>",
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoorWebApplicationFirewallPolicy 'br:bicep/modules/network.front-door-web-application-firewall-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwafpwaf'
  params: {
    // Required parameters
    name: 'nagwafpwaf001'
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
        principalId: '<principalId>'
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
      "value": "nagwafpwaf001"
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
          "principalId": "<principalId>",
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
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedRules`](#parameter-managedrules) | object | Describes the managedRules structure. |
| [`policySettings`](#parameter-policysettings) | object | The PolicySettings for policy. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sku`](#parameter-sku) | string | The pricing tier of the WAF profile. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `customRules`

The custom rules inside the policy.
- Required: No
- Type: object
- Default:
  ```Bicep
  {
      rules: [
        {
          action: 'Block'
          enabledState: 'Enabled'
          matchConditions: [
            {
              matchValue: [
                'ZZ'
              ]
              matchVariable: 'RemoteAddr'
              negateCondition: true
              operator: 'GeoMatch'
            }
          ]
          name: 'ApplyGeoFilter'
          priority: 100
          ruleType: 'MatchRule'
        }
      ]
  }
  ```

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

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedRules`

Describes the managedRules structure.
- Required: No
- Type: object
- Default:
  ```Bicep
  {
      managedRuleSets: [
        {
          exclusions: []
          ruleGroupOverrides: []
          ruleSetAction: 'Block'
          ruleSetType: 'Microsoft_DefaultRuleSet'
          ruleSetVersion: '2.1'
        }
        {
          exclusions: []
          ruleGroupOverrides: []
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
        }
      ]
  }
  ```

### Parameter: `name`

Name of the Front Door WAF policy.
- Required: Yes
- Type: string

### Parameter: `policySettings`

The PolicySettings for policy.
- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabledState: 'Enabled'
      mode: 'Prevention'
  }
  ```

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `sku`

The pricing tier of the WAF profile.
- Required: No
- Type: string
- Default: `'Standard_AzureFrontDoor'`
- Allowed:
  ```Bicep
  [
    'Premium_AzureFrontDoor'
    'Standard_AzureFrontDoor'
  ]
  ```

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Front Door WAF policy. |
| `resourceGroupName` | string | The resource group the Front Door WAF policy was deployed into. |
| `resourceId` | string | The resource ID of the Front Door WAF policy. |

## Cross-referenced modules

_None_
