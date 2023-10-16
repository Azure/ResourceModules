# Proximity Placement Groups `[Microsoft.Compute/proximityPlacementGroups]`

This module deploys a Proximity Placement Group.

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
| `Microsoft.Compute/proximityPlacementGroups` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-08-01/proximityPlacementGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/compute.proximity-placement-group:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module proximityPlacementGroup 'br:bicep/modules/compute.proximity-placement-group:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cppgcom'
  params: {
    // Required parameters
    name: 'cppgcom001'
    // Non-required parameters
    colocationStatus: {
      code: 'ColocationStatus/Aligned'
      displayStatus: 'Aligned'
      level: 'Info'
      message: 'I\'m a default error message'
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    intent: {
      vmSizes: [
        'Standard_B1ms'
        'Standard_B4ms'
      ]
    }
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
      'hidden-title': 'This is visible in the resource name'
      TagA: 'Would you kindly...'
      TagB: 'Tags for sale'
    }
    type: 'Standard'
    zones: [
      '1'
    ]
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
      "value": "cppgcom001"
    },
    // Non-required parameters
    "colocationStatus": {
      "value": {
        "code": "ColocationStatus/Aligned",
        "displayStatus": "Aligned",
        "level": "Info",
        "message": "I\"m a default error message"
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "intent": {
      "value": {
        "vmSizes": [
          "Standard_B1ms",
          "Standard_B4ms"
        ]
      }
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
        "hidden-title": "This is visible in the resource name",
        "TagA": "Would you kindly...",
        "TagB": "Tags for sale"
      }
    },
    "type": {
      "value": "Standard"
    },
    "zones": {
      "value": [
        "1"
      ]
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
module proximityPlacementGroup 'br:bicep/modules/compute.proximity-placement-group:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cppgmin'
  params: {
    // Required parameters
    name: 'cppgmin001'
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
      "value": "cppgmin001"
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
| [`name`](#parameter-name) | string | The name of the proximity placement group that is being created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`colocationStatus`](#parameter-colocationstatus) | object | Describes colocation status of the Proximity Placement Group. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`intent`](#parameter-intent) | object | Specifies the user intent of the proximity placement group. |
| [`location`](#parameter-location) | string | Resource location. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the proximity placement group resource. |
| [`type`](#parameter-type) | string | Specifies the type of the proximity placement group. |
| [`zones`](#parameter-zones) | array | Specifies the Availability Zone where virtual machine, virtual machine scale set or availability set associated with the proximity placement group can be created. |

### Parameter: `colocationStatus`

Describes colocation status of the Proximity Placement Group.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `intent`

Specifies the user intent of the proximity placement group.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `location`

Resource location.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the proximity placement group that is being created.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the proximity placement group resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `type`

Specifies the type of the proximity placement group.
- Required: No
- Type: string
- Default: `'Standard'`
- Allowed: `[Standard, Ultra]`

### Parameter: `zones`

Specifies the Availability Zone where virtual machine, virtual machine scale set or availability set associated with the proximity placement group can be created.
- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the proximity placement group. |
| `resourceGroupName` | string | The resource group the proximity placement group was deployed into. |
| `resourceId` | string | The resourceId the proximity placement group. |

## Cross-referenced modules

_None_
