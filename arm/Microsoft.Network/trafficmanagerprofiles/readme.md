# TrafficManager

This module deploys Traffic Manager, with resource lock.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.Network/trafficmanagerprofiles` | 2018-04-01 |
| `Microsoft.Network/trafficmanagerprofiles/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.Network/trafficmanagerprofiles/providers/roleAssignments` | 2018-09-01-preview |
| `providers/locks` |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `endpoints` | array | Optional. The list of endpoints in the Traffic Manager profile. | System.Object[] |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string  | Optional. Location for diagnostics settings only. Traffic manager will always be deployed globally. | `resourceGroup().location` |  |
| `lockForDeletion` | bool | Optional. Switch to lock Traffic Manager from deletion. | False |  |
| `maxReturn` | int | Optional. Maximum number of endpoints to be returned for MultiValue routing type. | 1 | |
| `monitorConfig` | object | Optional. The endpoint monitoring settings of the Traffic Manager profile. | protocol=http; port=80; path=/ |  |
| `profileStatus` | string | Optional. The status of the Traffic Manager profile. | Enabled | System.Object[] |
| `relativeName` | string | The relative DNS name provided by this Traffic Manager profile. This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile. |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Resource tags. |  |  |
| `trafficManagerName` | string | Name of the Traffic Manager |  |  |
| `trafficRoutingMethod` | string | Optional. The traffic routing method of the Traffic Manager profile. | Performance | System.Object[] |
| `trafficViewEnrollmentStatus` | string | Optional. Indicates whether Traffic View is 'Enabled' or 'Disabled' for the Traffic Manager profile. Null, indicates 'Disabled'. Enabling this feature will increase the cost of the Traffic Manage profile. | Disabled | System.Object[] |
| `ttl` | int | Optional. The DNS Time-To-Live (TTL), in seconds. This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile. | 60 |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |


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
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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
| :-          | :-          |
| `trafficManagerResourceId` | string | The Resource Id of the Traffic Manager.
| `trafficManagerResourceGroup` | string | The name of the Resource Group the Traffic Manager was created in.
| `trafficManagerName` | string | The Name of the Traffic Manager.

## Considerations

*N/A*

## Additional resources

- [What is Traffic Manager?](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview)
- [Microsoft.Network/trafficmanagerprofiles template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-04-01/trafficmanagerprofiles)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)