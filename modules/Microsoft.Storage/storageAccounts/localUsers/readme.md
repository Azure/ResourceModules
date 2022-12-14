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
| `Microsoft.Storage/storageAccounts/localUsers` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/localUsers) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hasSharedKey` | bool | Indicates whether shared key exists. Set it to false to remove existing shared key. |
| `hasSshKey` | bool | Indicates whether ssh key exists. Set it to false to remove existing SSH key. |
| `hasSshPassword` | bool | Indicates whether ssh password exists. Set it to false to remove existing SSH password. |
| `name` | string | The local user name to be used for SFTP Authentication. |
| `permissionScopes` | array | The permission scopes of the local user. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `homeDirectory` | string | `''` | The local user home directory. |
| `sshAuthorizedKeys` | array |  | The local user ssh authorized keys for SFTP. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `localUser` | string | The name of the local user created for SFTP Authentication. |
| `permissionScopes` | array | The permission scopes granted for the local user. |

## Cross-referenced modules

_None_
