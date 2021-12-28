# Automation Account Runbooks `[Microsoft.Automation/automationAccounts/runbooks]`

This module deploys an Azure Automation Account Runbook.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/runbooks` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automationAccountName` | string |  |  | Required. Name of the parent Automation Account. |
| `baseTime` | string | `[utcNow('u')]` |  | Optional. Time used as a basis for e.g. the schedule start date. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string |  |  | Required. Name of the Automation Account runbook. |
| `runbookDescription` | string |  |  | Optional. The description of the runbook. |
| `runbookType` | string |  | `[Graph, GraphPowerShell, GraphPowerShellWorkflow, PowerShell, PowerShellWorkflow]` | Required. The type of the runbook. |
| `sasTokenValidityLength` | string | `PT8H` |  | Optional. SAS token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `scriptStorageAccountId` | string |  |  | Optional. ID of the runbook storage account. |
| `tags` | object | `{object}` |  | Optional. Tags of the Automation Account resource. |
| `uri` | string |  |  | Optional. The uri of the runbook content. |
| `version` | string |  |  | Optional. The version of the runbook content. |

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
| `runbookName` | string | The name of the deployed runbook |
| `runbookResourceGroup` | string | The resource group of the deployed runbook |
| `runbookResourceId` | string | The resource ID of the deployed runbook |

## Template references

- [Automationaccounts/Runbooks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/runbooks)
