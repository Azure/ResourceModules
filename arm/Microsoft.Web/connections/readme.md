# API Connections `[Microsoft.Web/connections]`

This module deploys an Azure API connection.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Web/connections` | 2016-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `connectionKind` | string | Connection Kind. Example: 'V1' when using blobs. It can change depending on the resource. |
| `displayName` | string | Display name connection. Example: 'blobconnection' when using blobs. It can change depending on the resource. |
| `name` | string | Connection name for connection. Example: 'azureblob' when using blobs.  It can change depending on the resource. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `alternativeParameterValues` | object | `{object}` |  | Alternative parameter values. |
| `connectionApi` | object | `{object}` |  | Specific values for some API connections. |
| `customParameterValues` | object | `{object}` |  | Customized parameter values for specific connections. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location of the deployment. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `nonSecretParameterValues` | object | `{object}` |  | Dictionary of nonsecret parameter values. |
| `parameterValues` | secureObject | `{object}` |  | Connection strings or access keys for connection. Example: 'accountName' and 'accessKey' when using blobs.  It can change depending on the resource. |
| `parameterValueType` | string | `''` |  | Value Type of parameter, in case alternativeParameterValues is used. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `statuses` | array | `[]` |  | Status of the connection. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `testLinks` | array | `[]` |  | Links to test the API connection. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

### Parameter Usage: `connectionApi`

```json
"connectionApi": {
    "value": {
        "id": "string",
        "type": "string",
        "swagger": {},
        "brandColor": "string",
        "description": "string",
        "displayName": "string",
        "iconUri": "string",
        "name": "string"
    }
}
```

### Parameter Usage: `statuses`

```json
"statuses": {
    "value": [
      {
        "status": "string",
        "target": "string",
        "error": {
          "location": "string",
          "tags": {},
          "properties": {
            "code": "string",
            "message": "string"
          }
        }
      }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

### Parameter Usage: `testLinks`

```json
"testLinks": {
    "value":[
      {
        "requestUri": "string",
        "method": "string"
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the connection |
| `resourceGroupName` | string | The resource group the connection was deployed into |
| `resourceId` | string | The resource ID of the connection |

## Template references

- [Connections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2016-06-01/connections)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
