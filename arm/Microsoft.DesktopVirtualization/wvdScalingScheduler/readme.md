# WvdScaling Scheduler

This module deploys an Azure Logic App Workflow for WVD.
It uses a Http-REST action to invoke a webhook

## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Logic/workflows`|2019-05-01|
|`Microsoft.Logic/workflows/providers/locks`|2016-09-01|
|`Microsoft.Logic/workflows/providers/diagnosticsettings`|2017-05-01-preview|
|`Microsoft.Resources/deployments`|2020-06-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `actionSettingsBody` | object | Optional. Specifies the body in Action settings ('Note': Input should be in json format) |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Required. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Logic App from deletion. | False |  |
| `logicAppName` | string | Required. The name of the logic app to create. |  |  |
| `recurrenceInterval` | int | Required. Specifies the recurrence interval of the job in minutes |  | |
| `tags` | object | Optional. Tags of the Logic App resource. |  |  |
| `webhookURI` | string | Required. Webhook URI of Logic App |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |

### Parameter Usage: `logicAppName`

The name of the logic app to create.

```json
"logicAppName": {
    "value": "wvdScalingApp"
}
```

### Parameter Usage: `location`

Location for all resources.

```json
"location": {
    "value": "westeurope"
}
```

### Parameter Usage: `webhookURI`

Webhook URI of Logic App.

```json
"webhookURI": {
    "value": "https://s2events.azure-automation.net/webhooks?token=MyPlaceholder"
}
```

### Parameter Usage: `recurrenceInterval`

Specifies the recurrence interval of the job in minutes.

```json
"recurrenceInterval": {
    "value": 15
}
```

### Parameter Usage: `actionSettingsBody`

Specifies the body in Action settings ('Note': Input should be in json format). Contains the data send to the AutomationAccount runbook

```json
"actionSettingsBody": {
    "value": {
        "HostPoolName": "[HostPoolName]", // Required. Name of the host pool to scale
        "AutomationAccountName": "[AutomationAccountName]", // Required. Name of the automation account running the scaling runbook
        "LimitSecondsToForceLogOffUser": "[LimitSecondsToForceLogOffUser]", // Required. Time the user gets to save progress before being logged off
        "EndPeakTime": "[EndPeakTime]", // Required. Desired end time for downscaling
        "BeginPeakTime": "[BeginPeakTime]", // Required. Desired start time for upscaling
        "UtcOffset": "[UtcOffset]", // Required. Offset of the host pool location relative to the automation account location
        "LogOffMessageBody": "[LogOffMessageBody]", // Required. Message for the Log-Off popup
        "LogOffMessageTitle": "[LogOffMessageTitle]", // Required. Title for the Log-Off popup
        "MinimumNumberOfRDSH": 1, // Required. Minimum number of hosts to keep always running
        "SessionThresholdPerCPU": 1, // Required. Desired sessions per CPU. Used to calculate scaling demand
        "subscriptionid": "", // Optional. Subscription of the target host pool
        "AADTenantId": "", // Optional. TenantId of the target host pool
        "ConnectionAssetName": "", // Optional. Name of the automation account runAs connection
        "HostPoolResourceGroup": "", // Optional. Resource group of the target host pool
        "MaintenanceTagName": "", // Optional. Tag for host pools to exclude from scaling
    }
}
```

### Parameter Usage: `diagnosticLogsRetentionInDays`

Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.

```json
"diagnosticLogsRetentionInDays": {
    "value": 30
}
```

### Parameter Usage: `diagnosticStorageAccountId`

Resource identifier of the Diagnostic Storage Account.

```json
"diagnosticStorageAccountId": {
    "value": "/subscriptions/396826c76-d304-46d8-a0f6-718dbded536c/resourceGroups/Base-RG/providers/Microsoft.Storage/storageAccounts/sharedSA"
}
```

### Parameter Usage: `workspaceId`

Resource identifier of Log Analytics.

```json
"workspaceId": {
    "value": "/subscriptions/396826c76-d304-46d8-a0f6-718dbded536c/resourceGroups/Base-RG/providers/microsoft.operationalinsights/workspaces/my-sbx-eu-la"
}
```

### Parameter Usage: `eventHubAuthorizationRuleId`

Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

```json
"eventHubAuthorizationRuleId": {
    "value": "/subscriptions/396826c76-d304-46d8-a0f6-718dbded536c/resourceGroups/Base-RG/providers/Microsoft.EventHub/namespaces/my-sbx-02-eh/authorizationRules/myRule"
}
```

### Parameter Usage: `eventHubName`

Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.

```json
"eventHubName": {
    "value": "myEventHub"
}
```

### Parameter Usage: `lockForDeletion`

Switch to lock Logic App from deletion.

```json
"lockForDeletion": {
    "value": true
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `logicAppName` | string | The Name of the Log App. |
| `logicAppResourceGroup` | string | The Resource Group the Logic App was deployed to. |
| `logicAppResourceId` | string | The Resource Id of the Logic App. |

## Considerations

*N/A*

## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [WorkfloWs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/workflows)