# Azure Virtual Desktop (AVD) Application Groups `[Microsoft.DesktopVirtualization/applicationGroups]`

This module deploys an Azure Virtual Desktop (AVD) Application Group.

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
| `Microsoft.DesktopVirtualization/applicationGroups` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/applicationGroups) |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/applicationGroups/applications) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `applicationGroupType` | string | `[Desktop, RemoteApp]` | The type of the Application Group to be created. Allowed values: RemoteApp or Desktop. |
| `hostpoolName` | string |  | Name of the Host Pool to be linked to this Application Group. |
| `name` | string |  | Name of the Application Group to create this application in. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applications` | array | `[]` |  | List of applications to be created in the Application Group. |
| `description` | string | `''` |  | The description of the Application Group to be created. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, Checkpoint, Error, Management]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of log analytics. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `friendlyName` | string | `''` |  | The friendly name of the Application Group to be created. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the AVD application group. |
| `resourceGroupName` | string | The resource group the AVD application group was deployed into. |
| `resourceId` | string | The resource ID of the AVD application group. |

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
module applicationGroup './desktop-virtualization/application-group/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dvagcom'
  params: {
    // Required parameters
    applicationGroupType: 'RemoteApp'
    hostpoolName: '<hostpoolName>'
    name: 'dvagcom001'
    // Non-required parameters
    applications: [
      {
        commandLineArguments: ''
        commandLineSetting: 'DoNotAllow'
        description: 'Notepad by ARM template'
        filePath: 'C:\\Windows\\System32\\notepad.exe'
        friendlyName: 'Notepad'
        iconIndex: 0
        iconPath: 'C:\\Windows\\System32\\notepad.exe'
        name: 'notepad'
        showInPortal: true
      }
      {
        filePath: 'C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe'
        friendlyName: 'Wordpad'
        name: 'wordpad'
      }
    ]
    description: 'This is my first Remote Applications bundle'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'Remote Applications 1'
    location: '<location>'
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
    "applicationGroupType": {
      "value": "RemoteApp"
    },
    "hostpoolName": {
      "value": "<hostpoolName>"
    },
    "name": {
      "value": "dvagcom001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "commandLineArguments": "",
          "commandLineSetting": "DoNotAllow",
          "description": "Notepad by ARM template",
          "filePath": "C:\\Windows\\System32\\notepad.exe",
          "friendlyName": "Notepad",
          "iconIndex": 0,
          "iconPath": "C:\\Windows\\System32\\notepad.exe",
          "name": "notepad",
          "showInPortal": true
        },
        {
          "filePath": "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe",
          "friendlyName": "Wordpad",
          "name": "wordpad"
        }
      ]
    },
    "description": {
      "value": "This is my first Remote Applications bundle"
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
      "value": "Remote Applications 1"
    },
    "location": {
      "value": "<location>"
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module applicationGroup './desktop-virtualization/application-group/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dvagmin'
  params: {
    // Required parameters
    applicationGroupType: 'RemoteApp'
    hostpoolName: '<hostpoolName>'
    name: 'dvagmin001'
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
    "applicationGroupType": {
      "value": "RemoteApp"
    },
    "hostpoolName": {
      "value": "<hostpoolName>"
    },
    "name": {
      "value": "dvagmin001"
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
