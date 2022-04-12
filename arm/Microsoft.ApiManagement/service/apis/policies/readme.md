# API Management Service APIs Policies `[Microsoft.ApiManagement/service/apis/policies]`

This module deploys API Management Service APIs policies.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis/policies` | 2021-08-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the of the API Management service. |
| `apiName` | string | The name of the of the API. |
| `value` | string | Contents of the Policy as defined by the format. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `format` | string | `'xml'` | `[rawxml, rawxml-link, xml, xml-link]` | Format of the policyContent. |
| `name` | string | `'policy'` |  | The name of the policy |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API policy |
| `resourceGroupName` | string | The resource group the API policy was deployed into |
| `resourceId` | string | The resource ID of the API policy |

## Template references

- [Service/Apis/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies)
