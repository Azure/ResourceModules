# PolicyInsights Remediations ManagementGroup `[Microsoft.PolicyInsights/remediations/managementGroup]`

This module deploys PolicyInsights Remediations ManagementGroup.

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

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy remediation. |
| `policyAssignmentId` | string | The resource ID of the policy assignment that should be remediated. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `failureThresholdPercentage` | string | `'1'` |  | The remediation failure threshold settings. A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold. 0 means that the remediation will stop after the first failure. 1 means that the remediation will not stop even if all deployments fail. |
| `filtersLocations` | array | `[]` |  | The filters that will be applied to determine which resources to remediate. |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `parallelDeployments` | int | `10` |  | Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used. |
| `policyDefinitionReferenceId` | string | `''` |  | The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition. |
| `resourceCount` | int | `500` |  | Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used. |
| `resourceDiscoveryMode` | string | `'ExistingNonCompliant'` | `[ExistingNonCompliant, ReEvaluateCompliance]` | The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remediation. |
| `resourceId` | string | The resource ID of the remediation. |

## Cross-referenced modules

_None_
