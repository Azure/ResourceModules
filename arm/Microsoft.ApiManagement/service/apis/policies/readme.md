# ApimanagementServiceApisPolicies `[Microsoft.ApiManagement/service/apis/policies]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis/policies` | 2020-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `apiName` | string |  |  | Required. The name of the of the Api. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `format` | string | `xml` | `[rawxml, rawxml-link, xml, xml-link]` | Optional. Format of the policyContent. |
| `value` | string |  |  | Required. Contents of the Policy as defined by the format. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `policyName` | string | The name of the API policy |
| `policyResourceGroup` | string | The resource group the API policy was deployed into |
| `policyResourceId` | string | The resourceId of the API policy |

## Template references

- [Service/Apis/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/apis/policies)
