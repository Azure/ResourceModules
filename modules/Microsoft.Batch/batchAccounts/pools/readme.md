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
| `batchAccountName` | string | The name of the parent Batch Account. Required if the template is used in a standalone deployment. |
| `deploymentConfiguration` | object | Deployment configuration properties. |
| `displayName` | string | The display name need not be unique and can contain any Unicode characters up to a maximum length of 1024. |
| `networkConfiguration` | object | The network configuration for a pool. |
| `poolName` | string | The name of the pool. |
| `scaleSettings` | object | Defines the desired size of the pool. |
| `vmSize` | string | For information about available sizes of virtual machines for Cloud Services pools (pools created with cloudServiceConfiguration), see Sizes for Cloud Services (https://azure.microsoft.com/documentation/articles/cloud-services-sizes-specs/). |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applicationLicenses` | array | `[]` |  | The list of application licenses must be a subset of available Batch service application licenses. If a license is requested which is not supported, pool creation will fail. |
| `applicationPackages` | array | `[]` |  | The list of application packages to install on the nodes. There is a maximum of 10 application package references on any given pool. |
| `certificates` | array | `[]` |  | The list of certificate objects to install on the pool. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `interNodeCommunication` | string | `'Disabled'` | `[Enabled, Disabled]` | This imposes restrictions on which nodes can be assigned to the pool. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `metadata` | array | `[]` |  | The List of metadate for the use of user code. |
| `mountConfiguration` | array | `[]` |  | The List of mount configurations. This supports Azure Files, NFS, CIFS/SMB, and Blobfuse. |
| `startTask` | object | `{object}` |  | The start task is executed when a node is started up. |
| `taskSchedulingPolicy` | string | `'Pack'` | `[Pack, Spread]` | Specifies how tasks should be distributed across compute nodes. |
| `taskSlotsPerNode` | int | `1` |  | Number of tasks slots per node. Cannot be modified after pool creation. The maximum value is the smaller of 4 times the number of cores of the vmSize of the pool or 256. |
| `userAccounts` | array | `[]` |  | The list of user accounts to be created on each node in the pool. |
| `userAssignedIdentities` | object | `{object}` |  | The user identities associated with the Batch pool. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed batch account pool. |
| `resourceGroupName` | string | The resource group of the deployed batch account pool. |
| `resourceId` | string | The resource ID of the deployed batch account pool. |
