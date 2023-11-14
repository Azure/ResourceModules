# Resources Tags `[Microsoft.Resources/tags]`

This module deploys a Resource Tag at a Subscription or Resource Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Resources/tags` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/tags) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/resources.tags:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Rg](#example-2-rg)
- [Sub](#example-3-sub)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module tags 'br:bicep/modules/resources.tags:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-rtmin'
  params: {
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Rg_

<details>

<summary>via Bicep module</summary>

```bicep
module tags 'br:bicep/modules/resources.tags:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-rtrg'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    onlyUpdate: false
    resourceGroupName: '<resourceGroupName>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Test: 'Yes'
      TestToo: 'No'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "onlyUpdate": {
      "value": false
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "Test": "Yes",
        "TestToo": "No"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Sub_

<details>

<summary>via Bicep module</summary>

```bicep
module tags 'br:bicep/modules/resources.tags:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-rtsub'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    onlyUpdate: true
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Test: 'Yes'
      TestToo: 'No'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "onlyUpdate": {
      "value": true
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "Test": "Yes",
        "TestToo": "No"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`onlyUpdate`](#parameter-onlyupdate) | bool | Instead of overwriting the existing tags, combine them with the new tags. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription. |
| [`subscriptionId`](#parameter-subscriptionid) | string | Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription. |
| [`tags`](#parameter-tags) | object | Tags for the resource group. If not provided, removes existing tags. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `onlyUpdate`

Instead of overwriting the existing tags, combine them with the new tags.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `resourceGroupName`

Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.
- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionId`

Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.
- Required: No
- Type: string
- Default: `[subscription().id]`

### Parameter: `tags`

Tags for the resource group. If not provided, removes existing tags.
- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the tags resource. |
| `resourceId` | string | The resource ID of the applied tags. |
| `tags` | object | The applied tags. |

## Cross-referenced modules

_None_
