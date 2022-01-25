# Synapse Workspaces Keys `[Microsoft.Synapse/workspaces/keys]`

This module deploys a Synapse Workspaces Key.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/keys` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `isActiveCMK` | bool |  |  | Required. Used to activate the workspace after a customer managed key is provided. |
| `keyVaultUrl` | string |  |  | Required. The Key Vault Url of the workspace key. |
| `name` | string |  |  | Required. Encryption key name. |
| `workspaceName` | string |  |  | Required. Synapse workspace name. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `keyName` | string | The name of the deployed key |
| `keyResourceGroup` | string | The resource group of the deployed key |
| `keyResourceId` | string | The resource ID of the deployed key |

## Template references

- [Workspaces/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys)
