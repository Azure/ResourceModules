# Automation Account Variables `[Microsoft.Automation/automationAccounts/variables]`

This module deploys a variable to an Azure Automation Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/variables` | 2020-01-13-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `automationAccountName` | string | Name of the parent Automation Account |
| `name` | string | The name of the variable. |
| `value` | string | The value of the variable. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | The description of the variable. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `isEncrypted` | bool | `True` | If the variable should be encrypted. For security reasons encryption of variables should be enabled |


### Parameter Usage: `value`

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed variable |
| `resourceGroupName` | string | The resource group of the deployed variable |
| `resourceId` | string | The resource ID of the deployed variable |

## Template references

- [Automationaccounts/Variables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/variables)
