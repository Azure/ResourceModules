# Policy Assignments `[Microsoft.Authorization/policyAssignments]`

With this module you can perform policy assignments across the management group, subscription or resource group scope.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Module Usage Guidance](#Module-Usage-Guidance)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

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
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enforcementMode` | string | `'Default'` | `[Default, DoNotEnforce]` | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| `identity` | string | `'SystemAssigned'` | `[None, SystemAssigned, UserAssigned]` | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[deployment().location]` |  | Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `nonComplianceMessages` | array | `[]` |  | The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | The policy excluded scopes. |
| `parameters` | object | `{object}` |  | Parameters for the policy assignment if needed. |
| `resourceGroupName` | string | `''` |  | The Target Scope for the Policy. The name of the resource group for the policy assignment. |
| `roleDefinitionIds` | array | `[]` |  | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| `subscriptionId` | string | `''` |  | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. |
| `userAssignedIdentityId` | string | `''` |  | The Resource ID for the user assigned identity to assign to the policy assignment. |


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

## Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `deploy.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](deploy.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/deploy.bicep'](./subscription/deploy.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/deploy.bicep'](./subscription/deploy.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module policyassignment 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policyassignments.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policyassignment 'yourpath/modules/Microsoft.Authorization.policyAssignments/subscription/deploy.bicep' = {}
```

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

<h3>Example 1: Mg Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignments './Microsoft.Authorization/policyAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-PolicyAssignments'
  params: {
    // Required parameters
    name: '<<namePrefix>>-min-mg-polAss'
    policyDefinitionID: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
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
      "value": "<<namePrefix>>-min-mg-polAss"
    },
    "policyDefinitionID": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Mg</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignments './Microsoft.Authorization/policyAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-PolicyAssignments'
  params: {
    // Required parameters
    name: '<<namePrefix>>-mg-polAss'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26'
    // Non-required parameters
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'SystemAssigned'
    location: 'australiaeast'
    managementGroupId: '<<managementGroupId>>'
    metadata: {
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg'
    ]
    parameters: {
      tagName: {
        value: 'env'
      }
      tagValue: {
        value: 'prod'
      }
    }
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
      "value": "<<namePrefix>>-mg-polAss"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the management group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the management group scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "SystemAssigned"
    },
    "location": {
      "value": "australiaeast"
    },
    "managementGroupId": {
      "value": "<<managementGroupId>>"
    },
    "metadata": {
      "value": {
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
        "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg"
      ]
    },
    "parameters": {
      "value": {
        "tagName": {
          "value": "env"
        },
        "tagValue": {
          "value": "prod"
        }
      }
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

<h3>Example 3: Rg Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignments './Microsoft.Authorization/policyAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-PolicyAssignments'
  params: {
    // Required parameters
    name: '<<namePrefix>>-min-rg-polAss'
    policyDefinitionID: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    resourceGroupName: 'validation-rg'
    subscriptionId: '<<subscriptionId>>'
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
      "value": "<<namePrefix>>-min-rg-polAss"
    },
    "policyDefinitionID": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "resourceGroupName": {
      "value": "validation-rg"
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>
<p>

<h3>Example 4: Rg</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignments './Microsoft.Authorization/policyAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-PolicyAssignments'
  params: {
    // Required parameters
    name: '<<namePrefix>>-rg-polAss'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26'
    // Non-required parameters
    description: '[Description] Policy Assignment at the resource group scope'
    displayName: '[Display Name] Policy Assignment at the resource group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: 'australiaeast'
    metadata: {
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
    ]
    parameters: {
      tagName: {
        value: 'env'
      }
      tagValue: {
        value: 'prod'
      }
    }
    resourceGroupName: 'validation-rg'
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: '<<subscriptionId>>'
    userAssignedIdentityId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
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
      "value": "<<namePrefix>>-rg-polAss"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the resource group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the resource group scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "australiaeast"
    },
    "metadata": {
      "value": {
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
        "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
      ]
    },
    "parameters": {
      "value": {
        "tagName": {
          "value": "env"
        },
        "tagValue": {
          "value": "prod"
        }
      }
    },
    "resourceGroupName": {
      "value": "validation-rg"
    },
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    },
    "userAssignedIdentityId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Sub Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignments './Microsoft.Authorization/policyAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-PolicyAssignments'
  params: {
    // Required parameters
    name: '<<namePrefix>>-min-sub-polAss'
    policyDefinitionID: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    subscriptionId: '<<subscriptionId>>'
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
      "value": "<<namePrefix>>-min-sub-polAss"
    },
    "policyDefinitionID": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
  }
}
```

</details>
<p>

<h3>Example 6: Sub</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignments './Microsoft.Authorization/policyAssignments/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-PolicyAssignments'
  params: {
    // Required parameters
    name: '<<namePrefix>>-sub-polAss'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26'
    // Non-required parameters
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: 'australiaeast'
    metadata: {
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg'
    ]
    parameters: {
      tagName: {
        value: 'env'
      }
      tagValue: {
        value: 'prod'
      }
    }
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: '<<subscriptionId>>'
    userAssignedIdentityId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
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
      "value": "<<namePrefix>>-sub-polAss"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the subscription scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the subscription scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "australiaeast"
    },
    "metadata": {
      "value": {
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
        "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg"
      ]
    },
    "parameters": {
      "value": {
        "tagName": {
          "value": "env"
        },
        "tagValue": {
          "value": "prod"
        }
      }
    },
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    },
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    },
    "userAssignedIdentityId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
    }
  }
}
```

</details>
<p>
