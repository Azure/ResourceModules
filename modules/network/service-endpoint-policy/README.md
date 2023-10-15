# Service Endpoint Policies `[Microsoft.Network/serviceEndpointPolicies]`

This module deploys a Service Endpoint Policy.

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
| `Microsoft.Network/serviceEndpointPolicies` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/serviceEndpointPolicies) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.service-endpoint-policy:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module serviceEndpointPolicy 'br:bicep/modules/network.service-endpoint-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nsnpcom'
  params: {
    // Required parameters
    name: 'nsnpcom-001'
    // Non-required parameters
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
    serviceEndpointPolicyDefinitions: [
      {
        name: 'Storage.ServiceEndpoint'
        properties: {
          description: 'Allow Microsoft.Storage'
          service: 'Microsoft.Storage'
          serviceResources: [
            '<id>'
          ]
        }
        type: 'Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions'
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
    "name": {
      "value": "nsnpcom-001"
    },
    // Non-required parameters
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
    "serviceEndpointPolicyDefinitions": {
      "value": [
        {
          "name": "Storage.ServiceEndpoint",
          "properties": {
            "description": "Allow Microsoft.Storage",
            "service": "Microsoft.Storage",
            "serviceResources": [
              "<id>"
            ]
          },
          "type": "Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions"
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

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module serviceEndpointPolicy 'br:bicep/modules/network.service-endpoint-policy:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nsnpmin'
  params: {
    // Required parameters
    name: 'nsnpmin-001'
    // Non-required parameters
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
    // Required parameters
    "name": {
      "value": "nsnpmin-001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
| [`name`](#parameter-name) | string | The Service Endpoint Policy name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contextualServiceEndpointPolicies`](#parameter-contextualserviceendpointpolicies) | array | An Array of contextual service endpoint policy. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`serviceAlias`](#parameter-servicealias) | string | The alias indicating if the policy belongs to a service. |
| [`serviceEndpointPolicyDefinitions`](#parameter-serviceendpointpolicydefinitions) | array | An Array of service endpoint policy definitions. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `contextualServiceEndpointPolicies`

An Array of contextual service endpoint policy.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

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

The Service Endpoint Policy name.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `serviceAlias`

The alias indicating if the policy belongs to a service.
- Required: No
- Type: string
- Default: `''`

### Parameter: `serviceEndpointPolicyDefinitions`

An Array of service endpoint policy definitions.
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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Service Endpoint Policy. |
| `resourceGroupName` | string | The resource group the Service Endpoint Policy was deployed into. |
| `resourceId` | string | The resource ID of the Service Endpoint Policy. |

## Cross-referenced modules

_None_
