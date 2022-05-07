# API Management Service Policies `[Microsoft.ApiManagement/service/policies]`

This module deploys API Management Service Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/policies` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/policies) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `value` | string | Contents of the Policy as defined by the format. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `format` | string | `'xml'` | `[rawxml, rawxml-link, xml, xml-link]` | Format of the policyContent. |
| `name` | string | `'policy'` |  | The name of the policy. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service policy. |
| `resourceGroupName` | string | The resource group the API management service policy was deployed into. |
| `resourceId` | string | The resource ID of the API management service policy. |
