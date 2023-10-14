# Action Groups `[Microsoft.Insights/actionGroups]`

This module deploys an Action Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/actionGroups` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-01-01/actionGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `groupShortName` | string | The short name of the action group. |
| `name` | string | The name of the action group. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `armRoleReceivers` | array | `[]` | The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported. |
| `automationRunbookReceivers` | array | `[]` | The list of AutomationRunbook receivers that are part of this action group. |
| `azureAppPushReceivers` | array | `[]` | The list of AzureAppPush receivers that are part of this action group. |
| `azureFunctionReceivers` | array | `[]` | The list of function receivers that are part of this action group. |
| `emailReceivers` | array | `[]` | The list of email receivers that are part of this action group. |
| `enabled` | bool | `True` | Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `itsmReceivers` | array | `[]` | The list of ITSM receivers that are part of this action group. |
| `location` | string | `'global'` | Location for all resources. |
| `logicAppReceivers` | array | `[]` | The list of logic app receivers that are part of this action group. |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `smsReceivers` | array | `[]` | The list of SMS receivers that are part of this action group. |
| `tags` | object | `{object}` | Tags of the resource. |
| `voiceReceivers` | array | `[]` | The list of voice receivers that are part of this action group. |
| `webhookReceivers` | array | `[]` | The list of webhook receivers that are part of this action group. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the action group . |
| `resourceGroupName` | string | The resource group the action group was deployed into. |
| `resourceId` | string | The resource ID of the action group . |

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
module actionGroup './insights/action-group/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-iagcom'
  params: {
    // Required parameters
    groupShortName: 'agiagcom001'
    name: 'iagcom001'
    // Non-required parameters
    emailReceivers: [
      {
        emailAddress: 'test.user@testcompany.com'
        name: 'TestUser_-EmailAction-'
        useCommonAlertSchema: true
      }
      {
        emailAddress: 'test.user2@testcompany.com'
        name: 'TestUser2'
        useCommonAlertSchema: true
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    smsReceivers: [
      {
        countryCode: '1'
        name: 'TestUser_-SMSAction-'
        phoneNumber: '2345678901'
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
    "groupShortName": {
      "value": "agiagcom001"
    },
    "name": {
      "value": "iagcom001"
    },
    // Non-required parameters
    "emailReceivers": {
      "value": [
        {
          "emailAddress": "test.user@testcompany.com",
          "name": "TestUser_-EmailAction-",
          "useCommonAlertSchema": true
        },
        {
          "emailAddress": "test.user2@testcompany.com",
          "name": "TestUser2",
          "useCommonAlertSchema": true
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "smsReceivers": {
      "value": [
        {
          "countryCode": "1",
          "name": "TestUser_-SMSAction-",
          "phoneNumber": "2345678901"
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module actionGroup './insights/action-group/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-iagmin'
  params: {
    // Required parameters
    groupShortName: 'agiagmin001'
    name: 'iagmin001'
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
    "groupShortName": {
      "value": "agiagmin001"
    },
    "name": {
      "value": "iagmin001"
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


## Notes

- Receiver name must be unique across the ActionGroup.
- Email, SMS, Azure App push and Voice can be grouped in the same Action. To do so, the `name` field of the receivers must be in the `RecName_-ActionType-` format where:
  - _RecName_ is the name you want to give to the Action
  - _ActionType_ is one of the action types that can be grouped together. Possible values are:
    - EmailAction
    - SMSAction
    - AzureAppAction
    - VoiceAction

- To understand the impact of the `useCommonAlertSchema` field, see [documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema).
