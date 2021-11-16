# Api Management Service Policies `[Microsoft.ApiManagement/service/policies]`

This module deploys Api Management Service Policy.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/policies` | 2020-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `format` | string | `xml` | `[rawxml, rawxml-link, xml, xml-link]` | Optional. Format of the policyContent. |
| `value` | string |  |  | Required. Contents of the Policy as defined by the format. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `policyName` | string | The name of the API management service policy |
| `policyResourceGroup` | string | The resource group the API management service policy was deployed into |
| `policyResourceId` | string | The resourceId of the API management service policy |

## Template references

- [Service/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/policies)
