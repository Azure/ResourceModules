# API Connections `[Microsoft.Web/connections]`

This module deploys an Azure API Connection.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Web/connections` | [2016-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2016-06-01/connections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/web.connection:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module connection 'br:bicep/modules/web.connection:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-wccom'
  params: {
    // Required parameters
    displayName: 'azuremonitorlogs'
    name: 'azuremonitor'
    // Non-required parameters
    api: {
      id: '<id>'
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "displayName": {
      "value": "azuremonitorlogs"
    },
    "name": {
      "value": "azuremonitor"
    },
    // Non-required parameters
    "api": {
      "value": {
        "id": "<id>"
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Display name connection. Example: 'blobconnection' when using blobs. It can change depending on the resource. |
| [`name`](#parameter-name) | string | Connection name for connection. Example: 'azureblob' when using blobs.  It can change depending on the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`api`](#parameter-api) | object | Specific values for some API connections. |
| [`customParameterValues`](#parameter-customparametervalues) | object | Customized parameter values for specific connections. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location of the deployment. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`nonSecretParameterValues`](#parameter-nonsecretparametervalues) | object | Dictionary of nonsecret parameter values. |
| [`parameterValues`](#parameter-parametervalues) | secureObject | Connection strings or access keys for connection. Example: 'accountName' and 'accessKey' when using blobs.  It can change depending on the resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`statuses`](#parameter-statuses) | array | Status of the connection. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`testLinks`](#parameter-testlinks) | array | Links to test the API connection. |

### Parameter: `api`

Specific values for some API connections.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `customParameterValues`

Customized parameter values for specific connections.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `displayName`

Display name connection. Example: 'blobconnection' when using blobs. It can change depending on the resource.
- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location of the deployment.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Connection name for connection. Example: 'azureblob' when using blobs.  It can change depending on the resource.
- Required: Yes
- Type: string

### Parameter: `nonSecretParameterValues`

Dictionary of nonsecret parameter values.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `parameterValues`

Connection strings or access keys for connection. Example: 'accountName' and 'accessKey' when using blobs.  It can change depending on the resource.
- Required: No
- Type: secureObject
- Default: `{object}`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `statuses`

Status of the connection.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `testLinks`

Links to test the API connection.
- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the connection. |
| `resourceGroupName` | string | The resource group the connection was deployed into. |
| `resourceId` | string | The resource ID of the connection. |

## Cross-referenced modules

_None_
