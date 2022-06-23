# Automation Account Variables `[Microsoft.Automation/automationAccounts/variables]`

This module deploys a variable to an Azure Automation Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/variables` | [2020-01-13-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/variables) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the variable. |
| `value` | string | The value of the variable. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `automationAccountName` | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | The description of the variable. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `isEncrypted` | bool | `True` | If the variable should be encrypted. For security reasons encryption of variables should be enabled. |


### Parameter Usage: `value`

<details>

<summary>Parameter JSON format</summary>

```json
//Boolean format
"value": {
    "value": "false"
}

//DateTime format
"value": {
    "value": "\"\\/Date(1637934042656)\\/\""
}

//Integer format
"value": {
    "value": "500"
}

//String format
"value": {
    "value": "\"TestString\""
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
//Boolean format
value: 'false'

//DateTime format
value: '\'\\/Date(1637934042656)\\/\''

//Integer format
value: '500'

//String format
value: '\'TestString\''
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed variable. |
| `resourceGroupName` | string | The resource group of the deployed variable. |
| `resourceId` | string | The resource ID of the deployed variable. |
