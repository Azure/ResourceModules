# Action Groups `[Microsoft.Insights/actionGroups]`

This module deploys an Action Group.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `microsoft.insights/actionGroups` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `armRoleReceivers` | array | `[]` |  | Optional. The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported. |
| `automationRunbookReceivers` | array | `[]` |  | Optional. The list of AutomationRunbook receivers that are part of this action group. |
| `azureAppPushReceivers` | array | `[]` |  | Optional. The list of AzureAppPush receivers that are part of this action group. |
| `azureFunctionReceivers` | array | `[]` |  | Optional. The list of function receivers that are part of this action group. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `emailReceivers` | array | `[]` |  | Optional. The list of email receivers that are part of this action group. |
| `enabled` | bool | `True` |  | Optional. Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications. |
| `groupShortName` | string |  |  | Required. The short name of the action group. |
| `itsmReceivers` | array | `[]` |  | Optional. The list of ITSM receivers that are part of this action group. |
| `location` | string | `global` |  | Optional. Location for all resources. |
| `logicAppReceivers` | array | `[]` |  | Optional. The list of logic app receivers that are part of this action group. |
| `name` | string |  |  | Required. The name of the action group. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `smsReceivers` | array | `[]` |  | Optional. The list of SMS receivers that are part of this action group. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `voiceReceivers` | array | `[]` |  | Optional. The list of voice receivers that are part of this action group. |
| `webhookReceivers` | array | `[]` |  | Optional. The list of webhook receivers that are part of this action group. |

### Parameter Usage: receivers

See [Documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2019-06-01/actiongroups) for description of parameters usage and syntax.

Example:

```json
"emailReceivers":{
  "value":[
    {
      "name": "TestUser_-EmailAction-",
      "emailAddress": "test.user@testcompany.com",
      "useCommonAlertSchema": true
    },
    {
      "name": "TestUser2",
      "emailAddress": "test.user2@testcompany.com",
      "useCommonAlertSchema": true
    }
  ]
},
"smsReceivers":{
  "value": [
    {
      "name": "TestUser_-SMSAction-",
      "countryCode": "1",
      "phoneNumber": "2345678901"
    }
  ]
}
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
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

### Additional notes on parameters

- Receiver name must be unique across the ActionGroup
- Email, SMS, Azure App push and Voice can be grouped in the same Action. To do so, the `name` field of the receivers must be in the `RecName_-ActionType-` format where:
  - _RecName_ is the name you want to give to the Action
  - _ActionType_ is one of the action types that can be grouped together. Possible values are:
    - EmailAction
    - SMSAction
    - AzureAppAction
    - VoiceAction
- To understand the impact of the `useCommonAlertSchema` field, see [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema)

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `actionGroupName` | string | The name of the action group  |
| `actionGroupResourceGroup` | string | The resource group the action group was deployed into |
| `actionGroupResourceId` | string | The resource ID of the action group  |

## Template references

- [Actiongroups](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2019-06-01/actionGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-04-01-preview/roleAssignments)
