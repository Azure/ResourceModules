# API Management Service API Version Sets `[Microsoft.ApiManagement/service/apiVersionSets]`

This module deploys API Management Service APIs Version Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apiVersionSets` | 2021-08-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the of the API Management service. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'default'` | API Version set name |
| `properties` | object | `{object}` | API Version set properties |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API Version set |
| `resourceGroupName` | string | The resource group the API Version set was deployed into |
| `resourceId` | string | The resource ID of the API Version set |

## Template references

- [Service/Apiversionsets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apiVersionSets)
