# Azure Virtual Desktop (AVD) Host Pools `[Microsoft.DesktopVirtualization/hostPools]`

This module deploys an Azure Virtual Desktop (AVD) Host Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DesktopVirtualization/hostPools` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/hostPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/desktop-virtualization.host-pool:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module hostPool 'br:bicep/modules/desktop-virtualization.host-pool:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dvhpcom'
  params: {
    // Required parameters
    name: 'dvhpcom001'
    // Non-required parameters
    agentUpdate: {
      maintenanceWindows: [
        {
          dayOfWeek: 'Friday'
          hour: 7
        }
        {
          dayOfWeek: 'Saturday'
          hour: 8
        }
      ]
      maintenanceWindowTimeZone: 'Alaskan Standard Time'
      type: 'Scheduled'
      useSessionHostLocalTime: false
    }
    customRdpProperty: 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'
    description: 'My first AVD Host Pool'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'AVDv2'
    loadBalancerType: 'BreadthFirst'
    location: '<location>'
    lock: 'CanNotDelete'
    maxSessionLimit: 99999
    personalDesktopAssignmentType: 'Automatic'
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
    type: 'Pooled'
    vmTemplate: {
      customImageId: '<customImageId>'
      domain: 'domainname.onmicrosoft.com'
      galleryImageOffer: 'office-365'
      galleryImagePublisher: 'microsoftwindowsdesktop'
      galleryImageSKU: '20h1-evd-o365pp'
      imageType: 'Gallery'
      imageUri: '<imageUri>'
      namePrefix: 'avdv2'
      osDiskType: 'StandardSSD_LRS'
      useManagedDisks: true
      vmSize: {
        cores: 2
        id: 'Standard_D2s_v3'
        ram: 8
      }
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
      "value": "dvhpcom001"
    },
    // Non-required parameters
    "agentUpdate": {
      "value": {
        "maintenanceWindows": [
          {
            "dayOfWeek": "Friday",
            "hour": 7
          },
          {
            "dayOfWeek": "Saturday",
            "hour": 8
          }
        ],
        "maintenanceWindowTimeZone": "Alaskan Standard Time",
        "type": "Scheduled",
        "useSessionHostLocalTime": false
      }
    },
    "customRdpProperty": {
      "value": "audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;"
    },
    "description": {
      "value": "My first AVD Host Pool"
    },
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
    "friendlyName": {
      "value": "AVDv2"
    },
    "loadBalancerType": {
      "value": "BreadthFirst"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "maxSessionLimit": {
      "value": 99999
    },
    "personalDesktopAssignmentType": {
      "value": "Automatic"
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
    },
    "type": {
      "value": "Pooled"
    },
    "vmTemplate": {
      "value": {
        "customImageId": "<customImageId>",
        "domain": "domainname.onmicrosoft.com",
        "galleryImageOffer": "office-365",
        "galleryImagePublisher": "microsoftwindowsdesktop",
        "galleryImageSKU": "20h1-evd-o365pp",
        "imageType": "Gallery",
        "imageUri": "<imageUri>",
        "namePrefix": "avdv2",
        "osDiskType": "StandardSSD_LRS",
        "useManagedDisks": true,
        "vmSize": {
          "cores": 2,
          "id": "Standard_D2s_v3",
          "ram": 8
        }
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module hostPool 'br:bicep/modules/desktop-virtualization.host-pool:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dvhpmin'
  params: {
    // Required parameters
    name: 'dvhpmin001'
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
      "value": "dvhpmin001"
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
| [`name`](#parameter-name) | string | Name of the Host Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentUpdate`](#parameter-agentupdate) | object | The session host configuration for updating agent, monitoring agent, and stack component. |
| [`agentUpdateMaintenanceWindowDayOfWeek`](#parameter-agentupdatemaintenancewindowdayofweek) | string | Update day for scheduled agent updates. |
| [`agentUpdateMaintenanceWindowHour`](#parameter-agentupdatemaintenancewindowhour) | int | Update hour for scheduled agent updates. |
| [`agentUpdateMaintenanceWindows`](#parameter-agentupdatemaintenancewindows) | array | List of maintenance windows for scheduled agent updates. |
| [`agentUpdateMaintenanceWindowTimeZone`](#parameter-agentupdatemaintenancewindowtimezone) | string | Time zone for scheduled agent updates. |
| [`agentUpdateType`](#parameter-agentupdatetype) | string | Enable scheduled agent updates, Default means agent updates will automatically be installed by AVD when they become available. |
| [`agentUpdateUseSessionHostLocalTime`](#parameter-agentupdateusesessionhostlocaltime) | bool | Whether to use localTime of the virtual machine for scheduled agent updates. |
| [`customRdpProperty`](#parameter-customrdpproperty) | string | Host Pool RDP properties. |
| [`description`](#parameter-description) | string | The description of the Host Pool to be created. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`friendlyName`](#parameter-friendlyname) | string | The friendly name of the Host Pool to be created. |
| [`loadBalancerType`](#parameter-loadbalancertype) | string | Type of load balancer algorithm. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`maxSessionLimit`](#parameter-maxsessionlimit) | int | Maximum number of sessions. |
| [`personalDesktopAssignmentType`](#parameter-personaldesktopassignmenttype) | string | Set the type of assignment for a Personal Host Pool type. |
| [`preferredAppGroupType`](#parameter-preferredappgrouptype) | string | The type of preferred application group type, default to Desktop Application Group. |
| [`ring`](#parameter-ring) | int | The ring number of HostPool. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`ssoadfsAuthority`](#parameter-ssoadfsauthority) | string | URL to customer ADFS server for signing WVD SSO certificates. |
| [`ssoClientId`](#parameter-ssoclientid) | string | ClientId for the registered Relying Party used to issue WVD SSO certificates. |
| [`ssoClientSecretKeyVaultPath`](#parameter-ssoclientsecretkeyvaultpath) | string | Path to Azure KeyVault storing the secret used for communication to ADFS. |
| [`ssoSecretType`](#parameter-ssosecrettype) | string | The type of single sign on Secret Type. |
| [`startVMOnConnect`](#parameter-startvmonconnect) | bool | Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tokenValidityLength`](#parameter-tokenvaliditylength) | string | Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours. |
| [`type`](#parameter-type) | string | Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled. |
| [`validationEnvironment`](#parameter-validationenvironment) | bool | Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment. |
| [`vmTemplate`](#parameter-vmtemplate) | object | The necessary information for adding more VMs to this Host Pool. The object is converted to an in-line string when handed over to the resource deployment, since that only takes strings. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to generate a registration token. |

### Parameter: `agentUpdate`

The session host configuration for updating agent, monitoring agent, and stack component.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `agentUpdateMaintenanceWindowDayOfWeek`

Update day for scheduled agent updates.
- Required: No
- Type: string
- Default: `'Sunday'`
- Allowed: `[Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday]`

### Parameter: `agentUpdateMaintenanceWindowHour`

Update hour for scheduled agent updates.
- Required: No
- Type: int
- Default: `22`

### Parameter: `agentUpdateMaintenanceWindows`

List of maintenance windows for scheduled agent updates.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable]`

### Parameter: `agentUpdateMaintenanceWindowTimeZone`

Time zone for scheduled agent updates.
- Required: No
- Type: string
- Default: `'Central Standard Time'`

### Parameter: `agentUpdateType`

Enable scheduled agent updates, Default means agent updates will automatically be installed by AVD when they become available.
- Required: No
- Type: string
- Default: `'Default'`
- Allowed: `[Default, Scheduled]`

### Parameter: `agentUpdateUseSessionHostLocalTime`

Whether to use localTime of the virtual machine for scheduled agent updates.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `baseTime`

Do not provide a value! This date value is used to generate a registration token.
- Required: No
- Type: string
- Default: `[utcNow('u')]`

### Parameter: `customRdpProperty`

Host Pool RDP properties.
- Required: No
- Type: string
- Default: `'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'`

### Parameter: `description`

The description of the Host Pool to be created.
- Required: No
- Type: string
- Default: `''`

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
- Allowed: `['', AgentHealthStatus, allLogs, Checkpoint, Connection, Error, HostRegistration, Management]`

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

### Parameter: `friendlyName`

The friendly name of the Host Pool to be created.
- Required: No
- Type: string
- Default: `''`

### Parameter: `loadBalancerType`

Type of load balancer algorithm.
- Required: No
- Type: string
- Default: `'BreadthFirst'`
- Allowed: `[BreadthFirst, DepthFirst, Persistent]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `maxSessionLimit`

Maximum number of sessions.
- Required: No
- Type: int
- Default: `99999`

### Parameter: `name`

Name of the Host Pool.
- Required: Yes
- Type: string

### Parameter: `personalDesktopAssignmentType`

Set the type of assignment for a Personal Host Pool type.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Automatic, Direct]`

### Parameter: `preferredAppGroupType`

The type of preferred application group type, default to Desktop Application Group.
- Required: No
- Type: string
- Default: `'Desktop'`
- Allowed: `[Desktop, None, RailApplications]`

### Parameter: `ring`

The ring number of HostPool.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `ssoadfsAuthority`

URL to customer ADFS server for signing WVD SSO certificates.
- Required: No
- Type: string
- Default: `''`

### Parameter: `ssoClientId`

ClientId for the registered Relying Party used to issue WVD SSO certificates.
- Required: No
- Type: string
- Default: `''`

### Parameter: `ssoClientSecretKeyVaultPath`

Path to Azure KeyVault storing the secret used for communication to ADFS.
- Required: No
- Type: string
- Default: `''`

### Parameter: `ssoSecretType`

The type of single sign on Secret Type.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Certificate, CertificateInKeyVault, SharedKey, SharedKeyInKeyVault]`

### Parameter: `startVMOnConnect`

Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `tokenValidityLength`

Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours.
- Required: No
- Type: string
- Default: `'PT8H'`

### Parameter: `type`

Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled.
- Required: No
- Type: string
- Default: `'Pooled'`
- Allowed: `[Personal, Pooled]`

### Parameter: `validationEnvironment`

Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `vmTemplate`

The necessary information for adding more VMs to this Host Pool. The object is converted to an in-line string when handed over to the resource deployment, since that only takes strings.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the AVD host pool. |
| `resourceGroupName` | string | The resource group the AVD host pool was deployed into. |
| `resourceId` | string | The resource ID of the AVD host pool. |
| `tokenExpirationTime` | string | The expiration time for the registration token. |

## Cross-referenced modules

_None_
