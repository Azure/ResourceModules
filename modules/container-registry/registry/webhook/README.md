# Azure Container Registry (ACR) Webhooks `[Microsoft.ContainerRegistry/registries/webhooks]`

This module deploys an Azure Container Registry (ACR) Webhook.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2022-02-01-preview/registries/webhooks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serviceUri` | string | The service URI for the webhook to post notifications. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `registryName` | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `action` | array | `[chart_delete, chart_push, delete, push, quarantine]` |  | The list of actions that trigger the webhook to post notifications. |
| `customHeaders` | object | `{object}` |  | Custom headers that will be added to the webhook notifications. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `name` | string | `[format('{0}webhook', parameters('registryName'))]` |  | The name of the registry webhook. |
| `scope` | string | `''` |  | The scope of repositories where the event can be triggered. For example, 'foo:*' means events for all tags under repository 'foo'. 'foo:bar' means events for 'foo:bar' only. 'foo' is equivalent to 'foo:latest'. Empty means all events. |
| `status` | string | `'enabled'` | `[disabled, enabled]` | The status of the webhook at the time the operation was called. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `actions` | array | The actions of the webhook. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the webhook. |
| `provistioningState` | string | The provisioning state of the webhook. |
| `resourceGroupName` | string | The name of the Azure container registry. |
| `resourceId` | string | The resource ID of the webhook. |
| `status` | string | The status of the webhook. |

## Cross-referenced modules

_None_
