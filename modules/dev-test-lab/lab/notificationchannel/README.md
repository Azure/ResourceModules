# DevTest Lab Notification Channels `[Microsoft.DevTestLab/labs/notificationchannels]`

This module deploys a DevTest Lab Notification Channel.

Notification channels are used by the schedule resource type in order to send notifications or events to email addresses and/or webhooks.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/notificationchannels` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/notificationchannels) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `events` | array |  | The list of event for which this notification is enabled. |
| `name` | string | `[autoShutdown, costThreshold]` | The name of the notification channel. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `emailRecipient` | string | `''` | The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty. |
| `labName` | string |  | The name of the parent lab. Required if the template is used in a standalone deployment. |
| `webHookUrl` | string | `''` | The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | Description of notification. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `notificationLocale` | string | `'en'` | The locale to use when sending a notification (fallback for unsupported languages is EN). |
| `tags` | object | `{object}` | Tags of the resource. |


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
| `name` | string | The name of the notification channel. |
| `resourceGroupName` | string | The name of the resource group the notification channel was created in. |
| `resourceId` | string | The resource ID of the notification channel. |

## Cross-referenced modules

_None_
