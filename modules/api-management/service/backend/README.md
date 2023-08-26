# API Management Service Backends `[Microsoft.ApiManagement/service/backends]`

This module deploys an API Management Service Backend.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/backends` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/backends) |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Backend Name. |
| `url` | string | Runtime URL of the Backend. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `credentials` | object | `{object}` | Backend Credentials Contract Properties. |
| `description` | string | `''` | Backend Description. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `protocol` | string | `'http'` | Backend communication protocol. - http or soap. |
| `proxy` | object | `{object}` | Backend Proxy Contract Properties. |
| `resourceId` | string | `''` | Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. |
| `serviceFabricCluster` | object | `{object}` | Backend Service Fabric Cluster Properties. |
| `title` | string | `''` | Backend Title. |
| `tls` | object | `{object}` | Backend TLS Properties. |


### Parameter Usage: Credentials

| Parameter Name| Type | Default Value  | Possible values | Description |
| :-- | :-- | :--- | :-- | :- |
| `certificate` | array | | | Optional. List of Client Certificate Thumbprint. - string |
| `query`  | object | | | Optional. Query Parameter description. |
| `header` | object | | | Optional. Header Parameter description. |
| `authorization` | object | | | Optional. Authorization header authentication |

### Parameter Usage: `credentials`

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
credentials: {
    certificate: [
        'string'
    ]
    query: {}
    header: {}
    authorization: {
        scheme: 'Authentication Scheme name.-string'
        parameter: 'Authentication Parameter value. - string'
    }
}
```

</details>
<p>

### Parameter Usage: `tls`

<details>

<summary>Parameter JSON format</summary>

```json
"tls": {
    "value":{
        "validateCertificateChain": "Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. - boolean",
        "validateCertificateName": "Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. - boolean"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tls: {
    validateCertificateChain: 'Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. - boolean'
    validateCertificateName: 'Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. - boolean'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service backend. |
| `resourceGroupName` | string | The resource group the API management service backend was deployed into. |
| `resourceId` | string | The resource ID of the API management service backend. |

## Cross-referenced modules

_None_
