# API Management Service APIs Policies `[Microsoft.ApiManagement/service/apis/policies]`

This module deploys an API Management Service API Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis/policies` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `value` | string | Contents of the Policy as defined by the format. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| `apiName` | string | The name of the parent API. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `format` | string | `'xml'` | `[rawxml, rawxml-link, xml, xml-link]` | Format of the policyContent. |
| `name` | string | `'policy'` |  | The name of the policy. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API policy. |
| `resourceGroupName` | string | The resource group the API policy was deployed into. |
| `resourceId` | string | The resource ID of the API policy. |

## Cross-referenced modules

_None_
