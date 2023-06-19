# App ManagedEnvironments `[Microsoft.App/managedEnvironments]`

This module deploys an App Managed Environment (also known as a Container App Environment).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/managedEnvironments` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2022-10-01/managedEnvironments) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsWorkspaceResourceId` | string | Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990). |
| `name` | string | Name of the Container Apps Managed Environment. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `infrastructureSubnetId` | string | `''` | Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `certificatePassword` | securestring | `''` |  | Password of the certificate used by the custom domain. |
| `certificateValue` | securestring | `''` |  | Certificate to use for the custom domain. PFX or PEM. |
| `daprAIConnectionString` | securestring | `''` |  | Application Insights connection string used by Dapr to export Service to Service communication telemetry. |
| `daprAIInstrumentationKey` | securestring | `''` |  | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| `dnsSuffix` | string | `''` |  | DNS suffix for the environment domain. |
| `dockerBridgeCidr` | string | `''` |  | CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. |
| `enableDefaultTelemetry` | bool |  |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `internal` | bool | `False` |  | Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `logsDestination` | string | `'log-analytics'` |  | Logs destination. |
| `platformReservedCidr` | string | `''` |  | IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. |
| `platformReservedDnsIP` | string | `''` |  | An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `skuName` | string | `'Consumption'` | `[Consumption, Premium]` | Managed environment SKU. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `workloadProfiles` | array | `[]` |  | Workload profiles configured for the Managed Environment. |
| `zoneRedundant` | bool | `False` |  | Whether or not this Managed Environment is zone-redundant. |


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

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Managed Environment. |
| `resourceGroupName` | string | The name of the resource group the Managed Environment was deployed into. |
| `resourceId` | string | The resource ID of the Managed Environment. |

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
module managedEnvironments './app/managed-environments/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-amecom'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: '<<namePrefix>>amecom001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureSubnetId: '<infrastructureSubnetId>'
    internal: true
    location: '<location>'
    lock: 'CanNotDelete'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    skuName: 'Consumption'
    tags: {
      Env: 'test'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "<<namePrefix>>amecom001"
    },
    // Non-required parameters
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureSubnetId": {
      "value": "<infrastructureSubnetId>"
    },
    "internal": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "skuName": {
      "value": "Consumption"
    },
    "tags": {
      "value": {
        "Env": "test"
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
module managedEnvironments './app/managed-environments/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-amemin'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: '<<namePrefix>>amemin001'
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "<<namePrefix>>amemin001"
    }
  }
}
```

</details>
<p>
