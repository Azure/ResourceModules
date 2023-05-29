# API Management Service APIs `[Microsoft.ApiManagement/service/apis]`

This module deploys API Management Service APIs.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/policies` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `displayName` | string | API name. Must be 1 to 300 characters long. |
| `name` | string | API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. |
| `path` | string | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiDescription` | string | `''` |  | Description of the API. May include HTML formatting tags. |
| `apiRevision` | string | `''` |  | Describes the Revision of the API. If no value is provided, default revision 1 is created. |
| `apiRevisionDescription` | string | `''` |  | Description of the API Revision. |
| `apiType` | string | `'http'` | `[http, soap]` | Type of API to create. * http creates a SOAP to REST API * soap creates a SOAP pass-through API. |
| `apiVersion` | string | `''` |  | Indicates the Version identifier of the API if the API is versioned. |
| `apiVersionDescription` | string | `''` |  | Description of the API Version. |
| `apiVersionSetId` | string | `''` |  | Indicates the Version identifier of the API version set. |
| `authenticationSettings` | object | `{object}` |  | Collection of authentication settings included into this API. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `format` | string | `'openapi'` | `[openapi, openapi-link, openapi+json, openapi+json-link, swagger-json, swagger-link-json, wadl-link-json, wadl-xml, wsdl, wsdl-link]` | Format of the Content in which the API is getting imported. |
| `isCurrent` | bool | `True` |  | Indicates if API revision is current API revision. |
| `policies` | _[policies](policies/README.md)_ array | `[]` |  | Array of Policies to apply to the Service API. |
| `protocols` | array | `[https]` |  | Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS. |
| `serviceUrl` | string | `''` |  | Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long. |
| `sourceApiId` | string | `''` |  | API identifier of the source API. |
| `subscriptionKeyParameterNames` | object | `{object}` |  | Protocols over which API is made available. |
| `subscriptionRequired` | bool | `False` |  | Specifies whether an API or Product subscription is required for accessing the API. |
| `type` | string | `'http'` | `[http, soap]` | Type of API. |
| `value` | string | `''` |  | Content value when Importing an API. |
| `wsdlSelector` | object | `{object}` |  | Criteria to limit import of WSDL to a subset of the document. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service API. |
| `resourceGroupName` | string | The resource group the API management service API was deployed to. |
| `resourceId` | string | The resource ID of the API management service API. |

## Cross-referenced modules

_None_
