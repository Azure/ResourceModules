# Maintenance Configurations `[Microsoft.Maintenance/maintenanceConfigurations]`

This module deploys a Maintenance Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Maintenance Configuration Name. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `extensionProperties` | object | `{object}` |  | Gets or sets extensionProperties of the maintenanceConfiguration. |
| `installPatches` | object | `{object}` |  | Configuration settings for VM guest patching with Azure Update Manager. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maintenanceScope` | string | `'Host'` | `[Extension, Host, InGuestPatch, OSImage, SQLDB, SQLManagedInstance]` | Gets or sets maintenanceScope of the configuration. |
| `maintenanceWindow` | object | `{object}` |  | Definition of a MaintenanceWindow. |
| `namespace` | string | `''` |  | Gets or sets namespace of the resource. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Gets or sets tags of the resource. |
| `visibility` | string | `''` | `['', Custom, Public]` | Gets or sets the visibility of the configuration. The default value is 'Custom'. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the Maintenance Configuration was created in. |
| `name` | string | The name of the Maintenance Configuration. |
| `resourceGroupName` | string | The name of the resource group the Maintenance Configuration was created in. |
| `resourceId` | string | The resource ID of the Maintenance Configuration. |

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
module maintenanceConfiguration './maintenance/maintenance-configuration/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mmccom'
  params: {
    // Required parameters
    name: 'mmccom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    installPatches: {
      linuxParameters: {
        classificationsToInclude: '<classificationsToInclude>'
        packageNameMasksToExclude: '<packageNameMasksToExclude>'
        packageNameMasksToInclude: '<packageNameMasksToInclude>'
      }
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        kbNumbersToExclude: '<kbNumbersToExclude>'
        kbNumbersToInclude: '<kbNumbersToInclude>'
      }
    }
    lock: 'CanNotDelete'
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: '9999-12-31 23:59:59'
      recurEvery: 'Day'
      startDateTime: '2022-12-31 13:00'
      timeZone: 'W. Europe Standard Time'
    }
    namespace: 'mmccomns'
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
    visibility: 'Custom'
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
      "value": "mmccom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "extensionProperties": {
      "value": {
        "InGuestPatchMode": "User"
      }
    },
    "installPatches": {
      "value": {
        "linuxParameters": {
          "classificationsToInclude": "<classificationsToInclude>",
          "packageNameMasksToExclude": "<packageNameMasksToExclude>",
          "packageNameMasksToInclude": "<packageNameMasksToInclude>"
        },
        "rebootSetting": "IfRequired",
        "windowsParameters": {
          "classificationsToInclude": [
            "Critical",
            "Security"
          ],
          "kbNumbersToExclude": "<kbNumbersToExclude>",
          "kbNumbersToInclude": "<kbNumbersToInclude>"
        }
      }
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "maintenanceWindow": {
      "value": {
        "duration": "03:00",
        "expirationDateTime": "9999-12-31 23:59:59",
        "recurEvery": "Day",
        "startDateTime": "2022-12-31 13:00",
        "timeZone": "W. Europe Standard Time"
      }
    },
    "namespace": {
      "value": "mmccomns"
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
    "visibility": {
      "value": "Custom"
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
module maintenanceConfiguration './maintenance/maintenance-configuration/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mmcmin'
  params: {
    // Required parameters
    name: 'mmcmin001'
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
      "value": "mmcmin001"
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
