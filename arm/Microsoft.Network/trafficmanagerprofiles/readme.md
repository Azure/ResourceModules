# Traffic Manager Profiles `[Microsoft.Network/trafficmanagerprofiles]`

This module deploys a traffic manager profile.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/trafficmanagerprofiles` | 2018-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `endpoints` | array | `[]` |  | Optional. The list of endpoints in the Traffic Manager profile. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ProbeHealthStatusEvents]` | `[ProbeHealthStatusEvents]` | Optional. The name of logs that will be streamed. |
| `maxReturn` | int | `1` |  | Optional. Maximum number of endpoints to be returned for MultiValue routing type. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `monitorConfig` | object | `{object}` |  | Optional. The endpoint monitoring settings of the Traffic Manager profile. |
| `name` | string |  |  | Required. Name of the Traffic Manager |
| `profileStatus` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The status of the Traffic Manager profile. |
| `relativeName` | string |  |  | Required. The relative DNS name provided by this Traffic Manager profile. This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Resource tags. |
| `trafficRoutingMethod` | string | `Performance` | `[Performance, Priority, Weighted, Geographic, MultiValue, Subnet]` | Optional. The traffic routing method of the Traffic Manager profile. |
| `trafficViewEnrollmentStatus` | string | `Disabled` | `[Disabled, Enabled]` | Optional. Indicates whether Traffic View is 'Enabled' or 'Disabled' for the Traffic Manager profile. Null, indicates 'Disabled'. Enabling this feature will increase the cost of the Traffic Manage profile. |
| `ttl` | int | `60` |  | Optional. The DNS Time-To-Live (TTL), in seconds. This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `monitorConfig`

```json
"monitorConfig": {
    "value":
        {
            "protocol": "http",
            "port": "80",
            "path": "/"
        }
}
```

### Parameter Usage: `endpoints`

```json
"endpoints": {
    "value":
        [
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

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `trafficManagerName` | string | The name of the traffix manager was deployed into |
| `trafficManagerResourceGroup` | string | The resource group the traffix manager was deployed into |
| `trafficManagerResourceId` | string | The resource ID of the traffix manager |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Trafficmanagerprofiles](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-08-01/trafficmanagerprofiles)
