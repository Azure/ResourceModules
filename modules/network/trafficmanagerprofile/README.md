# Traffic Manager Profiles `[Microsoft.Network/trafficmanagerprofiles]`

This module deploys a Traffic Manager Profile.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/trafficmanagerprofiles` | [2018-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-08-01/trafficmanagerprofiles) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.trafficmanagerprofile:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module trafficmanagerprofile 'br:bicep/modules/network.trafficmanagerprofile:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ntmpcom'
  params: {
    // Required parameters
    name: '<name>'
    relativeName: '<relativeName>'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
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
    "name": {
      "value": "<name>"
    },
    "relativeName": {
      "value": "<relativeName>"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module trafficmanagerprofile 'br:bicep/modules/network.trafficmanagerprofile:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ntmpmin'
  params: {
    // Required parameters
    name: '<name>'
    relativeName: '<relativeName>'
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
      "value": "<name>"
    },
    "relativeName": {
      "value": "<relativeName>"
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
| [`name`](#parameter-name) | string | Name of the Traffic Manager. |
| [`relativeName`](#parameter-relativename) | string | The relative DNS name provided by this Traffic Manager profile. This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`endpoints`](#parameter-endpoints) | array | The list of endpoints in the Traffic Manager profile. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`maxReturn`](#parameter-maxreturn) | int | Maximum number of endpoints to be returned for MultiValue routing type. |
| [`monitorConfig`](#parameter-monitorconfig) | object | The endpoint monitoring settings of the Traffic Manager profile. |
| [`profileStatus`](#parameter-profilestatus) | string | The status of the Traffic Manager profile. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`trafficRoutingMethod`](#parameter-trafficroutingmethod) | string | The traffic routing method of the Traffic Manager profile. |
| [`trafficViewEnrollmentStatus`](#parameter-trafficviewenrollmentstatus) | string | Indicates whether Traffic View is 'Enabled' or 'Disabled' for the Traffic Manager profile. Null, indicates 'Disabled'. Enabling this feature will increase the cost of the Traffic Manage profile. |
| [`ttl`](#parameter-ttl) | int | The DNS Time-To-Live (TTL), in seconds. This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile. |

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, ProbeHealthStatusEvents]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `endpoints`

The list of endpoints in the Traffic Manager profile.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `maxReturn`

Maximum number of endpoints to be returned for MultiValue routing type.
- Required: No
- Type: int
- Default: `1`

### Parameter: `monitorConfig`

The endpoint monitoring settings of the Traffic Manager profile.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `name`

Name of the Traffic Manager.
- Required: Yes
- Type: string

### Parameter: `profileStatus`

The status of the Traffic Manager profile.
- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `relativeName`

The relative DNS name provided by this Traffic Manager profile. This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `trafficRoutingMethod`

The traffic routing method of the Traffic Manager profile.
- Required: No
- Type: string
- Default: `'Performance'`
- Allowed: `[Geographic, MultiValue, Performance, Priority, Subnet, Weighted]`

### Parameter: `trafficViewEnrollmentStatus`

Indicates whether Traffic View is 'Enabled' or 'Disabled' for the Traffic Manager profile. Null, indicates 'Disabled'. Enabling this feature will increase the cost of the Traffic Manage profile.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `ttl`

The DNS Time-To-Live (TTL), in seconds. This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile.
- Required: No
- Type: int
- Default: `60`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the traffic manager was deployed into. |
| `resourceGroupName` | string | The resource group the traffic manager was deployed into. |
| `resourceId` | string | The resource ID of the traffic manager. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `monitorConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"monitorConfig": {
    "value": {
        "protocol": "http",
        "port": "80",
        "path": "/"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
monitorConfig: {
    protocol: 'http'
    port: '80'
    path: '/'
}
```

</details>
<p>

### Parameter Usage: `endpoints`

<details>

<summary>Parameter JSON format</summary>

```json
"endpoints": {
    "value": [
        {
            "id": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/trafficManagerProfiles/<tmname>/azureEndpoints/<endpointname>",
            "name": "MyEndpoint001",
            "type": "Microsoft.Network/trafficManagerProfiles/azureEndpoints",
            "properties":
            {
                "endpointStatus": "Enabled",
                "endpointMonitorStatus": "CheckingEndpoint",
                "targetResourceId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/publicIPAddresses/<pipname>",
                "target": "my-pip-001.eastus.cloudapp.azure.com",
                "weight": 1,
                "priority": 1,
                "endpointLocation": "East US"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
endpoints: [
    {
        id: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/trafficManagerProfiles/<tmname>/azureEndpoints/<endpointname>'
        name: 'MyEndpoint001'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties:
        {
            endpointStatus: 'Enabled'
            endpointMonitorStatus: 'CheckingEndpoint'
            targetResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/publicIPAddresses/<pipname>'
            target: 'my-pip-001.eastus.cloudapp.azure.com'
            weight: 1
            priority: 1
            endpointLocation: 'East US'
        }
    }
]
```

</details>
<p>
