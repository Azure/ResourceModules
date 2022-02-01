# API Management Service APIs Policies `[Microsoft.ApiManagement/service/apis/policies]`

This module deploys API Management Service APIs policies.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis/policies` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `apiName` | string |  |  | Required. The name of the of the API. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `format` | string | `xml` | `[rawxml, rawxml-link, xml, xml-link]` | Optional. Format of the policyContent. |
| `name` | string | `policy` |  | Optional. The name of the policy |
| `value` | string |  |  | Required. Contents of the Policy as defined by the format. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API policy |
| `resourceGroupName` | string | The resource group the API policy was deployed into |
| `resourceId` | string | The resource ID of the API policy |

## Template references

- [Service/Apis/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies)
