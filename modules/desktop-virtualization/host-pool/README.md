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

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/desktop-virtualization.host-pool:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module hostPool 'br:bicep/modules/desktop-virtualization.host-pool:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dvhpmax'
  params: {
    // Required parameters
    name: 'dvhpmax001'
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
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'AVDv2'
    loadBalancerType: 'BreadthFirst'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maxSessionLimit: 99999
    personalDesktopAssignmentType: 'Automatic'
    roleAssignments: [
      {
        principalId: '<principalId>'
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
      "value": "dvhpmax001"
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
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
          "principalId": "<principalId>",
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module hostPool 'br:bicep/modules/desktop-virtualization.host-pool:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dvhpwaf'
  params: {
    // Required parameters
    name: 'dvhpwaf001'
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
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'AVDv2'
    loadBalancerType: 'BreadthFirst'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maxSessionLimit: 99999
    personalDesktopAssignmentType: 'Automatic'
    roleAssignments: [
      {
        principalId: '<principalId>'
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
      "value": "dvhpwaf001"
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
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
          "principalId": "<principalId>",
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
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`friendlyName`](#parameter-friendlyname) | string | The friendly name of the Host Pool to be created. |
| [`loadBalancerType`](#parameter-loadbalancertype) | string | Type of load balancer algorithm. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
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
- Default:
  ```Bicep
  {
      maintenanceWindows: '[parameters(\'agentUpdateMaintenanceWindows\')]'
      maintenanceWindowTimeZone: '[parameters(\'agentUpdateMaintenanceWindowTimeZone\')]'
      type: '[parameters(\'agentUpdateType\')]'
      useSessionHostLocalTime: '[parameters(\'agentUpdateUseSessionHostLocalTime\')]'
  }
  ```

### Parameter: `agentUpdateMaintenanceWindowDayOfWeek`

Update day for scheduled agent updates.
- Required: No
- Type: string
- Default: `'Sunday'`
- Allowed:
  ```Bicep
  [
    'Friday'
    'Monday'
    'Saturday'
    'Sunday'
    'Thursday'
    'Tuesday'
    'Wednesday'
  ]
  ```

### Parameter: `agentUpdateMaintenanceWindowHour`

Update hour for scheduled agent updates.
- Required: No
- Type: int
- Default: `22`

### Parameter: `agentUpdateMaintenanceWindows`

List of maintenance windows for scheduled agent updates.
- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      dayOfWeek: '[parameters(\'agentUpdateMaintenanceWindowDayOfWeek\')]'
      hour: '[parameters(\'agentUpdateMaintenanceWindowHour\')]'
    }
  ]
  ```

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
- Allowed:
  ```Bicep
  [
    'Default'
    'Scheduled'
  ]
  ```

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

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | No | string | Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | No | string | Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string


### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

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
- Allowed:
  ```Bicep
  [
    'BreadthFirst'
    'DepthFirst'
    'Persistent'
  ]
  ```

### Parameter: `location`

Location for all resources.
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
- Allowed:
  ```Bicep
  [
    ''
    'Automatic'
    'Direct'
  ]
  ```

### Parameter: `preferredAppGroupType`

The type of preferred application group type, default to Desktop Application Group.
- Required: No
- Type: string
- Default: `'Desktop'`
- Allowed:
  ```Bicep
  [
    'Desktop'
    'None'
    'RailApplications'
  ]
  ```

### Parameter: `ring`

The ring number of HostPool.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
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
- Allowed:
  ```Bicep
  [
    ''
    'Certificate'
    'CertificateInKeyVault'
    'SharedKey'
    'SharedKeyInKeyVault'
  ]
  ```

### Parameter: `startVMOnConnect`

Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

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
- Allowed:
  ```Bicep
  [
    'Personal'
    'Pooled'
  ]
  ```

### Parameter: `validationEnvironment`

Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `vmTemplate`

The necessary information for adding more VMs to this Host Pool. The object is converted to an in-line string when handed over to the resource deployment, since that only takes strings.
- Required: No
- Type: object
- Default: `{}`


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
