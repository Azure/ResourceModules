# AVS PrivateClouds ScriptExecutions `[Microsoft.AVS/privateClouds/scriptExecutions]`

This module deploys AVS PrivateClouds ScriptExecutions.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AVS/privateClouds/scriptExecutions` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.AVS/privateClouds/scriptExecutions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the user-invoked script execution resource |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateCloudName` | string | The name of the parent privateClouds. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `failureReason` | string | `''` | Error message if the script was able to run, but if the script itself had errors or powershell threw an exception |
| `hiddenParameters` | array | `[]` | Parameters that will be hidden/not visible to ARM, such as passwords and credentials |
| `namedOutputs` | object | `{object}` | User-defined dictionary. |
| `output` | array | `[]` | Standard output stream from the powershell execution |
| `parameters` | array | `[]` | Parameters the script will accept |
| `retention` | string | `''` | Time to live for the resource. If not provided, will be available for 60 days |
| `scriptCmdletId` | string | `''` | A reference to the script cmdlet resource if user is running a AVS script |
| `timeout` | string | `''` | Time limit for execution |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the scriptExecution. |
| `resourceGroupName` | string | The name of the resource group the scriptExecution was created in. |
| `resourceId` | string | The resource ID of the scriptExecution. |

## Cross-referenced modules

_None_
