# API Connection `[Microsoft.Web/connections]`

This module deploys an Azure API Connection.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Web/connections` | 2016-06-01 |
| `Microsoft.Web/connections/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `alternativeParameterValues` | object | `{object}` |  | Optional. Alternative parameter values. |
| `connectionApi` | object | `{object}` |  | Optional. Specific values for some API connections. |
| `connectionKind` | string |  |  | Required. Connection Kind. Example: 'V1' when using blobs. It can change depending on the resource. |
| `connectionName` | string |  |  | Required. Connection name for connection. Example: 'azureblob' when using blobs.  It can change depending on the resource. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |
| `customParameterValues` | object | `{object}` |  | Optional. Customized parameter values for specific connections. |
| `displayName` | string |  |  | Required. Display name connection. Example: 'blobconnection' when using blobs. It can change depending on the resource. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location of the deployment. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `nonSecretParameterValues` | object | `{object}` |  | Optional. Dictionary of nonsecret parameter values. |
| `parameterValues` | secureObject | `{object}` |  | Optional. Connection strings or access keys for connection. Example: 'accountName' and 'accessKey' when using blobs.  It can change depending on the resource. |
| `parameterValueType` | string |  |  | Optional. Value Type of parameter, in case alternativeParameterValues is used. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `statuses` | array | `[]` |  | Optional. Status of the connection. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `testLinks` | array | `[]` |  | Optional. Links to test the API connection. |

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

| Output Name | Type |
| :-- | :-- |
| `connectionName` | string |
| `connectionResourceGroup` | string |
| `connectionResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Connections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2016-06-01/connections)
