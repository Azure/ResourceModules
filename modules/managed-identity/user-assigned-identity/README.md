# User Assigned Identities `[Microsoft.ManagedIdentity/userAssignedIdentities]`

This module deploys a User Assigned Identity.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |

## Parameters

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `federatedIdentityCredentials` | array | `[]` |  | The federated identity credentials list to indicate which token from the external IdP should be trusted by your application. Federated identity credentials are supported on applications only. A maximum of 20 federated identity credentials can be added per application object. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `name` | string | `[guid(resourceGroup().id)]` |  | Name of the User Assigned Identity. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `clientId` | string | The client ID (application ID) of the user assigned identity. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the user assigned identity. |
| `principalId` | string | The principal ID (object ID) of the user assigned identity. |
| `resourceGroupName` | string | The resource group the user assigned identity was deployed into. |
| `resourceId` | string | The resource ID of the user assigned identity. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module userAssignedIdentity './managed-identity/user-assigned-identity/main.bicep' = {
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module userAssignedIdentity './managed-identity/user-assigned-identity/main.bicep' = {
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
