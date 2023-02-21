# App ManagedEnvironments `[Microsoft.App/managedEnvironments]`

This module deploys App ManagedEnvironments.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/managedEnvironments` | [2022-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.App/2022-06-01-preview/managedEnvironments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalticsWorkspaceName` | string | Existing Log Analytics Workspace name. |
| `name` | string | Environment name for Container Apps. |
| `resourceGroupLAWorkspace` | string | Existing resource group name of the Log Analytics Workspace . |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool |  |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `logsDestination` | string | `'log-analytics'` |  | Logs destination. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `skuName` | string | `'Consumption'` | `[Consumption, Premium]` | Managed environment Sku. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceName` | string | The name of the Log analytics workspace name. |
| `name` | string | Managed Envrionment Name. |
| `resourceGroupName` | string | The name of the resource group the Container Apps was deployed into. |
| `resourceId` | string | Managed environment ID. |

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
module managedEnvironments './Microsoft.App/managedEnvironments/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mcappcom'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalticsWorkspaceName: '<logAnalticsWorkspaceName>'
    name: 'dep-<<namePrefix>>-menv-mcappcom001'
    resourceGroupLAWorkspace: '<resourceGroupLAWorkspace>'
    // Non-required parameters
    infrastructureSubnetId: '<infrastructureSubnetId>'
    location: '<location>'
    skuName: 'Consumption'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "logAnalticsWorkspaceName": {
      "value": "<logAnalticsWorkspaceName>"
    },
    "name": {
      "value": "dep-<<namePrefix>>-menv-mcappcom001"
    },
    "resourceGroupLAWorkspace": {
      "value": "<resourceGroupLAWorkspace>"
    },
    // Non-required parameters
    "infrastructureSubnetId": {
      "value": "<infrastructureSubnetId>"
    },
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "Consumption"
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
module managedEnvironments './Microsoft.App/managedEnvironments/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mcapp'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalticsWorkspaceName: '<logAnalticsWorkspaceName>'
    name: '<<namePrefix>>--menv-mcapp001'
    resourceGroupLAWorkspace: '<resourceGroupLAWorkspace>'
    // Non-required parameters
    location: '<location>'
    logsDestination: 'log-analytics'
    skuName: 'Consumption'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "logAnalticsWorkspaceName": {
      "value": "<logAnalticsWorkspaceName>"
    },
    "name": {
      "value": "<<namePrefix>>--menv-mcapp001"
    },
    "resourceGroupLAWorkspace": {
      "value": "<resourceGroupLAWorkspace>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "logsDestination": {
      "value": "log-analytics"
    },
    "skuName": {
      "value": "Consumption"
    }
  }
}
```

</details>
<p>
