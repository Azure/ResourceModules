# Kubernetes Configuration Extensions `[Microsoft.KubernetesConfiguration/extensions]`

This module deploys Kubernetes Configuration Extensions.

## Navigation

- [Prerequisites](#Prerequisites)
- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Prerequisites

Registration of your subscription with the AKS-ExtensionManager feature flag. Use the following command:

```powershell
az feature register --namespace Microsoft.ContainerService --name AKS-ExtensionManager
```

Registration of the following Azure service providers. (It's OK to re-register an existing provider.)

```powershell
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration
```

For Details see [Prerequisites](https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `clusterName` | string | The name of the AKS cluster that should be configured. |
| `extensionType` | string | Type of the Extension, of which this resource is an instance of. It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher. |
| `name` | string | The name of the Flux Configuration. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `configurationProtectedSettings` | object | `{object}` | Configuration settings that are sensitive, as name-value pairs for configuring this extension. |
| `configurationSettings` | object | `{object}` | Configuration settings, as name-value pairs for configuring this extension. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `releaseNamespace` | string | `''` | Namespace where the extension Release must be placed, for a Cluster scoped extension. If this namespace does not exist, it will be created. |
| `releaseTrain` | string | `'Stable'` | ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is "true". |
| `targetNamespace` | string | `''` | Namespace where the extension will be created for an Namespace scoped extension. If this namespace does not exist, it will be created. |
| `version` | string | `''` | Version of the extension for this extension, if it is "pinned" to a specific version. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The name of the resource group the extension was deployed into. |
| `resourceId` | string | The resource ID of the extension. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "flux"
        },
        "extensionType": {
            "value": "microsoft.flux"
        },
        "clusterName": {
            "value": "<<namePrefix>>-az-aks-kubenet-001"
        },
        "releaseTrain": {
            "value": "Stable"
        },
        "releaseNamespace": {
            "value": "flux-system"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module extensions './Microsoft.KubernetesConfiguration/extensions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-extensions'
  params: {
    name: 'flux'
    extensionType: 'microsoft.flux'
    clusterName: '<<namePrefix>>-az-aks-kubenet-001'
    releaseTrain: 'Stable'
    releaseNamespace: 'flux-system'
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "flux"
        },
        "extensionType": {
            "value": "microsoft.flux"
        },
        "clusterName": {
            "value": "<<namePrefix>>-az-aks-kubenet-001"
        },
        "releaseTrain": {
            "value": "Stable"
        },
        "releaseNamespace": {
            "value": "flux-system"
        },
        "version": {
            "value": "0.5.2"
        },
        "configurationSettings": {
            "value": {
                // "helm-controller.enabled": "false",
                "source-controller.enabled": "true",
                "kustomize-controller.enabled": "true",
                "notification-controller.enabled": "false",
                "image-automation-controller.enabled": "false",
                "image-reflector-controller.enabled": "false"
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module extensions './Microsoft.KubernetesConfiguration/extensions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-extensions'
  params: {
    name: 'flux'
    extensionType: 'microsoft.flux'
    clusterName: '<<namePrefix>>-az-aks-kubenet-001'
    releaseTrain: 'Stable'
    releaseNamespace: 'flux-system'
    version: '0.5.2'
    configurationSettings: {
      'source-controller.enabled': 'true'
      'kustomize-controller.enabled': 'true'
      'notification-controller.enabled': 'false'
      'image-automation-controller.enabled': 'false'
      'image-reflector-controller.enabled': 'false'
    }
  }
}
```

</details>
<p>
