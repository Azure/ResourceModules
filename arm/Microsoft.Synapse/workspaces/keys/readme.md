# Synapse Workspaces Keys `[Microsoft.Synapse/workspaces/keys]`

This module deploys Synapse Workspaces Keys.
// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/keys` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `isActiveCMK` | bool |  |  | Used to activate the workspace after a customer managed key is provided. |
| `keyVaultUrl` | string |  |  | The Key Vault Url of the workspace key. |
| `name` | string |  |  | Encryption key name. |
| `workspaceName` | string |  |  | Synapse workspace name. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `keyName` | string | The name of the deployed key |
| `keyResourceGroup` | string | The resource group of the deployed key |
| `keyResourceId` | string | The resource ID of the deployed key |

## Template references

- [Workspaces/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys)
