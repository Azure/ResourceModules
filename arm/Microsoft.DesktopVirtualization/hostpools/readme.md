# AVD Host Pools `[Microsoft.DesktopVirtualization/hostpools]`

This module deploys an Azure virtual desktop host pool.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.DesktopVirtualization/hostPools` | 2021-07-12 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a registration token. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `customRdpProperty` | string | `audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;` |  | Optional. Host Pool RDP properties |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `hostpoolDescription` | string |  |  | Optional. The description of the Host Pool to be created. |
| `hostpoolFriendlyName` | string |  |  | Optional. The friendly name of the Host Pool to be created. |
| `hostpoolType` | string | `Pooled` | `[Personal, Pooled]` | Optional. Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled. |
| `loadBalancerType` | string | `BreadthFirst` | `[BreadthFirst, DepthFirst, Persistent]` | Optional. Type of load balancer algorithm. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[Checkpoint, Error, Management, Connection, HostRegistration, AgentHealthStatus]` | `[Checkpoint, Error, Management, Connection, HostRegistration, AgentHealthStatus]` | Optional. The name of logs that will be streamed. |
| `maxSessionLimit` | int | `99999` |  | Optional. Maximum number of sessions. |
| `name` | string |  |  | Required. Name of the Host Pool |
| `personalDesktopAssignmentType` | string |  | `[Automatic, Direct, ]` | Optional. Set the type of assignment for a Personal Host Pool type |
| `preferredAppGroupType` | string | `Desktop` | `[Desktop, None, RailApplications]` | Optional. The type of preferred application group type, default to Desktop Application Group |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `startVMOnConnect` | bool |  |  | Optional. Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `tokenValidityLength` | string | `PT8H` |  | Optional. Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours. |
| `validationEnviroment` | bool |  |  | Optional. Whether to use validation enviroment. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Ddefaults to false that stands for the stable, production-ready environment. |
| `validationEnvironment` | bool |  |  | Optional. Validation host pool allows you to test service changes before they are deployed to production. |
| `vmTemplate` | object | `{object}` |  | Optional. The necessary information for adding more VMs to this Host Pool. |

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

### Parameter Usage: `vmTemplate`

The below parameter object is converted to an in-line string when handed over to the resource deployment, since that only takes strings.

```json
"vmTemplate": {
    "value": {
        "domain": "<yourAddsDomain>.com",
        "galleryImageOffer": "office-365",
        "galleryImagePublisher": "microsoftwindowsdesktop",
        "galleryImageSKU": "19h2-evd-o365pp",
        "imageType": "Gallery",
        "imageUri": null,
        "customImageId": null,
        "namePrefix": "AVDv2",
        "osDiskType": "StandardSSD_LRS",
        "useManagedDisks": true,
        "vmSize": {
            "id": "Standard_D2s_v3",
            "cores": 2,
            "ram": 8
        }
    }
}
```

### Parameter Usage: `customRdpProperty`

```json
"customRdpProperty": {
    "value": "audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode ID:i:2;"
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
| `name` | string | The name of the AVD host pool |
| `resourceGroupName` | string | The resource group the AVD host pool was deployed into |
| `resourceId` | string | The resource ID of the AVD host pool |
| `tokenExpirationTime` | string | The expiration time for the registration token |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Hostpools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2021-07-12/hostPools)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
