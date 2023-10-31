# Policy Insights Remediations (Subscription scope) `[Microsoft.PolicyInsights/remediations]`

This module deploys a Policy Insights Remediation on a Subscription scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.PolicyInsights/remediations` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.PolicyInsights/2021-10-01/remediations) |

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
| [`parallelDeployments`](#parameter-paralleldeployments) | int | Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used. |
| [`policyDefinitionReferenceId`](#parameter-policydefinitionreferenceid) | string | The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition. |
| [`resourceCount`](#parameter-resourcecount) | int | Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used. |
| [`resourceDiscoveryMode`](#parameter-resourcediscoverymode) | string | The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified. |

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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remediation. |
| `resourceId` | string | The resource ID of the remediation. |

## Cross-referenced modules

_None_
