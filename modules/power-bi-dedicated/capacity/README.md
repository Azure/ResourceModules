# Power BI Dedicated Capacities `[Microsoft.PowerBIDedicated/capacities]`

This module deploys a Power BI Dedicated Capacity.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2016-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.PowerBIDedicated/capacities` | [2021-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.PowerBIDedicated/2021-01-01/capacities) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/power-bi-dedicated.capacity:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module capacity 'br:bicep/modules/power-bi-dedicated.capacity:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pbdcapcom'
  params: {
    // Required parameters
    members: [
      '<managedIdentityPrincipalId>'
    ]
    name: 'pbdcapcom001'
    skuCapacity: 1
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "members": {
      "value": [
        "<managedIdentityPrincipalId>"
      ]
    },
    "name": {
      "value": "pbdcapcom001"
    },
    "skuCapacity": {
      "value": 1
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module capacity 'br:bicep/modules/power-bi-dedicated.capacity:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-pbdcapmin'
  params: {
    // Required parameters
    members: [
      '<managedIdentityPrincipalId>'
    ]
    name: 'pbdcapmin001'
    skuCapacity: 1
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
    "members": {
      "value": [
        "<managedIdentityPrincipalId>"
      ]
    },
    "name": {
      "value": "pbdcapmin001"
    },
    "skuCapacity": {
      "value": 1
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
| [`members`](#parameter-members) | array | Members of the resource. |
| [`name`](#parameter-name) | string | Name of the PowerBI Embedded. |
| [`skuCapacity`](#parameter-skucapacity) | int | SkuCapacity of the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`mode`](#parameter-mode) | string | Mode of the resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`skuName`](#parameter-skuname) | string | SkuCapacity of the resource. |
| [`skuTier`](#parameter-skutier) | string | SkuCapacity of the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

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
- Allowed: `['', CanNotDelete, NotSpecified, ReadOnly]`

### Parameter: `members`

Members of the resource.
- Required: Yes
- Type: array

### Parameter: `mode`

Mode of the resource.
- Required: No
- Type: string
- Default: `'Gen2'`
- Allowed: `[Gen1, Gen2]`

### Parameter: `name`

Name of the PowerBI Embedded.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `skuCapacity`

SkuCapacity of the resource.
- Required: Yes
- Type: int

### Parameter: `skuName`

SkuCapacity of the resource.
- Required: No
- Type: string
- Default: `'A1'`
- Allowed: `[A1, A2, A3, A4, A5, A6]`

### Parameter: `skuTier`

SkuCapacity of the resource.
- Required: No
- Type: string
- Default: `'PBIE_Azure'`
- Allowed: `[AutoPremiumHost, PBIE_Azure, Premium]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the PowerBi Embedded. |
| `resourceGroupName` | string | The name of the resource group the PowerBi Embedded was created in. |
| `resourceId` | string | The resource ID of the PowerBi Embedded. |

## Cross-referenced modules

_None_
