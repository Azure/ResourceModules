# Policy Exemptions (All scopes) `[Microsoft.Authorization/policyExemptions]`

This module deploys a Policy Exemption at a Management Group, Subscription or Resource Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | [2022-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-07-01-preview/policyExemptions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/authorization.policy-exemption:1.0.0`.

- [Mg.Common](#example-1-mgcommon)
- [Mg.Min](#example-2-mgmin)
- [Rg.Common](#example-3-rgcommon)
- [Rg.Min](#example-4-rgmin)
- [Sub.Common](#example-5-subcommon)
- [Sub.Min](#example-6-submin)

### Example 1: _Mg.Common_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br:bicep/modules/authorization.policy-exemption:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apemgcom'
  params: {
    // Required parameters
    name: 'apemgcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: 'My description'
    displayName: '[Display Name] policy exempt (management group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    policyDefinitionReferenceIds: [
      '<policyDefinitionReferenceId>'
    ]
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            in: [
              'westcentralus'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
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
    "name": {
      "value": "apemgcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "My description"
    },
    "displayName": {
      "value": "[Display Name] policy exempt (management group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "exemptionCategory": {
      "value": "Waiver"
    },
    "expiresOn": {
      "value": "2025-10-02T03:57:00Z"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "policyDefinitionReferenceIds": {
      "value": [
        "<policyDefinitionReferenceId>"
      ]
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "TemporaryMitigation",
          "selectors": [
            {
              "in": [
                "westcentralus"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 2: _Mg.Min_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br:bicep/modules/authorization.policy-exemption:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apemgmin'
  params: {
    // Required parameters
    name: 'apemgmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
      "value": "apemgmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
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

### Example 3: _Rg.Common_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br:bicep/modules/authorization.policy-exemption:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apergcom'
  params: {
    // Required parameters
    name: 'apergcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: 'My description'
    displayName: '[Display Name] policy exempt (resource group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    policyDefinitionReferenceIds: [
      '<policyDefinitionReferenceId>'
    ]
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            in: [
              'westcentralus'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
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
    "name": {
      "value": "apergcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "My description"
    },
    "displayName": {
      "value": "[Display Name] policy exempt (resource group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "exemptionCategory": {
      "value": "Waiver"
    },
    "expiresOn": {
      "value": "2025-10-02T03:57:00Z"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "policyDefinitionReferenceIds": {
      "value": [
        "<policyDefinitionReferenceId>"
      ]
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "TemporaryMitigation",
          "selectors": [
            {
              "in": [
                "westcentralus"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 4: _Rg.Min_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br:bicep/modules/authorization.policy-exemption:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apergmin'
  params: {
    // Required parameters
    name: 'apergmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
      "value": "apergmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
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

### Example 5: _Sub.Common_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br:bicep/modules/authorization.policy-exemption:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apesubcom'
  params: {
    // Required parameters
    name: 'apesubcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: 'My description'
    displayName: '[Display Name] policy exempt (subscription scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    policyDefinitionReferenceIds: [
      '<policyDefinitionReferenceId>'
    ]
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            in: [
              'westcentralus'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
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
    "name": {
      "value": "apesubcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "My description"
    },
    "displayName": {
      "value": "[Display Name] policy exempt (subscription scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "exemptionCategory": {
      "value": "Waiver"
    },
    "expiresOn": {
      "value": "2025-10-02T03:57:00Z"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "policyDefinitionReferenceIds": {
      "value": [
        "<policyDefinitionReferenceId>"
      ]
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "TemporaryMitigation",
          "selectors": [
            {
              "in": [
                "westcentralus"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 6: _Sub.Min_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br:bicep/modules/authorization.policy-exemption:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apesubmin'
  params: {
    // Required parameters
    name: 'apesubmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
      "value": "apesubmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
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
| [`name`](#parameter-name) | string | Specifies the name of the policy exemption. Maximum length is 64 characters for management group, subscription and resource group scopes. |
| [`policyAssignmentId`](#parameter-policyassignmentid) | string | The resource ID of the policy assignment that is being exempted. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignmentScopeValidation`](#parameter-assignmentscopevalidation) | string | The option whether validate the exemption is at or under the assignment scope. |
| [`description`](#parameter-description) | string | The description of the policy exemption. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy exemption. Maximum length is 128 characters. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`exemptionCategory`](#parameter-exemptioncategory) | string | The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated. |
| [`expiresOn`](#parameter-expireson) | string | The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The group ID of the management group to be exempted from the policy assignment. If not provided, will use the current scope for deployment. |
| [`metadata`](#parameter-metadata) | object | The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`policyDefinitionReferenceIds`](#parameter-policydefinitionreferenceids) | array | The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter. |

### Parameter: `assignmentScopeValidation`

The option whether validate the exemption is at or under the assignment scope.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Default'
    'DoNotValidate'
  ]
  ```

### Parameter: `description`

The description of the policy exemption.
- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the policy exemption. Maximum length is 128 characters.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `exemptionCategory`

The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.
- Required: No
- Type: string
- Default: `'Mitigated'`
- Allowed:
  ```Bicep
  [
    'Mitigated'
    'Waiver'
  ]
  ```

### Parameter: `expiresOn`

The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.
- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The group ID of the management group to be exempted from the policy assignment. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `metadata`

The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

Specifies the name of the policy exemption. Maximum length is 64 characters for management group, subscription and resource group scopes.
- Required: Yes
- Type: string

### Parameter: `policyAssignmentId`

The resource ID of the policy assignment that is being exempted.
- Required: Yes
- Type: string

### Parameter: `policyDefinitionReferenceIds`

The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `resourceGroupName`

The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter.
- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `subscriptionId`

The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name. |
| `resourceId` | string | Policy Exemption resource ID. |
| `scope` | string | Policy Exemption Scope. |

## Cross-referenced modules

_None_

## Notes

### Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `main.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](main.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/main.bicep'](./subscription/main.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/main.bicep'](./subscription/main.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module policyexemption 'br:bicepregistry.azurecr.io/bicep/modules/authorization.policy-exemption.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policyexemption 'yourpath/module/authorization/policy-exemption/subscription/main.bicep' = {}
```

### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.


<details>

<summary>Parameter JSON format</summary>

```json
"managementGroupId": {
    "value": "contoso-group"
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
managementGroupId: 'contoso-group'
```

</details>
<p>

> `managementGroupId` is an optional parameter. If not provided, the deployment will use the management group defined in the current deployment scope (i.e. `managementGroup().name`).

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
```

</details>
<p>

### Parameter Usage: `resourceGroupName`

To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
    "value": "target-resourceGroup"
}
```

> The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).

### Parameter Usage: `resourceSelectors`

To deploy Resource Selectors, you can apply the following syntax


<details>

<summary>Parameter JSON format</summary>

```json
"resourceSelectors": [
  {
    "name": "TemporaryMitigation",
    "selectors": [
      {
        "kind": "resourceLocation",
        "in": [
          "westcentralus"
        ]
      }
    ]
  }
]
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
resourceSelectors: [
  {
    name: 'TemporaryMitigation'
    selectors: [
      {
        kind: 'resourceLocation'
        in: [
          'westcentralus'
        ]
      }
    ]
  }
]
```

</details>
<p>
