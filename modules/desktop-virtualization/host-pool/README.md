# Azure Virtual Desktop (AVD) Host Pools `[Microsoft.DesktopVirtualization/hostPools]`

This module deploys an Azure Virtual Desktop (AVD) Host Pool.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DesktopVirtualization/hostPools` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/hostPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Host Pool. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `agentUpdate` | object | `{object}` |  | The session host configuration for updating agent, monitoring agent, and stack component. |
| `agentUpdateMaintenanceWindowDayOfWeek` | string | `'Sunday'` | `[Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday]` | Update day for scheduled agent updates. |
| `agentUpdateMaintenanceWindowHour` | int | `22` |  | Update hour for scheduled agent updates. |
| `agentUpdateMaintenanceWindows` | array | `[System.Management.Automation.OrderedHashtable]` |  | List of maintenance windows for scheduled agent updates. |
| `agentUpdateMaintenanceWindowTimeZone` | string | `'Central Standard Time'` |  | Time zone for scheduled agent updates. |
| `agentUpdateType` | string | `'Default'` | `[Default, Scheduled]` | Enable scheduled agent updates, Default means agent updates will automatically be installed by AVD when they become available. |
| `agentUpdateUseSessionHostLocalTime` | bool | `False` |  | Whether to use localTime of the virtual machine for scheduled agent updates. |
| `customRdpProperty` | string | `'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'` |  | Host Pool RDP properties. |
| `description` | string | `''` |  | The description of the Host Pool to be created. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', AgentHealthStatus, allLogs, Checkpoint, Connection, Error, HostRegistration, Management]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `friendlyName` | string | `''` |  | The friendly name of the Host Pool to be created. |
| `loadBalancerType` | string | `'BreadthFirst'` | `[BreadthFirst, DepthFirst, Persistent]` | Type of load balancer algorithm. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxSessionLimit` | int | `99999` |  | Maximum number of sessions. |
| `personalDesktopAssignmentType` | string | `''` | `['', Automatic, Direct]` | Set the type of assignment for a Personal Host Pool type. |
| `preferredAppGroupType` | string | `'Desktop'` | `[Desktop, None, RailApplications]` | The type of preferred application group type, default to Desktop Application Group. |
| `ring` | int | `-1` |  | The ring number of HostPool. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `ssoadfsAuthority` | string | `''` |  | URL to customer ADFS server for signing WVD SSO certificates. |
| `ssoClientId` | string | `''` |  | ClientId for the registered Relying Party used to issue WVD SSO certificates. |
| `ssoClientSecretKeyVaultPath` | string | `''` |  | Path to Azure KeyVault storing the secret used for communication to ADFS. |
| `ssoSecretType` | string | `''` | `['', Certificate, CertificateInKeyVault, SharedKey, SharedKeyInKeyVault]` | The type of single sign on Secret Type. |
| `startVMOnConnect` | bool | `False` |  | Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `tokenValidityLength` | string | `'PT8H'` |  | Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours. |
| `type` | string | `'Pooled'` | `[Personal, Pooled]` | Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled. |
| `validationEnvironment` | bool | `False` |  | Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment. |
| `vmTemplate` | object | `{object}` |  | The necessary information for adding more VMs to this Host Pool. The object is converted to an in-line string when handed over to the resource deployment, since that only takes strings. |

**Generated parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Do not provide a value! This date value is used to generate a registration token. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the AVD host pool. |
| `resourceGroupName` | string | The resource group the AVD host pool was deployed into. |
| `resourceId` | string | The resource ID of the AVD host pool. |
| `tokenExpirationTime` | string | The expiration time for the registration token. |

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
module hostPool './desktop-virtualization/host-pool/main.bicep' = {
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module hostPool './desktop-virtualization/host-pool/main.bicep' = {
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
