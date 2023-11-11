# App ManagedEnvironments `[Microsoft.App/managedEnvironments]`

This module deploys an App Managed Environment (also known as a Container App Environment).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/managedEnvironments` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2022-10-01/managedEnvironments) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/app.managed-environment:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br:bicep/modules/app.managed-environment:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-amemin'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'amemin001'
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
      "value": "amemin001"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br:bicep/modules/app.managed-environment:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-amemax'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'amemax001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureSubnetId: '<infrastructureSubnetId>'
    internal: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    skuName: 'Consumption'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "amemax001"
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br:bicep/modules/app.managed-environment:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-amewaf'
  params: {
    // Required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'amewaf001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureSubnetId: '<infrastructureSubnetId>'
    internal: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    skuName: 'Consumption'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "amewaf001"
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990). |
| [`name`](#parameter-name) | string | Name of the Container Apps Managed Environment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`infrastructureSubnetId`](#parameter-infrastructuresubnetid) | string | Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificatePassword`](#parameter-certificatepassword) | securestring | Password of the certificate used by the custom domain. |
| [`certificateValue`](#parameter-certificatevalue) | securestring | Certificate to use for the custom domain. PFX or PEM. |
| [`daprAIConnectionString`](#parameter-dapraiconnectionstring) | securestring | Application Insights connection string used by Dapr to export Service to Service communication telemetry. |
| [`daprAIInstrumentationKey`](#parameter-dapraiinstrumentationkey) | securestring | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | DNS suffix for the environment domain. |
| [`dockerBridgeCidr`](#parameter-dockerbridgecidr) | string | CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`internal`](#parameter-internal) | bool | Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logsDestination`](#parameter-logsdestination) | string | Logs destination. |
| [`platformReservedCidr`](#parameter-platformreservedcidr) | string | IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. |
| [`platformReservedDnsIP`](#parameter-platformreserveddnsip) | string | An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`skuName`](#parameter-skuname) | string | Managed environment SKU. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`workloadProfiles`](#parameter-workloadprofiles) | array | Workload profiles configured for the Managed Environment. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this Managed Environment is zone-redundant. |

### Parameter: `certificatePassword`

Password of the certificate used by the custom domain.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `certificateValue`

Certificate to use for the custom domain. PFX or PEM.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIConnectionString`

Application Insights connection string used by Dapr to export Service to Service communication telemetry.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIInstrumentationKey`

Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `dnsSuffix`

DNS suffix for the environment domain.
- Required: No
- Type: string
- Default: `''`

### Parameter: `dockerBridgeCidr`

CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: Yes
- Type: bool

### Parameter: `infrastructureSubnetId`

Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true.
- Required: No
- Type: string
- Default: `''`

### Parameter: `internal`

Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided.
- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `logAnalyticsWorkspaceResourceId`

Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).
- Required: Yes
- Type: string

### Parameter: `logsDestination`

Logs destination.
- Required: No
- Type: string
- Default: `'log-analytics'`

### Parameter: `name`

Name of the Container Apps Managed Environment.
- Required: Yes
- Type: string

### Parameter: `platformReservedCidr`

IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform.
- Required: No
- Type: string
- Default: `''`

### Parameter: `platformReservedDnsIP`

An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
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

Optional. The Resource Id of the delegated managed identity resource.

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

### Parameter: `skuName`

Managed environment SKU.
- Required: No
- Type: string
- Default: `'Consumption'`
- Allowed:
  ```Bicep
  [
    'Consumption'
    'Premium'
  ]
  ```

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `workloadProfiles`

Workload profiles configured for the Managed Environment.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `zoneRedundant`

Whether or not this Managed Environment is zone-redundant.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Managed Environment. |
| `resourceGroupName` | string | The name of the resource group the Managed Environment was deployed into. |
| `resourceId` | string | The resource ID of the Managed Environment. |

## Cross-referenced modules

_None_
