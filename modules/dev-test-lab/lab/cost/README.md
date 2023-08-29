# DevTest Lab Costs `[Microsoft.DevTestLab/labs/costs]`

This module deploys a DevTest Lab Cost.

Manage lab costs by setting a spending target that can be viewed in the Monthly Estimated Cost Trend chart. DevTest Labs can send a notification when spending reaches the specified target threshold.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/costs` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/costs) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `cycleType` | string | `[CalendarMonth, Custom]` | Reporting cycle type. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cycleEndDateTime` | string | `''` | Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom". |
| `cycleStartDateTime` | string | `''` | Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom". |
| `labName` | string |  | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `currencyCode` | string | `'USD'` |  | The currency code of the cost. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `status` | string | `'Enabled'` | `[Disabled, Enabled]` | Target cost status. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `target` | int | `0` |  | Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds. |
| `thresholdValue100DisplayOnChart` | string | `'Disabled'` | `[Disabled, Enabled]` | Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| `thresholdValue100SendNotificationWhenExceeded` | string | `'Disabled'` | `[Disabled, Enabled]` | Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| `thresholdValue125DisplayOnChart` | string | `'Disabled'` | `[Disabled, Enabled]` | Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| `thresholdValue125SendNotificationWhenExceeded` | string | `'Disabled'` | `[Disabled, Enabled]` | Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| `thresholdValue25DisplayOnChart` | string | `'Disabled'` | `[Disabled, Enabled]` | Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| `thresholdValue25SendNotificationWhenExceeded` | string | `'Disabled'` | `[Disabled, Enabled]` | Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| `thresholdValue50DisplayOnChart` | string | `'Disabled'` | `[Disabled, Enabled]` | Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| `thresholdValue50SendNotificationWhenExceeded` | string | `'Disabled'` | `[Disabled, Enabled]` | Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| `thresholdValue75DisplayOnChart` | string | `'Disabled'` | `[Disabled, Enabled]` | Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| `thresholdValue75SendNotificationWhenExceeded` | string | `'Disabled'` | `[Disabled, Enabled]` | Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |


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
| `name` | string | The name of the cost. |
| `resourceGroupName` | string | The name of the resource group the cost was created in. |
| `resourceId` | string | The resource ID of the cost. |

## Cross-referenced modules

_None_
