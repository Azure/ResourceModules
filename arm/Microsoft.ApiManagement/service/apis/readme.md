# API Management Service APIs `[Microsoft.ApiManagement/service/apis]`

This module deploys API Management Service APIs.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis` | 2021-08-01 |
| `Microsoft.ApiManagement/service/apis/policies` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiDescription` | string |  |  | Optional. Description of the API. May include HTML formatting tags. |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `apiRevision` | string |  |  | Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created |
| `apiRevisionDescription` | string |  |  | Optional. Description of the API Revision. |
| `apiType` | string | `http` | `[http, soap]` | Optional. Type of API to create. * http creates a SOAP to REST API * soap creates a SOAP pass-through API. |
| `apiVersion` | string |  |  | Optional. Indicates the Version identifier of the API if the API is versioned |
| `apiVersionDescription` | string |  |  | Optional. Description of the API Version. |
| `apiVersionSetId` | string |  |  | Optional. Indicates the Version identifier of the API version set |
| `authenticationSettings` | object | `{object}` |  | Optional. Collection of authentication settings included into this API. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `displayName` | string |  |  | Required. API name. Must be 1 to 300 characters long. |
| `format` | string | `openapi` | `[wadl-xml, wadl-link-json, swagger-json, swagger-link-json, wsdl, wsdl-link, openapi, openapi+json, openapi-link, openapi+json-link]` | Optional. Format of the Content in which the API is getting imported. |
| `isCurrent` | bool | `True` |  | Optional. Indicates if API revision is current API revision. |
| `name` | string |  |  | Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. |
| `path` | string |  |  | Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |
| `policies` | _[policies](policies/readme.md)_ array | `[]` |  | Optional. Array of Policies to apply to the Service API. |
| `protocols` | array | `[https]` |  | Optional. Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS |
| `serviceUrl` | string |  |  | Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long. |
| `sourceApiId` | string |  |  | Optional. API identifier of the source API. |
| `subscriptionKeyParameterNames` | object | `{object}` |  | Optional. Protocols over which API is made available. |
| `subscriptionRequired` | bool |  |  | Optional. Specifies whether an API or Product subscription is required for accessing the API. |
| `type` | string | `http` | `[http, soap]` | Optional. Type of API. |
| `value` | string |  |  | Optional. Content value when Importing an API. |
| `wsdlSelector` | object | `{object}` |  | Optional. Criteria to limit import of WSDL to a subset of the document. |

### Parameter Usage: `apiVersionSet`

```json
"apiVersionSet":{
    "value":{
        "name":"", //Required. API Version Set identifier. Must be unique in the current API Management service instance.
        "properties":{
            "description": "string", //Description of API Version Set.
            "versionQueryName": "string", //Optional. Name of query parameter that indicates the API Version if versioningScheme is set to query.
            "versionHeaderName": "string", //Optional. Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.
            "displayName": "string", //Required. Name of API Version Set
            "versioningScheme": "string" //Required. An value that determines where the API Version identifer will be located in a HTTP request. - Segment, Query, Header
        }
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service API |
| `resourceGroupName` | string | The resource group the API management service API was deployed to |
| `resourceId` | string | The resource ID of the API management service API |

## Template references

- [Service/Apis](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis)
- [Service/Apis/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies)
