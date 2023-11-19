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

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/maintenance.maintenance-configuration:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module maintenanceConfiguration 'br:bicep/modules/maintenance.maintenance-configuration:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mmcmax'
  params: {
    // Required parameters
    name: 'mmcmax001'
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: '9999-12-31 23:59:59'
      recurEvery: 'Day'
      startDateTime: '2022-12-31 13:00'
      timeZone: 'W. Europe Standard Time'
    }
    namespace: 'mmcmaxns'
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
      "value": "mmcmax001"
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
      "value": "mmcmaxns"
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
    "visibility": {
      "value": "Custom"
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
module maintenanceConfiguration 'br:bicep/modules/maintenance.maintenance-configuration:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-mmcwaf'
  params: {
    // Required parameters
    name: 'mmcwaf001'
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: '9999-12-31 23:59:59'
      recurEvery: 'Day'
      startDateTime: '2022-12-31 13:00'
      timeZone: 'W. Europe Standard Time'
    }
    namespace: 'mmcwafns'
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
      "value": "mmcwaf001"
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
      "value": "mmcwafns"
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
    "visibility": {
      "value": "Custom"
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
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
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
- Default: `{}`

### Parameter: `installPatches`

Configuration settings for VM guest patching with Azure Update Manager.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `location`

Location for all Resources.
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

### Parameter: `maintenanceScope`

Gets or sets maintenanceScope of the configuration.
- Required: No
- Type: string
- Default: `'Host'`
- Allowed:
  ```Bicep
  [
    'Extension'
    'Host'
    'InGuestPatch'
    'OSImage'
    'SQLDB'
    'SQLManagedInstance'
  ]
  ```

### Parameter: `maintenanceWindow`

Definition of a MaintenanceWindow.
- Required: No
- Type: object
- Default: `{}`

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

### Parameter: `tags`

Gets or sets tags of the resource.
- Required: No
- Type: object

### Parameter: `visibility`

Gets or sets the visibility of the configuration. The default value is 'Custom'.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Custom'
    'Public'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the Maintenance Configuration was created in. |
| `name` | string | The name of the Maintenance Configuration. |
| `resourceGroupName` | string | The name of the resource group the Maintenance Configuration was created in. |
| `resourceId` | string | The resource ID of the Maintenance Configuration. |

## Cross-referenced modules

_None_
