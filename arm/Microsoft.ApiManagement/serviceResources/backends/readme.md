# Api Management Service Backends `[Microsoft.ApiManagement/serviceResources/backends]`

This module deploys Api Management Service Backends.

## Resource types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/backends` | 2020-06-01-preview |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters
| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `backendDescription` | string |  |  | Optional. Backend Description. |
| `backendName` | string |  |  | Required. Backend Name. |
| `credentials` | object | `{object}` |  | Optional. Backend Credentials Contract Properties. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `protocol` | string | `http` |  | Required. Backend communication protocol. - http or soap |
| `proxy` | object | `{object}` |  | Optional. Backend Proxy Contract Properties |
| `resourceId` | string |  |  | Optional. Management Uri of the Resource in External System. This url can be the Arm Resource Id of Logic Apps, Function Apps or Api Apps. |
| `serviceFabricCluster` | object | `{object}` |  | Optional. Backend Service Fabric Cluster Properties. |
| `title` | string |  |  | Optional. Backend Title. |
| `tls` | object | `{object}` |  | Optional. Backend TLS Properties |
| `url` | string |  |  | Required. Runtime Url of the Backend. |

### Parameters - credentials

| Parameter Name                         | Type   | Default Value              | Possible values | Description                                                                                                                                                                                                                                                                                                 |
| :------------------------------------- | :----- | :------------------------- | :-------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `certificate`             | array |                            |                 | Optional. List of Client Certificate Thumbprint. - string|
| `query`                          | object |                            |                 | Optional. Query Parameter description.|
| `header`                             | object |  |                 | Optional. Header Parameter description.|
| `authorization`                                | object |                            |                 | Optional. Authorization header authentication|


### Parameter Usage: `credentials`

Product API's name list.

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

### Parameters - proxy

| Parameter Name                         | Type   | Default Value              | Possible values | Description                                                                                                                                                                                                                                                                                                 |
| :------------------------------------- | :----- | :------------------------- | :-------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `url`             | string |                            |                 | WebProxy Server AbsoluteUri property which includes the entire URI stored in the Uri instance, including all fragments and query strings.|
| `username`                          | string |                            |                 |Username to connect to the WebProxy server|
| `password`                             | string |  |                 | Password to connect to the WebProxy Server|


### Parameter Usage: `proxy`

Product API's name list.

```json
"proxy": {
    "value":{
        "url": "string",
        "username": "string",
        "password": "string"
    }
}
```

### Parameters - serviceFabricCluster

| Parameter Name                         | Type   | Default Value              | Possible values | Description                                                                                                                                                                                                                                                                                                 |
| :------------------------------------- | :----- | :------------------------- | :-------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `clientCertificatethumbprint`             | string |                            |                 | Required (if this object is used).The client certificate thumbprint for the management endpoint.|
| `maxPartitionResolutionRetries`                          | integer |                            |                 |Optional. Maximum number of retries while attempting resolve the partition.|
| `managementEndpoints`                             | array |  |                 | Required (if this object is used). The cluster management endpoint. - string|
| `serverCertificateThumbprints`                             | array |  |                 | Optional. Thumbprints of certificates cluster management service uses for tls communication - string|
| `serverX509Names`                             | array |  |                 | Optional. Server X509 Certificate Names Collection|


### Parameter Usage: `serviceFabricCluster`

Product API's name list.

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

Product API's name list.

```json
"tls": {
    "value":{
        "validateCertificateChain": "Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. - boolean",
        "validateCertificateName": "Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. - boolean"
    }
}
```

## Outputs
| Output Name | Type |
| :-- | :-- |
| `backendResourceGroup` | string |
| `backendResourceId` | string |
| `backendResourceName` | string |

## Template references
- [Service/Backends](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/backends)
