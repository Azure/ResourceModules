# API Connection

This module deploys an Azure API Connection.

## Resource types

| Resource Type                                        | Api Version        |
| ---------------------------------------------------- | ------------------ |
| `Microsoft.Resources/deployments`                    | 2020-06-01         |
| `Microsoft.Web/connections`                          | 2016-06-01         |
| `Microsoft.Web/connection/providers/roleAssignments` | 2018-09-01-preview |

## Parameters

| Parameter Name               | Type         | Description                                                                                                                                                                                                                                                                                      | DefaultValue             | Possible values                         |
| ---------------------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------ | --------------------------------------- |
| `alternativeParameterValues` | object       | **Optional**. Alternative parameter values.                                                                                                                                                                                                                                                      | System.Object            |                                         |
| `connectionApi`              | object       | **Optional**. Specific values for some API connections.                                                                                                                                                                                                                                          | System.Object            | Complex structure, see below.           |
| `connectionKind`             | string       | **Required**. Connection Kind. Example: 'V1' when using blobs.  It can change depending on the resource.                                                                                                                                                                                         |                          |                                         |
| `connectionName`             | string       | **Required**. Connection name for connection. Example: 'azureblob' when using blobs.  It can change depending on the resource.                                                                                                                                                                   |                          |                                         |
| `cuaId`                      | string       | **Optional**. Customer Usage Attribution id (GUID). This GUID must be previously registered.                                                                                                                                                                                                     |                          |                                         |
| `customParameterValues`      | object       | **Optional**. Customized parameter values for specific connections                                                                                                                                                                                                                               | System.Object            | Complex structure, see below.           |
| `displayName`                | string       | **Required**. Display name connection. Example: 'blobconnection' when using blobs. It can change depending on the resource.                                                                                                                                                                      |                          |                                         |
| `location`                   | string       | **Optional**. Location of the deployment.                                                                                                                                                                                                                                                        | resourceGroup().location |                                         |
| `nonSecretParameterValues`   | object       | **Optional**. Dictionary of nonsecret parameter values.                                                                                                                                                                                                                                          | System.Object            |                                         |
| `parameterValues`            | secureobject | **Optional**. Connection strings or access keys for connection. Example: 'accountName' and 'accessKey' when using blobs.  It can change depending on the resource.                                                                                                                               | System.Object            |                                         |
| `parameterValueType`         | string       | **Optional**. Value Type of parameter, in case alternativeParameterValues is used.                                                                                                                                                                                                               |                          | "Alternative"                           |
| `roleAssignments`            | array        | **Optional**. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID. | System.Object[]          | Array of complex structures, see below. |
| `statuses`                   | array        | **Optional**. Status of the connection.                                                                                                                                                                                                                                                          | System.Object[]          | Array of complex structures, see below. |
| `tags`                       | object       | **Optional**. Tags of the resource.                                                                                                                                                                                                                                                              | System.Object            | Complex structure, see below.           |
| `testLinks`                  | array        | **Optional**. Links to test the API connection.                                                                                                                                                                                                                                                  | System.Object[]          | Array of complex structures, see below. |

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

| Output Name               | Type   | Description                                                       |
| ------------------------- | ------ | ----------------------------------------------------------------- |
| `connectionResourceId`    | string | The Resource Id of the API Connection.                            |
| `connectionResourceGroup` | string | The name of the Resource Group the API Connection was created in. |
| `connectionName`          | string | The Name of the API Connection.                                   |

## Considerations

- _None_

## Additional resources

- [Microsoft.Logic workflows template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/connections?tabs=json)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
