# AVS PrivateClouds Clusters Datastores `[Microsoft.AVS/privateClouds/clusters/datastores]`

This module deploys AVS PrivateClouds Clusters Datastores.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AVS/privateClouds/clusters/datastores` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.AVS/privateClouds/clusters/datastores) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the datastore in the private cloud cluster |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `clusterName` | string | The name of the parent clusters. Required if the template is used in a standalone deployment. |
| `privateCloudName` | string | The name of the parent privateClouds. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `diskPoolVolume` | object | `{object}` | An iSCSI volume from Microsoft.StoragePool provider |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `netAppVolume` | object | `{object}` | An Azure NetApp Files volume from Microsoft.NetApp provider |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the datastore. |
| `resourceGroupName` | string | The name of the resource group the datastore was created in. |
| `resourceId` | string | The resource ID of the datastore. |

## Cross-referenced modules

_None_
