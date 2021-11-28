# Automation Account Variables `[Microsoft.Automation/automationAccounts/variables]`

This module deploys a variable to an Azure Automation Account.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/variables` | 2020-01-13-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automationAccountName` | string |  |  | Required. Name of the parent Automation Account |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `description` | string |  |  | Optional. The description of the variable. |
| `isEncrypted` | bool |  |  | Optional. If the variable should be encrypted. |
| `name` | string |  |  | Required. The name of the variable. |
| `value` | string |  |  | Required. The value of the variable. |

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
| `variableName` | string | The name of the deployed variable |
| `variableResourceGroup` | string | The resource group of the deployed variable |
| `variableResourceId` | string | The resource ID of the deployed variable |

## Template references

- [Automationaccounts/Variables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/variables)
