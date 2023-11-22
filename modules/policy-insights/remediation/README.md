# Policy Insights Remediations `[Microsoft.PolicyInsights/remediations]`

This module deploys a Policy Insights Remediation.

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
| `Microsoft.PolicyInsights/remediations` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.PolicyInsights/2021-10-01/remediations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/policy-insights.remediation:1.0.0`.

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
module remediation 'br:bicep/modules/policy-insights.remediation:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pirmgcom'
  params: {
    // Required parameters
    name: 'pirmgcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    failureThresholdPercentage: '0.5'
    filtersLocations: [
      'australiaeast'
    ]
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: '<policyDefinitionReferenceId>'
    resourceCount: 10
    resourceDiscoveryMode: 'ExistingNonCompliant'
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
      "value": "pirmgcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "failureThresholdPercentage": {
      "value": "0.5"
    },
    "filtersLocations": {
      "value": [
        "australiaeast"
      ]
    },
    "location": {
      "value": "<location>"
    },
    "parallelDeployments": {
      "value": 1
    },
    "policyDefinitionReferenceId": {
      "value": "<policyDefinitionReferenceId>"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ExistingNonCompliant"
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
module remediation 'br:bicep/modules/policy-insights.remediation:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pirmgmin'
  params: {
    // Required parameters
    name: 'pirmgmin001'
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
      "value": "pirmgmin001"
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
module remediation 'br:bicep/modules/policy-insights.remediation:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pirrgcom'
  params: {
    // Required parameters
    name: 'pirrgcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    failureThresholdPercentage: '0.5'
    filtersLocations: [
      'australiaeast'
    ]
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: '<policyDefinitionReferenceId>'
    resourceCount: 10
    resourceDiscoveryMode: 'ExistingNonCompliant'
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
      "value": "pirrgcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "failureThresholdPercentage": {
      "value": "0.5"
    },
    "filtersLocations": {
      "value": [
        "australiaeast"
      ]
    },
    "location": {
      "value": "<location>"
    },
    "parallelDeployments": {
      "value": 1
    },
    "policyDefinitionReferenceId": {
      "value": "<policyDefinitionReferenceId>"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ExistingNonCompliant"
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
module remediation 'br:bicep/modules/policy-insights.remediation:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pirrgmin'
  params: {
    // Required parameters
    name: 'pirrgmin001'
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
      "value": "pirrgmin001"
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
module remediation 'br:bicep/modules/policy-insights.remediation:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pirsubcom'
  params: {
    // Required parameters
    name: 'pirsubcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    failureThresholdPercentage: '0.5'
    filtersLocations: [
      'australiaeast'
    ]
    location: '<location>'
    parallelDeployments: 1
    policyDefinitionReferenceId: '<policyDefinitionReferenceId>'
    resourceCount: 10
    resourceDiscoveryMode: 'ExistingNonCompliant'
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
      "value": "pirsubcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "failureThresholdPercentage": {
      "value": "0.5"
    },
    "filtersLocations": {
      "value": [
        "australiaeast"
      ]
    },
    "location": {
      "value": "<location>"
    },
    "parallelDeployments": {
      "value": 1
    },
    "policyDefinitionReferenceId": {
      "value": "<policyDefinitionReferenceId>"
    },
    "resourceCount": {
      "value": 10
    },
    "resourceDiscoveryMode": {
      "value": "ExistingNonCompliant"
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
module remediation 'br:bicep/modules/policy-insights.remediation:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pirsubmin'
  params: {
    // Required parameters
    name: 'pirsubmin001'
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
      "value": "pirsubmin001"
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
| [`name`](#parameter-name) | string | Specifies the name of the policy remediation. |
| [`policyAssignmentId`](#parameter-policyassignmentid) | string | The resource ID of the policy assignment that should be remediated. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`failureThresholdPercentage`](#parameter-failurethresholdpercentage) | string | The remediation failure threshold settings. A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold. 0 means that the remediation will stop after the first failure. 1 means that the remediation will not stop even if all deployments fail. |
| [`filtersLocations`](#parameter-filterslocations) | array | The filters that will be applied to determine which resources to remediate. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The target scope for the remediation. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| [`parallelDeployments`](#parameter-paralleldeployments) | int | Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used. |
| [`policyDefinitionReferenceId`](#parameter-policydefinitionreferenceid) | string | The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition. |
| [`resourceCount`](#parameter-resourcecount) | int | Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used. |
| [`resourceDiscoveryMode`](#parameter-resourcediscoverymode) | string | The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The target scope for the remediation. The name of the resource group for the policy assignment. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The target scope for the remediation. The subscription ID of the subscription for the policy assignment. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `failureThresholdPercentage`

The remediation failure threshold settings. A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold. 0 means that the remediation will stop after the first failure. 1 means that the remediation will not stop even if all deployments fail.
- Required: No
- Type: string
- Default: `'1'`

### Parameter: `filtersLocations`

The filters that will be applied to determine which resources to remediate.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The target scope for the remediation. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `name`

Specifies the name of the policy remediation.
- Required: Yes
- Type: string

### Parameter: `parallelDeployments`

Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used.
- Required: No
- Type: int
- Default: `10`

### Parameter: `policyAssignmentId`

The resource ID of the policy assignment that should be remediated.
- Required: Yes
- Type: string

### Parameter: `policyDefinitionReferenceId`

The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition.
- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceCount`

Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used.
- Required: No
- Type: int
- Default: `500`

### Parameter: `resourceDiscoveryMode`

The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified.
- Required: No
- Type: string
- Default: `'ExistingNonCompliant'`
- Allowed:
  ```Bicep
  [
    'ExistingNonCompliant'
    'ReEvaluateCompliance'
  ]
  ```

### Parameter: `resourceGroupName`

The target scope for the remediation. The name of the resource group for the policy assignment.
- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionId`

The target scope for the remediation. The subscription ID of the subscription for the policy assignment.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remediation. |
| `resourceId` | string | The resource ID of the remediation. |

## Cross-referenced modules

_None_

## Notes

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


### Module Usage Guidance

In general, resources under the `Microsoft.PolicyInsights` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `main.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](main.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/main.bicep'](./subscription/main.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.PolicyInsights` namespace, then you can directly use the sub-module ['/subscription/main.bicep'](./subscription/main.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module remediation 'br:bicepregistry.azurecr.io/bicep/modules/policyinsights.remediations.subscription:version' = {}
```
**Local Path Reference**
```bicep
module remediation 'yourpath/module/Authorization.policyinsights/subscription/main.bicep' = {}
```
