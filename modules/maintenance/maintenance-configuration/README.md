# Maintenance Configurations `[Microsoft.Maintenance/maintenanceConfigurations]`

This module deploys a Maintenance Configuration.

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
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/maintenance.maintenance-configuration:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module maintenanceConfiguration 'br:bicep/modules/maintenance.maintenance-configuration:1.0.0' = {
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module maintenanceConfiguration 'br:bicep/modules/maintenance.maintenance-configuration:1.0.0' = {
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Maintenance Configuration Name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`extensionProperties`](#parameter-extensionproperties) | object | Gets or sets extensionProperties of the maintenanceConfiguration. |
| [`installPatches`](#parameter-installpatches) | object | Configuration settings for VM guest patching with Azure Update Manager. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`maintenanceScope`](#parameter-maintenancescope) | string | Gets or sets maintenanceScope of the configuration. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | object | Definition of a MaintenanceWindow. |
| [`namespace`](#parameter-namespace) | string | Gets or sets namespace of the resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Gets or sets tags of the resource. |
| [`visibility`](#parameter-visibility) | string | Gets or sets the visibility of the configuration. The default value is 'Custom'. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `extensionProperties`

Gets or sets extensionProperties of the maintenanceConfiguration.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `installPatches`

Configuration settings for VM guest patching with Azure Update Manager.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `location`

Location for all Resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `maintenanceScope`

Gets or sets maintenanceScope of the configuration.
- Required: No
- Type: string
- Default: `'Host'`
- Allowed: `[Extension, Host, InGuestPatch, OSImage, SQLDB, SQLManagedInstance]`

### Parameter: `maintenanceWindow`

Definition of a MaintenanceWindow.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `name`

Maintenance Configuration Name.
- Required: Yes
- Type: string

### Parameter: `namespace`

Gets or sets namespace of the resource.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Gets or sets tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `visibility`

Gets or sets the visibility of the configuration. The default value is 'Custom'.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Custom, Public]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the Maintenance Configuration was created in. |
| `name` | string | The name of the Maintenance Configuration. |
| `resourceGroupName` | string | The name of the resource group the Maintenance Configuration was created in. |
| `resourceId` | string | The resource ID of the Maintenance Configuration. |

## Cross-referenced modules

_None_
