# Action Group
This module deploys an Action Group


## Resource Types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`microsoft.insights/actionGroups`|2019-06-01|
|`microsoft.insights/actionGroups/providers/roleAssignments`|2018-09-01-preview| 


## Parameters

| Parameter Name                   | Type   | Default Value                | Possible values               | Description                                                  |
| :------------------------------- | :----- | :--------------------------- | :---------------------------- | :----------------------------------------------------------- |
| `actionGroupName` | string   | | | Required. The name of the action group. |
| `groupShortName`  | string   | | | Required. The short name of the action group. |
| `enabled`         | bool  | true | true, false | Optional. Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications. |
| `roleAssignments` | array | [] | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
| `emailReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of email receivers that are part of this action group. | 
| `smsReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of SMS receivers that are part of this action group. | 
| `webhookReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of webhook receivers that are part of this action group. | 
| `itsmReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of ITSM receivers that are part of this action group. |
| `azureAppPushReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of AzureAppPush receivers that are part of this action group. | 
| `automationRunbookReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of AutomationRunbook receivers that are part of this action group. | 
| `voiceReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of voice receivers. **Only US numbers supported at the moment** | 
| `logicAppReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of logic app receivers that are part of this action group. | 
| `azureFunctionReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of Azure Function receivers that are part of this action group. |
| `armRoleReceivers` | array | [] | Array of complex structures, see below. | Optional. The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported. |
| `tags` | object | {}  | Complex structure, see below. | Optional. Tags of the Action Group resource. |
| `cuaId` | string | {}  | Complex structure, see below. | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |
| `location` | string | global  | Complex structure, see below. | Optional. Location for all resources. |

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
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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
        "CostCenter": "112244",
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
| `actionGroupName` | string | The Name of the Azure Action Group. |
| `actionGroupResourceId` | string | The Resource Ids of the Action Group deployed. |
| `deploymentResourceGroup` | string | The name of the Resource Group the Action Group was created in. |

## Considerations

*N/A*

## Additional resources

- [Alerts in Azure](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-overview)
- [Template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2019-06-01/actiongroups)
- [Azure monitor documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/)