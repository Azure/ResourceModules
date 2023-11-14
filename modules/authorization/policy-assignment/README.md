# Policy Assignments (All scopes) `[Microsoft.Authorization/policyAssignments]`

This module deploys a Policy Assignment at a Management Group, Subscription or Resource Group scope.

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
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/authorization.policy-assignment:1.0.0`.

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
module policyAssignment 'br:bicep/modules/authorization.policy-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-apamgcom'
  params: {
    // Required parameters
    name: 'apamgcom001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enforcementMode: 'DoNotEnforce'
    identity: 'SystemAssigned'
    location: '<location>'
    managementGroupId: '<managementGroupId>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        selectors: [
          {
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
            kind: 'policyDefinitionReferenceId'
          }
        ]
        value: 'Disabled'
      }
    ]
    parameters: {
      effect: {
        value: 'Disabled'
      }
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
    }
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
            kind: 'resourceType'
          }
          {
            in: [
              'westeurope'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
    ]
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
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
      "value": "apamgcom001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the management group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the management group scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "SystemAssigned"
    },
    "location": {
      "value": "<location>"
    },
    "managementGroupId": {
      "value": "<managementGroupId>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "nonComplianceMessages": {
      "value": [
        {
          "message": "Violated Policy Assignment - This is a Non Compliance Message"
        }
      ]
    },
    "notScopes": {
      "value": [
        "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg"
      ]
    },
    "overrides": {
      "value": [
        {
          "kind": "policyEffect",
          "selectors": [
            {
              "in": [
                "ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent",
                "ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent"
              ],
              "kind": "policyDefinitionReferenceId"
            }
          ],
          "value": "Disabled"
        }
      ]
    },
    "parameters": {
      "value": {
        "effect": {
          "value": "Disabled"
        },
        "enableCollectionOfSqlQueriesForSecurityResearch": {
          "value": false
        }
      }
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "resourceSelector-test",
          "selectors": [
            {
              "in": [
                "Microsoft.Compute/virtualMachines"
              ],
              "kind": "resourceType"
            },
            {
              "in": [
                "westeurope"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    },
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
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
module policyAssignment 'br:bicep/modules/authorization.policy-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apamgmin'
  params: {
    // Required parameters
    name: 'apamgmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      assignedBy: 'Bicep'
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
      "value": "apamgmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep"
      }
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
module policyAssignment 'br:bicep/modules/authorization.policy-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apargcom'
  params: {
    // Required parameters
    name: 'apargcom001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    description: '[Description] Policy Assignment at the resource group scope'
    displayName: '[Display Name] Policy Assignment at the resource group scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '<keyVaultResourceId>'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        selectors: [
          {
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
            kind: 'policyDefinitionReferenceId'
          }
        ]
        value: 'Disabled'
      }
    ]
    parameters: {
      effect: {
        value: 'Disabled'
      }
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
    }
    resourceGroupName: '<resourceGroupName>'
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
            kind: 'resourceType'
          }
          {
            in: [
              'westeurope'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
    ]
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: '<subscriptionId>'
    userAssignedIdentityId: '<userAssignedIdentityId>'
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
      "value": "apargcom001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the resource group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the resource group scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "nonComplianceMessages": {
      "value": [
        {
          "message": "Violated Policy Assignment - This is a Non Compliance Message"
        }
      ]
    },
    "notScopes": {
      "value": [
        "<keyVaultResourceId>"
      ]
    },
    "overrides": {
      "value": [
        {
          "kind": "policyEffect",
          "selectors": [
            {
              "in": [
                "ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent",
                "ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent"
              ],
              "kind": "policyDefinitionReferenceId"
            }
          ],
          "value": "Disabled"
        }
      ]
    },
    "parameters": {
      "value": {
        "effect": {
          "value": "Disabled"
        },
        "enableCollectionOfSqlQueriesForSecurityResearch": {
          "value": false
        }
      }
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "resourceSelector-test",
          "selectors": [
            {
              "in": [
                "Microsoft.Compute/virtualMachines"
              ],
              "kind": "resourceType"
            },
            {
              "in": [
                "westeurope"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    },
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    },
    "userAssignedIdentityId": {
      "value": "<userAssignedIdentityId>"
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
module policyAssignment 'br:bicep/modules/authorization.policy-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apargmin'
  params: {
    // Required parameters
    name: 'apargmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      assignedBy: 'Bicep'
    }
    subscriptionId: '<subscriptionId>'
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
      "value": "apargmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep"
      }
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
module policyAssignment 'br:bicep/modules/authorization.policy-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apasubcom'
  params: {
    // Required parameters
    name: 'apasubcom001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        selectors: [
          {
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
            kind: 'policyDefinitionReferenceId'
          }
        ]
        value: 'Disabled'
      }
    ]
    parameters: {
      effect: {
        value: 'Disabled'
      }
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
    }
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
            kind: 'resourceType'
          }
          {
            in: [
              'westeurope'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
    ]
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: '<subscriptionId>'
    userAssignedIdentityId: '<userAssignedIdentityId>'
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
      "value": "apasubcom001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the subscription scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the subscription scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "nonComplianceMessages": {
      "value": [
        {
          "message": "Violated Policy Assignment - This is a Non Compliance Message"
        }
      ]
    },
    "notScopes": {
      "value": [
        "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg"
      ]
    },
    "overrides": {
      "value": [
        {
          "kind": "policyEffect",
          "selectors": [
            {
              "in": [
                "ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent",
                "ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent"
              ],
              "kind": "policyDefinitionReferenceId"
            }
          ],
          "value": "Disabled"
        }
      ]
    },
    "parameters": {
      "value": {
        "effect": {
          "value": "Disabled"
        },
        "enableCollectionOfSqlQueriesForSecurityResearch": {
          "value": false
        }
      }
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "resourceSelector-test",
          "selectors": [
            {
              "in": [
                "Microsoft.Compute/virtualMachines"
              ],
              "kind": "resourceType"
            },
            {
              "in": [
                "westeurope"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    },
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    },
    "userAssignedIdentityId": {
      "value": "<userAssignedIdentityId>"
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
module policyAssignment 'br:bicep/modules/authorization.policy-assignment:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-apasubmin'
  params: {
    // Required parameters
    name: 'apasubmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    subscriptionId: '<subscriptionId>'
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
      "value": "apasubmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
| [`name`](#parameter-name) | string | Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes. |
| [`policyDefinitionId`](#parameter-policydefinitionid) | string | Specifies the ID of the policy definition or policy set definition being assigned. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | This message will be part of response in case of policy violation. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy assignment. Maximum length is 128 characters. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enforcementMode`](#parameter-enforcementmode) | string | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| [`identity`](#parameter-identity) | string | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| [`metadata`](#parameter-metadata) | object | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`nonComplianceMessages`](#parameter-noncompliancemessages) | array | The messages that describe why a resource is non-compliant with the policy. |
| [`notScopes`](#parameter-notscopes) | array | The policy excluded scopes. |
| [`overrides`](#parameter-overrides) | array | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| [`parameters`](#parameter-parameters) | object | Parameters for the policy assignment if needed. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The Target Scope for the Policy. The name of the resource group for the policy assignment. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| [`roleDefinitionIds`](#parameter-roledefinitionids) | array | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. |
| [`userAssignedIdentityId`](#parameter-userassignedidentityid) | string | The Resource ID for the user assigned identity to assign to the policy assignment. |

### Parameter: `description`

This message will be part of response in case of policy violation.
- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the policy assignment. Maximum length is 128 characters.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enforcementMode`

The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce.
- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'DoNotEnforce'
  ]
  ```

### Parameter: `identity`

The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions.
- Required: No
- Type: string
- Default: `'SystemAssigned'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `metadata`

The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes.
- Required: Yes
- Type: string

### Parameter: `nonComplianceMessages`

The messages that describe why a resource is non-compliant with the policy.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `notScopes`

The policy excluded scopes.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `overrides`

The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `parameters`

Parameters for the policy assignment if needed.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `policyDefinitionId`

Specifies the ID of the policy definition or policy set definition being assigned.
- Required: Yes
- Type: string

### Parameter: `resourceGroupName`

The Target Scope for the Policy. The name of the resource group for the policy assignment.
- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleDefinitionIds`

The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `subscriptionId`

The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment.
- Required: No
- Type: string
- Default: `''`

### Parameter: `userAssignedIdentityId`

The Resource ID for the user assigned identity to assign to the policy assignment.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `principalId` | string | Policy Assignment principal ID. |
| `resourceId` | string | Policy Assignment resource ID. |

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
module policyassignment 'br:bicepregistry.azurecr.io/bicep/modules/authorization.policy-assignment.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policyassignment 'yourpath/module/authorization/policy-assignment/subscription/main.bicep' = {}
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

<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
    "value": "target-resourceGroup"
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
resourceGroupName: 'target-resourceGroup'
```

</details>
<p>

> The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).
