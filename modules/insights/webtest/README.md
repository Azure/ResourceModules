# Web Tests `[Microsoft.Insights/webtests]`

This module deploys a Web Test.

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
| `Microsoft.Insights/webtests` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2022-06-15/webtests) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the webtest. |
| `request` | object | The collection of request properties. |
| `tags` | object | A single hidden-link tag pointing to an existing AI component is required. |
| `webTestName` | string | User defined name if this WebTest. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `configuration` | object | `{object}` |  | An XML configuration specification for a WebTest. |
| `description` | string | `''` |  | User defined description for this WebTest. |
| `enabled` | bool | `True` |  | Is the test actively being monitored. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `frequency` | int | `300` |  | Interval in seconds between test runs for this WebTest. |
| `kind` | string | `'standard'` | `[multistep, ping, standard]` | The kind of WebTest that this web test watches. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `locations` | array | `[System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable]` |  | List of where to physically run the tests from to give global coverage for accessibility of your application. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `retryEnabled` | bool | `True` |  | Allow for retries should this WebTest fail. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `syntheticMonitorId` | string | `[parameters('name')]` |  | Unique ID of this WebTest. |
| `timeout` | int | `30` |  | Seconds until this WebTest will timeout and fail. |
| `validationRules` | object | `{object}` |  | The collection of validation rule properties. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the webtest. |
| `resourceGroupName` | string | The resource group the resource was deployed into. |
| `resourceId` | string | The resource ID of the webtest. |

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
module webtest './insights/webtest/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-iwtcom'
  params: {
    // Required parameters
    name: 'iwtcom001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    tags: {
      'hidden-link:${nestedDependencies.outputs.appInsightResourceId}': 'Resource'
      'hidden-title': 'This is visible in the resource name'
    }
    webTestName: 'wt$iwtcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    lock: 'CanNotDelete'
    syntheticMonitorId: 'iwtcom001'
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
      "value": "iwtcom001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "tags": {
      "value": {
        "hidden-link:${nestedDependencies.outputs.appInsightResourceId}": "Resource",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "webTestName": {
      "value": "wt$iwtcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "locations": {
      "value": [
        {
          "Id": "emea-nl-ams-azr"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "syntheticMonitorId": {
      "value": "iwtcom001"
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
module webtest './insights/webtest/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-iwtmin'
  params: {
    // Required parameters
    name: 'iwtmin001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    tags: {
      'hidden-link:${nestedDependencies.outputs.appInsightResourceId}': 'Resource'
      'hidden-title': 'This is visible in the resource name'
    }
    webTestName: 'wt$iwtmin001'
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
      "value": "iwtmin001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "tags": {
      "value": {
        "hidden-link:${nestedDependencies.outputs.appInsightResourceId}": "Resource",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "webTestName": {
      "value": "wt$iwtmin001"
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
