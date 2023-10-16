# User Assigned Identities `[Microsoft.ManagedIdentity/userAssignedIdentities]`

This module deploys a User Assigned Identity.

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
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/managed-identity.user-assigned-identity:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module userAssignedIdentity 'br:bicep/modules/managed-identity.user-assigned-identity:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-miuaicom'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    federatedIdentityCredentials: [
      {
        audiences: [
          'api://AzureADTokenExchange'
        ]
        issuer: '<issuer>'
        name: 'test-fed-cred-miuaicom-001'
        subject: 'system:serviceaccount:default:workload-identity-sa'
      }
    ]
    lock: 'CanNotDelete'
    name: 'miuaicom001'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "federatedIdentityCredentials": {
      "value": [
        {
          "audiences": [
            "api://AzureADTokenExchange"
          ],
          "issuer": "<issuer>",
          "name": "test-fed-cred-miuaicom-001",
          "subject": "system:serviceaccount:default:workload-identity-sa"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "name": {
      "value": "miuaicom001"
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module userAssignedIdentity 'br:bicep/modules/managed-identity.user-assigned-identity:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-miuaimin'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>


## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`federatedIdentityCredentials`](#parameter-federatedidentitycredentials) | array | The federated identity credentials list to indicate which token from the external IdP should be trusted by your application. Federated identity credentials are supported on applications only. A maximum of 20 federated identity credentials can be added per application object. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`name`](#parameter-name) | string | Name of the User Assigned Identity. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `federatedIdentityCredentials`

The federated identity credentials list to indicate which token from the external IdP should be trusted by your application. Federated identity credentials are supported on applications only. A maximum of 20 federated identity credentials can be added per application object.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
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

Name of the User Assigned Identity.
- Required: No
- Type: string
- Default: `[guid(resourceGroup().id)]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `clientId` | string | The client ID (application ID) of the user assigned identity. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the user assigned identity. |
| `principalId` | string | The principal ID (object ID) of the user assigned identity. |
| `resourceGroupName` | string | The resource group the user assigned identity was deployed into. |
| `resourceId` | string | The resource ID of the user assigned identity. |

## Cross-referenced modules

_None_
