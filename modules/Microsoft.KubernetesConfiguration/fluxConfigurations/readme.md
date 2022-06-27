# Kubernetes Configuration Flux Configurations `[Microsoft.KubernetesConfiguration/fluxConfigurations]`

This module deploys Kubernetes Configuration Flux Configurations.

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
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `clusterName` | string |  | The name of the AKS cluster that should be configured. |
| `name` | string |  | The name of the Flux Configuration. |
| `namespace` | string |  | The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only. |
| `scope` | string | `[cluster, namespace]` | Scope at which the configuration will be installed. |
| `sourceKind` | string | `[Bucket, GitRepository]` | Source Kind to pull the configuration data from. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `bucket` | object | `{object}` | Parameters to reconcile to the GitRepository source kind type. |
| `configurationProtectedSettings` | object | `{object}` | Key-value pairs of protected configuration settings for the configuration. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `gitRepository` | object | `{object}` | Parameters to reconcile to the GitRepository source kind type. |
| `kustomizations` | object | `{object}` | Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster. |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `suspend` | bool | `False` | Whether this configuration should suspend its reconciliation of its kustomizations and sources. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the flux configuration. |
| `resourceGroupName` | string | The name of the resource group the flux configuration was deployed into. |
| `resourceId` | string | The resource ID of the flux configuration. |

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
            "value": "flux2"
        },
        "scope": {
            "value": "cluster"
        },
        "clusterName": {
            "value": "<<namePrefix>>-az-aks-kubenet-001"
        },
        "namespace": {
            "value": "flux-system"
        },
        "sourceKind": {
            "value": "GitRepository"
        },
        "gitRepository": {
            "value": {
                "url": "https://github.com/mspnp/aks-baseline",
                "timeoutInSeconds": 180,
                "syncIntervalInSeconds": 300,
                "repositoryRef": {
                    "branch": "main"
                },
                "sshKnownHosts": ""
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfigurations './Microsoft.KubernetesConfiguration/fluxConfigurations/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-fluxConfigurations'
  params: {
    name: 'flux2'
    scope: 'cluster'
    clusterName: '<<namePrefix>>-az-aks-kubenet-001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    gitRepository: {
      url: 'https://github.com/mspnp/aks-baseline'
      timeoutInSeconds: 180
      syncIntervalInSeconds: 300
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
    }
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
            "value": "flux2"
        },
        "scope": {
            "value": "cluster"
        },
        "clusterName": {
            "value": "<<namePrefix>>-az-aks-kubenet-001"
        },
        "namespace": {
            "value": "flux-system"
        },
        "sourceKind": {
            "value": "GitRepository"
        },
        "gitRepository": {
            "value": {
                "url": "https://github.com/mspnp/aks-baseline",
                "timeoutInSeconds": 180,
                "syncIntervalInSeconds": 300,
                "repositoryRef": {
                    "branch": "main"
                },
                "sshKnownHosts": ""
            }
        },
        "kustomizations": {
            "value": {
                "unified": {
                    "path": "./cluster-manifests",
                    "dependsOn": [],
                    "timeoutInSeconds": 300,
                    "syncIntervalInSeconds": 300,
                    "prune": true,
                    "force": false
                }
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfigurations './Microsoft.KubernetesConfiguration/fluxConfigurations/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-fluxConfigurations'
  params: {
    name: 'flux2'
    scope: 'cluster'
    clusterName: '<<namePrefix>>-az-aks-kubenet-001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    gitRepository: {
      url: 'https://github.com/mspnp/aks-baseline'
      timeoutInSeconds: 180
      syncIntervalInSeconds: 300
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
    }
    kustomizations: {
      unified: {
        path: './cluster-manifests'
        dependsOn: []
        timeoutInSeconds: 300
        syncIntervalInSeconds: 300
        prune: true
        force: false
      }
    }
  }
}
```

</details>
<p>
