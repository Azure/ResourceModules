# API Management Service Policies `[Microsoft.ApiManagement/service/policies]`

This module deploys API Management Service Policy.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/policies` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `format` | string | `xml` | `[rawxml, rawxml-link, xml, xml-link]` | Optional. Format of the policyContent. |
| `name` | string | `policy` |  | Optional. The name of the policy |
| `value` | string |  |  | Required. Contents of the Policy as defined by the format. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service policy |
| `resourceGroupName` | string | The resource group the API management service policy was deployed into |
| `resourceId` | string | The resource ID of the API management service policy |

## Template references

- [Service/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/policies)
