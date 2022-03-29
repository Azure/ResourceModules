# KubernetesConfiguration Extensions `[Microsoft.KubernetesConfiguration/extensions]`

This module deploys KubernetesConfiguration Extensions.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KubernetesConfiguration/extensions` | 2022-03-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `extensionType` | string | Type of the Extension, of which this resource is an instance of. It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher. |
| `name` | string | The name of the Flux Configuration |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `autoUpgradeMinorVersion` | bool | `True` | Flag to note if this extension participates in auto upgrade of minor version, or not. |
| `clusterName` | string |  | The name of the AKS cluster that should be configured. |
| `configurationProtectedSettings` | object | `{object}` | Configuration settings that are sensitive, as name-value pairs for configuring this extension. |
| `configurationSettings` | object | `{object}` | Configuration settings, as name-value pairs for configuring this extension. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `releaseNamespace` | string |  | Namespace where the extension Release must be placed, for a Cluster scoped extension. If this namespace does not exist, it will be created |
| `releaseTrain` | string | `Stable` | ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is "true". |
| `targetNamespace` | string |  | Namespace where the extension will be created for an Namespace scoped extension. If this namespace does not exist, it will be created |
| `version` | string |  | Version of the extension for this extension, if it is "pinned" to a specific version. autoUpgradeMinorVersion must be "false". |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the extension |
| `resourceGroupName` | string | The name of the resource group the extension was deployed into |
| `resourceId` | string | The resource ID of the extension |

## Template references

- [Extensions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions)
