# API Management Service Authorization Servers `[Microsoft.ApiManagement/service/authorizationServers]`

This module deploys API Management Service Authorization Servers.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/authorizationServers` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `authorizationEndpoint` | string |  |  | Required. OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>. |
| `authorizationMethods` | array | `[GET]` |  | Optional. HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE |
| `bearerTokenSendingMethods` | array | `[authorizationHeader]` |  | Optional. Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query |
| `clientAuthenticationMethod` | array | `[Basic]` |  | Optional. Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body |
| `clientId` | secureString |  |  | Required. Client or app ID registered with this authorization server. |
| `clientRegistrationEndpoint` | string |  |  | Optional. Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced. |
| `clientSecret` | secureString |  |  | Required. Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `defaultScope` | string |  |  | Optional. Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values. |
| `grantTypes` | array |  |  | Required. Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials |
| `name` | string |  |  | Required. Identifier of the authorization server. |
| `resourceOwnerPassword` | string |  |  | Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password. |
| `resourceOwnerUsername` | string |  |  | Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username. |
| `serverDescription` | string |  |  | Optional. Description of the authorization server. Can contain HTML formatting tags. |
| `supportState` | bool |  |  | Optional. If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security. |
| `tokenBodyParameters` | array | `[]` |  | Optional. Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object |
| `tokenEndpoint` | string |  |  | Optional. OAuth token endpoint. Contains absolute URI to entity being referenced. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service authorization server |
| `resourceGroupName` | string | The resource group the API management service authorization server was deployed into |
| `resourceId` | string | The resource ID of the API management service authorization server |

## Template references

- [Service/Authorizationservers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/authorizationServers)
