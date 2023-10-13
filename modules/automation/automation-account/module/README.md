# Automation Account Modules `[Microsoft.Automation/automationAccounts/modules]`

This module deploys an Azure Automation Account Module.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/modules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/modules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Automation Account module. |
| `uri` | string | Module package URI, e.g. https://www.powershellgallery.com/api/v2/package. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `automationAccountName` | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `tags` | object | `{object}` | Tags of the Automation Account resource. |
| `version` | string | `'latest'` | Module version or specify latest to get the latest version. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed module. |
| `resourceGroupName` | string | The resource group of the deployed module. |
| `resourceId` | string | The resource ID of the deployed module. |

## Cross-referenced modules

_None_
