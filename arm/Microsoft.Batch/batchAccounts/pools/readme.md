# Batch BatchAccounts Pools `[Microsoft.Batch/batchAccounts/pools]`

This module deploys Batch BatchAccounts Pools.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Batch/batchAccounts/pools` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/pools) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `batchAccountName` | string | `''` | The name of the parent Batch Account. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `applicationLicenses` | array | The list of application licenses must be a subset of available Batch service application licenses. If a license is requested which is not supported, pool creation will fail. |
| `applicationPackages` | array | The list of application packages to install on the nodes. There is a maximum of 10 application package references on any given pool. |
| `userAssignedIdentities` | object | The list of user identities associated with the Batch pool. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type |
| :-- | :-- |
