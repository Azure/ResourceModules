# Container App Jobs `[Microsoft.App/jobs]`

This module deploys a Container App Job.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/jobs` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-05-01/jobs) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/app.job:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module job 'br:bicep/modules/app.job:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mcajcom'
  params: {
    // Required parameters
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'simple-hello-world-container'
        probes: [
          {
            httpGet: {
              httpHeaders: [
                {
                  name: 'Custom-Header'
                  value: 'Awesome'
                }
              ]
              path: '/health'
              port: 8080
            }
            initialDelaySeconds: 3
            periodSeconds: 3
            type: 'Liveness'
          }
        ]
        resources: {
          cpu: '<cpu>'
          memory: '0.5Gi'
        }
      }
    ]
    environmentId: '<environmentId>'
    name: 'mcajcom001'
    triggerType: 'Manual'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    manualTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
    }
    secrets: {
      secureList: [
        {
          name: 'customtest'
          value: '<value>'
        }
      ]
    }
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    workloadProfileName: '<workloadProfileName>'
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
    "containers": {
      "value": [
        {
          "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",
          "name": "simple-hello-world-container",
          "probes": [
            {
              "httpGet": {
                "httpHeaders": [
                  {
                    "name": "Custom-Header",
                    "value": "Awesome"
                  }
                ],
                "path": "/health",
                "port": 8080
              },
              "initialDelaySeconds": 3,
              "periodSeconds": 3,
              "type": "Liveness"
            }
          ],
          "resources": {
            "cpu": "<cpu>",
            "memory": "0.5Gi"
          }
        }
      ]
    },
    "environmentId": {
      "value": "<environmentId>"
    },
    "name": {
      "value": "mcajcom001"
    },
    "triggerType": {
      "value": "Manual"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "manualTriggerConfig": {
      "value": {
        "parallelism": 1,
        "replicaCompletionCount": 1
      }
    },
    "secrets": {
      "value": {
        "secureList": [
          {
            "name": "customtest",
            "value": "<value>"
          }
        ]
      }
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "workloadProfileName": {
      "value": "<workloadProfileName>"
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
module job 'br:bicep/modules/app.job:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mcajmin'
  params: {
    // Required parameters
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'simple-hello-world-container'
        resources: {
          cpu: '<cpu>'
          memory: '0.5Gi'
        }
      }
    ]
    environmentId: '<environmentId>'
    name: 'mcajmin001'
    triggerType: 'Manual'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    manualTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
    }
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
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
    "containers": {
      "value": [
        {
          "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",
          "name": "simple-hello-world-container",
          "resources": {
            "cpu": "<cpu>",
            "memory": "0.5Gi"
          }
        }
      ]
    },
    "environmentId": {
      "value": "<environmentId>"
    },
    "name": {
      "value": "mcajmin001"
    },
    "triggerType": {
      "value": "Manual"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "manualTriggerConfig": {
      "value": {
        "parallelism": 1,
        "replicaCompletionCount": 1
      }
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
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
| [`containers`](#parameter-containers) | array | List of container definitions for the Container App. |
| [`environmentId`](#parameter-environmentid) | string | Resource ID of environment. |
| [`name`](#parameter-name) | string | Name of the Container App. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`eventTriggerConfig`](#parameter-eventtriggerconfig) | object | Required if TriggerType is Event. Configuration of an event driven job. |
| [`initContainersTemplate`](#parameter-initcontainerstemplate) | array | List of specialized containers that run before app containers. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`manualTriggerConfig`](#parameter-manualtriggerconfig) | object | Required if TriggerType is Manual. Configuration of a manual job. |
| [`registries`](#parameter-registries) | array | Collection of private container registry credentials for containers used by the Container app. |
| [`replicaRetryLimit`](#parameter-replicaretrylimit) | int | The maximum number of times a replica can be retried. |
| [`replicaTimeout`](#parameter-replicatimeout) | int | Maximum number of seconds a replica is allowed to run. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute. |
| [`scheduleTriggerConfig`](#parameter-scheduletriggerconfig) | object | Required if TriggerType is Schedule. Configuration of a schedule based job. |
| [`secrets`](#parameter-secrets) | secureObject | The secrets of the Container App. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`triggerType`](#parameter-triggertype) | string | Trigger type of the job. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The set of user assigned identities associated with the resource, the userAssignedIdentities dictionary keys will be ARM resource IDs and The dictionary values can be empty objects ({}) in requests. |
| [`volumes`](#parameter-volumes) | array | List of volume definitions for the Container App. |
| [`workloadProfileName`](#parameter-workloadprofilename) | string | The name of the workload profile to use. |

### Parameter: `containers`

List of container definitions for the Container App.
- Required: Yes
- Type: array

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentId`

Resource ID of environment.
- Required: Yes
- Type: string

### Parameter: `eventTriggerConfig`

Required if TriggerType is Event. Configuration of an event driven job.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `initContainersTemplate`

List of specialized containers that run before app containers.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all Resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `manualTriggerConfig`

Required if TriggerType is Manual. Configuration of a manual job.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `name`

Name of the Container App.
- Required: Yes
- Type: string

### Parameter: `registries`

Collection of private container registry credentials for containers used by the Container app.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `replicaRetryLimit`

The maximum number of times a replica can be retried.
- Required: No
- Type: int
- Default: `0`

### Parameter: `replicaTimeout`

Maximum number of seconds a replica is allowed to run.
- Required: No
- Type: int
- Default: `1800`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource ID of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource ID of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `scheduleTriggerConfig`

Required if TriggerType is Schedule. Configuration of a schedule based job.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `secrets`

The secrets of the Container App.
- Required: No
- Type: secureObject
- Default: `{object}`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `triggerType`

Trigger type of the job.
- Required: Yes
- Type: string
- Allowed: `[Event, Manual, Schedule]`

### Parameter: `userAssignedIdentities`

The set of user assigned identities associated with the resource, the userAssignedIdentities dictionary keys will be ARM resource IDs and The dictionary values can be empty objects ({}) in requests.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `volumes`

List of volume definitions for the Container App.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `workloadProfileName`

The name of the workload profile to use.
- Required: No
- Type: string
- Default: `'Consumption'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Container App Job. |
| `resourceGroupName` | string | The name of the resource group the Container App Job was deployed into. |
| `resourceId` | string | The resource ID of the Container App Job. |

## Cross-referenced modules

_None_
