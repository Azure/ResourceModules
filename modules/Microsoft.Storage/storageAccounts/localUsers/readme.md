# Storage StorageAccounts LocalUsers `[Microsoft.Storage/storageAccounts/localUsers]`

This module deploys Storage StorageAccounts LocalUsers.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/localUsers` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hasSshKey` | bool | Indicates whether ssh key exists. Set it to false to remove existing SSH key. |
| `hasSshPassword` | bool | Indicates whether ssh password exists. Set it to false to remove existing SSH password. |
| `name` | string | The local username to be used for SFTP Authentication. |
| `permissionScopes` | array | The permission scopes of the local user. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hasSharedKey` | bool | `False` | Indicates whether shared key exists. Set it to false to remove existing shared key. |
| `homeDirectory` | string | `''` | The local user home directory. |
| `sshAuthorizedKeys` | array | `[]` | The local user ssh authorized keys for SFTP. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the local user created for SFTP Authentication. |
| `resourceGroupName` | string | The resource group of the deployed management policy. |
| `resourceId` | string | The resource ID of the local user resource created. |

## Cross-referenced modules

_None_
