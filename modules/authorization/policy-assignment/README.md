# Policy Assignments (All scopes) `[Microsoft.Authorization/policyAssignments]`

This module deploys a Policy Assignment at a Management Group, Subscription or Resource Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes. |
| `policyDefinitionId` | string | Specifies the ID of the policy definition or policy set definition being assigned. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | This message will be part of response in case of policy violation. |
| `displayName` | string | `''` |  | The display name of the policy assignment. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enforcementMode` | string | `'Default'` | `[Default, DoNotEnforce]` | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| `identity` | string | `'SystemAssigned'` | `[None, SystemAssigned, UserAssigned]` | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[deployment().location]` |  | Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `nonComplianceMessages` | array | `[]` |  | The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | The policy excluded scopes. |
| `overrides` | array | `[]` |  | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| `parameters` | object | `{object}` |  | Parameters for the policy assignment if needed. |
| `resourceGroupName` | string | `''` |  | The Target Scope for the Policy. The name of the resource group for the policy assignment. |
| `resourceSelectors` | array | `[]` |  | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| `roleDefinitionIds` | array | `[]` |  | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| `subscriptionId` | string | `''` |  | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. |
| `userAssignedIdentityId` | string | `''` |  | The Resource ID for the user assigned identity to assign to the policy assignment. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `principalId` | string | Policy Assignment principal ID. |
| `resourceId` | string | Policy Assignment resource ID. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Mg.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment './authorization/policy-assignment/main.bicep' = {
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

<h3>Example 2: Mg.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment './authorization/policy-assignment/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apamgmin'
  params: {
    // Required parameters
    name: 'apamgmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
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
    "description": {
      "value": "[Description] Policy Assignment at the management group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the management group scope"
    },
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

<h3>Example 3: Rg.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment './authorization/policy-assignment/main.bicep' = {
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

<h3>Example 4: Rg.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment './authorization/policy-assignment/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apargmin'
  params: {
    // Required parameters
    name: 'apargmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    description: '[Description] Policy Assignment at the resource group scope'
    displayName: '[Display Name] Policy Assignment at the resource group scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "description": {
      "value": "[Description] Policy Assignment at the resource group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the resource group scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Sub.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment './authorization/policy-assignment/main.bicep' = {
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

<h3>Example 6: Sub.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment './authorization/policy-assignment/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apasubmin'
  params: {
    // Required parameters
    name: 'apasubmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
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
    "description": {
      "value": "[Description] Policy Assignment at the subscription scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the subscription scope"
    },
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
