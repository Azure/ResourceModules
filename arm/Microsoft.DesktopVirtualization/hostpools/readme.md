# WVD HostPools

This module deploys WVD Host Pools, with resource lock and diagnostics configuration.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.DesktopVirtualization/hostpools`|2019-12-10-preview|
|`Microsoft.DesktopVirtualization/hostpools/providers/diagnosticsettings`|2017-05-01-preview|
|`providers/locks`|2016-09-01|
|`Microsoft.Resources/deployments`|2018-02-01|


## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `hostPoolName` | string | | | Required. Name of the Host Pool
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `hostpoolFriendlyName` | string | "" | | Optional. The friendly name of the Host Pool to be created.
| `hostpoolDescription` | string | "" | | Optional. The description of the Host Pool to be created.
| `hostpoolType` | string | `Pooled` | "Personal", "Pooled" | Optional. Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled.
| `personalDesktopAssignmentType` | string | "" | "Automatic", "Direct", "" | Optional. Set the type of assignment for a Personal Host Pool type
| `loadBalancerType` | string | `true` | "BreadthFirst", "DepthFirst", "Persistent" | Optional. Type of load balancer algorithm.
| `maxSessionLimit` | int | `99999` | | Optional. Maximum number of sessions. |
| `customRdpProperty` | string | `audiocapturemode:i:1; audiomode:i:0; drivestoredirect:s:; redirectclipboard:i:1; redirectcomports:i:1; redirectprinters:i:1; redirectsmartcards:i:1; screen mode id:i:2;` | [Supported Remote desktop RDP file settings](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/rdp-files?context=/azure/virtual-desktop/context/context) | Optional. Host Pool RDP properties
| `validationEnviroment` | bool | `false` | | Optional. Whether to use validation enviroment. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Ddefaults to false that stands for the stable, production-ready environment.
| `vmTemplate` | object | {} | Complex structure, see below. | Optional. The necessary information for adding more VMs to this Host Pool
| `tokenValidityLength` | string | `PT8H` | Duration in  ISO 8601 format. E.g. PT8H, P1Y, P5D | Optional. Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours.
| `baseTime` | string | `utcNow('u')` | | Generated. Do not provide a value! This date value is used to generate a registration token.
| `diagnosticLogsRetentionInDays` | int | `365` | | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.
| `diagnosticStorageAccountId` | string | "" | | Optional. Resource identifier of the Diagnostic Storage Account.
| `workspaceId` | string | "" | | Optional. Resource identifier of Log Analytics.
| `eventHubAuthorizationRuleId` | string | "" | | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
| `eventHubName` | string | "" | | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
| `lockForDeletion` | bool | `true` | | Optional. Switch to lock the resource from deletion.
| `tags` | object | {} | Complex structure, see below. | Optional. Tags of the resource.
| `cuaId` | string | "" | | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered
| `startVMOnConnect` | bool | `false` | | Optional. Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs
| `validationEnvironment` | bool | `false` | | Optional. Validation host pool allows you to test service changes before they are deployed to production

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
        "namePrefix": "wvdv2",
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
    "value": "audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;"
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
| `hostPoolName` | string | The Name of the Host Pool. |
| `hostPoolResourceGroup` | string | The name of the Resource Group the Host Pool was created in. |
| `hostPoolResourceId` | string | The Resource Id of the Host Pool. |
| `hostpoolToken` | string | The token that has to be used to register a VM to the Host Pool. |
| `tokenExpirationTime` | string | The expiration time of the Host Pool registration token. |

## Considerations

*N/A*

## Additional resources

- [What is Windows Virtual Desktop?](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)
- [Windows Virtual Desktop environment](https://docs.microsoft.com/en-us/azure/virtual-desktop/environment-setup)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)