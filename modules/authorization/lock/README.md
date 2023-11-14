# Authorization Locks (All scopes) `[Microsoft.Authorization/locks]`

This module deploys an Authorization Lock at a Subscription or Resource Group scope.

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

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/authorization.lock:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module lock 'br:bicep/modules/authorization.lock:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-almax'
  params: {
    // Required parameters
    level: 'CanNotDelete'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "level": {
      "value": "CanNotDelete"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module lock 'br:bicep/modules/authorization.lock:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-alwaf'
  params: {
    // Required parameters
    level: 'CanNotDelete'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "level": {
      "value": "CanNotDelete"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
| [`level`](#parameter-level) | string | Set lock level. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`notes`](#parameter-notes) | string | The decription attached to the lock. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Name of the Resource Group to assign the lock to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided lock to the resource group. |
| [`subscriptionId`](#parameter-subscriptionid) | string | Subscription ID of the subscription to assign the lock to. If not provided, will use the current scope for deployment. If no resource group name is provided, the module deploys at subscription level, therefore assigns the provided locks to the subscription. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `level`

Set lock level.
- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'ReadOnly'
  ]
  ```

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `notes`

The decription attached to the lock.
- Required: No
- Type: string
- Default: `[if(equals(parameters('level'), 'CanNotDelete'), 'Cannot delete resource or child resources.', 'Cannot modify the resource or child resources.')]`

### Parameter: `resourceGroupName`

Name of the Resource Group to assign the lock to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided lock to the resource group.
- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionId`

Subscription ID of the subscription to assign the lock to. If not provided, will use the current scope for deployment. If no resource group name is provided, the module deploys at subscription level, therefore assigns the provided locks to the subscription.
- Required: No
- Type: string
- Default: `[subscription().id]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lock. |
| `resourceId` | string | The resource ID of the lock. |
| `scope` | string | The scope this lock applies to. |

## Cross-referenced modules

_None_
