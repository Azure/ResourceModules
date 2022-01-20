# API Management Service Backends `[Microsoft.ApiManagement/service/backends]`

This module deploys API Management Service Backends.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/backends` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `backendDescription` | string |  |  | Optional. Backend Description. |
| `credentials` | object | `{object}` |  | Optional. Backend Credentials Contract Properties. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Backend Name. |
| `protocol` | string | `http` |  | Optional. Backend communication protocol. - http or soap |
| `proxy` | object | `{object}` |  | Optional. Backend Proxy Contract Properties |
| `resourceId` | string |  |  | Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. |
| `serviceFabricCluster` | object | `{object}` |  | Optional. Backend Service Fabric Cluster Properties. |
| `title` | string |  |  | Optional. Backend Title. |
| `tls` | object | `{object}` |  | Optional. Backend TLS Properties |
| `url` | string |  |  | Required. Runtime URL of the Backend. |

### Parameters - credentials

| Parameter Name| Type | Default Value  | Possible values | Description |
| :-- | :-- | :--- | :-- | :- |
| `certificate` | array | | | Optional. List of Client Certificate Thumbprint. - string |
| `query`  | object | | | Optional. Query Parameter description. |
| `header` | object | | | Optional. Header Parameter description. |
| `authorization` | object | | | Optional. Authorization header authentication |

### Parameter Usage: `credentials`

```json
"credentials": {
    "value":{
        "certificate": [
            "string"
        ],
        "query": {},
        "header": {},
        "authorization": {
            "scheme": "Authentication Scheme name.-string",
            "parameter": "Authentication Parameter value. - string"
        }
    }
}
```

### Parameter Usage: `proxy`

| Parameter Name | Type | Default Value | Possible values | Description |
| :- | :- | :- | :- | :- |
| `url` | string | | | WebProxy Server AbsoluteUri property which includes the entire URI stored in the URI instance, including all fragments and query strings.|
| `username` | string | | | Username to connect to the WebProxy server|
| `password`| string | | | Password to connect to the WebProxy Server|

```json
"proxy": {
    "value":{
        "url": "string",
        "username": "string",
        "password": "string"
    }
}
```

### Parameter Usage: `serviceFabricCluster`

| Parameter Name  | Type | Default Value | Possible values | Description |
| :-- | :-- | :--- | :-- | :- |
| `clientCertificatethumbprint` | string | | | Required (if this object is used).The client certificate thumbprint for the management endpoint.|
| `maxPartitionResolutionRetries` | integer | | | Optional. Maximum number of retries while attempting resolve the partition. |
| `managementEndpoints` | array | | | Required (if this object is used). The cluster management endpoint. - string|
| `serverCertificateThumbprints`| array | | | Optional. Thumbprints of certificates cluster management service uses for TLS communication - string|
| `serverX509Names` | array | | | Optional. Server X509 Certificate Names Collection|

```json
"serviceFabricCluster": {
    "value":{
        "clientCertificatethumbprint": "string",
        "maxPartitionResolutionRetries": "integer",
        "managementEndpoints": [
          "string"
        ],
        "serverCertificateThumbprints": [
          "string"
        ],
        "serverX509Names": [
          {
            "name": "Common Name of the Certificate.- string",
            "issuerCertificateThumbprint": "Thumbprint for the Issuer of the Certificate. - string"
          }
        ]
    }
}
```

### Parameter Usage: `tls`

```json
"tls": {
    "value":{
        "validateCertificateChain": "Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. - boolean",
        "validateCertificateName": "Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. - boolean"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service backend |
| `resourceGroupName` | string | The resource group the API management service backend was deployed into |
| `resourceId` | string | The resource ID of the API management service backend |

## Template references

- [Service/Backends](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/backends)
