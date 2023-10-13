# DevTest Lab Policy Sets Policies `[Microsoft.DevTestLab/labs/policysets/policies]`

This module deploys a DevTest Lab Policy Sets Policy.

DevTest lab policies are used to modify the lab settings such as only allowing certain VM Size SKUs, marketplace image types, number of VMs allowed per user and other settings.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/policysets/policies` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/policysets/policies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `evaluatorType` | string | `[AllowedValuesPolicy, MaxValuePolicy]` | The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy). |
| `factName` | string | `[EnvironmentTemplate, GalleryImage, LabPremiumVmCount, LabTargetCost, LabVmCount, LabVmSize, ScheduleEditPermission, UserOwnedLabPremiumVmCount, UserOwnedLabVmCount, UserOwnedLabVmCountInSubnet]` | The fact name of the policy. |
| `name` | string |  | The name of the policy. |
| `threshold` | string |  | The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy). |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `labName` | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | The description of the policy. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `factData` | string | `''` |  | The fact data of the policy. |
| `policySetName` | string | `'default'` |  | The name of the parent policy set. |
| `status` | string | `'Enabled'` | `[Disabled, Enabled]` | The status of the policy. |
| `tags` | object | `{object}` |  | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the policy. |
| `resourceGroupName` | string | The name of the resource group the policy was created in. |
| `resourceId` | string | The resource ID of the policy. |

## Cross-referenced modules

_None_
