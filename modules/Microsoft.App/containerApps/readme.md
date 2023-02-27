# App ContainerApps `[Microsoft.App/containerApps]`

This module deploys App ContainerApps.
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
| `Microsoft.App/containerApps` | [2022-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2022-06-01-preview/containerApps) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `containerImage` | string | Container image tag. |
| `containerName` | string | Custom container name. |
| `containerResources` | object | Container App resources. |
| `environmentId` | string | Resource ID of environment. |
| `name` | string | Name of the Container App. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `activeRevisionsMode` | string | `'Single'` | `[Multiple, Single]` | ActiveRevisionsMode controls how active revisions are handled for the Container app. |
| `clientCertificateMode` | string | `'ignore'` | `[accept, ignore, require]` | Client certificate mode for mTLS authentication. Ignore indicates server drops client certificate on forwarding. Accept indicates server forwards client certificate but does not require a client certificate. Require indicates server requires a client certificate. |
| `containerArgs` | array | `[]` |  | Container start command arguments. |
| `containersEnv` | array | `[]` |  | Container environment variables. |
| `containerStartCommand` | array | `[]` |  | Container start command. |
| `corsPolicyAllowCredentials` | bool | `False` |  | Cors policy to allow credentials or not. |
| `corsPolicyAllowedHeaders` | array | `[]` |  | Cors policy to allowed HTTP headers. |
| `corsPolicyAllowedMethods` | array | `[]` |  | Cors policy to allowed HTTP methods. |
| `corsPolicyAllowedOrigins` | array | `[]` |  | Cors policy to allowed orgins. |
| `corsPolicyExposeHeaders` | array | `[]` |  | Cors policy to expose HTTP headers. |
| `corsPolicyMaxAge` | int | `0` |  | Cors policy to max time client can cache the result. |
| `dapr` | object | `{object}` |  | Dapr configuration for the Container App. |
| `enableDefaultTelemetry` | bool | `False` |  | Enable telemetry via a Globally Unique Identifier (GUID), default false. |
| `exposedPort` | int | `0` |  | Exposed Port in containers for TCP traffic from ingress. |
| `ingressAllowInsecure` | bool | `True` |  | Bool indicating if HTTP connections to is allowed. If set to false HTTP connections are automatically redirected to HTTPS connections. |
| `ingressExternal` | bool | `True` |  | Bool indicating if app exposes an external http endpoint, default true. |
| `ingressTargetPort` | int | `80` |  | Target Port in containers for traffic from ingress, default 80. |
| `ingressTransport` | string | `'auto'` | `[auto, http, http2, tcp]` | Ingress transport protocol, default auto. |
| `ipSecurityRestrictions` | array | `[]` |  | Rules to restrict incoming IP address. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxInactiveRevisions` | int | `0` |  | Max inactive revisions a Container App can have. |
| `registries` | array | `[]` |  | Collection of private container registry credentials for containers used by the Container app. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute. |
| `scaleMaxReplicas` | int | `1` |  | Maximum number of container replicas. Defaults to 10 if not set. |
| `scaleMinReplicas` | int | `0` |  | Minimum number of container replicas. |
| `scaleRules` | array | `[]` |  | Scaling rules. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `trafficLabel` | string | `'label-1'` |  | Associates a traffic label with a revision. Label name should be consist of lower case alphanumeric characters or dashes. |
| `trafficLatestRevision` | bool | `True` |  | Indicates that the traffic weight belongs to a latest stable revision. |
| `trafficRevisionName` | string | `''` |  | Name of a revision. |
| `trafficWeight` | int | `100` |  | Traffic weight assigned to a revision. |
| `userAssignedIdentities` | object | `{object}` |  | The set of user assigned identities associated with the resource, the userAssignedIdentities dictionary keys will be ARM resource ids and The dictionary values can be empty objects ({}) in requests. |


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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Container Apps name. |
| `resourceGroupName` | string | The name of the resource group the Container Apps was deployed into. |
| `resourceId` | string | The resource ID of the Container Apps. |

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
module containerApps './Microsoft.App/containerApps/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mcappcom'
  params: {
    // Required parameters
    containerImage: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
    containerName: 'simple-hello-world-container'
    containerResources: {
      cpu: '0.25'
      memory: '0.5Gi'
    }
    environmentId: '<environmentId>'
    name: '<<namePrefix>>mcappcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    lock: 'CanNotDelete'
    tags: {
      Env: 'test'
    }
    userAssignedIdentities: {
      '<managedIdentityId>': {}
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
    "containerImage": {
      "value": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
    },
    "containerName": {
      "value": "simple-hello-world-container"
    },
    "containerResources": {
      "value": {
        "cpu": "0.25",
        "memory": "0.5Gi"
      }
    },
    "environmentId": {
      "value": "<environmentId>"
    },
    "name": {
      "value": "<<namePrefix>>mcappcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "tags": {
      "value": {
        "Env": "test"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityId>": {}
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
module containerApps './Microsoft.App/containerApps/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mcappmin'
  params: {
    // Required parameters
    containerImage: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
    containerName: 'simple-hello-world-container'
    containerResources: {
      cpu: '0.25'
      memory: '0.5Gi'
    }
    environmentId: '<environmentId>'
    name: 'khan-mcappmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
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
    "containerImage": {
      "value": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
    },
    "containerName": {
      "value": "simple-hello-world-container"
    },
    "containerResources": {
      "value": {
        "cpu": "0.25",
        "memory": "0.5Gi"
      }
    },
    "environmentId": {
      "value": "<environmentId>"
    },
    "name": {
      "value": "khan-mcappmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
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