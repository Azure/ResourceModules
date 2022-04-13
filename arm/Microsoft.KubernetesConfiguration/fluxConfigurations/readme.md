# Kubernetes Configuration Flux Configurations `[Microsoft.KubernetesConfiguration/fluxConfigurations]`

This module deploys Kubernetes Configuration Flux Configurations.

## Navigation

- [Prerequisites](#Prerequisites)
- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

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
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | 2022-03-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `clusterName` | string |  | The name of the AKS cluster that should be configured. |
| `name` | string |  | The name of the Flux Configuration |
| `namespace` | string |  | The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only. |
| `scope` | string | `[cluster, namespace]` | Scope at which the configuration will be installed. |
| `sourceKind` | string | `[Bucket, GitRepository]` | Source Kind to pull the configuration data from. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `bucket` | object | `{object}` | Parameters to reconcile to the GitRepository source kind type. |
| `configurationProtectedSettings` | object | `{object}` | Key-value pairs of protected configuration settings for the configuration |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `gitRepository` | object | `{object}` | Parameters to reconcile to the GitRepository source kind type. |
| `kustomizations` | object | `{object}` | Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster. |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `suspend` | bool | `False` | Whether this configuration should suspend its reconciliation of its kustomizations and sources. |


### Parameter Usage: `bucket`

```json
"bucket": {
    "value": {
      "accessKey": "string",
      "bucketName": "string",
      "insecure": "bool",
      "localAuthRef": "string",
      "syncIntervalInSeconds": "int",
      "timeoutInSeconds": "int",
      "url": "string"
    }
}
```

### Parameter Usage: `gitRepository`

```json
"gitRepository": {
    "value": {
      "httpsCACert": "string",
      "httpsUser": "string",
      "localAuthRef": "string",
      "repositoryRef": {
        "branch": "string",
        "commit": "string",
        "semver": "string",
        "tag": "string"
      },
      "sshKnownHosts": "string",
      "syncIntervalInSeconds": "int",
      "timeoutInSeconds": "int",
      "url": "string"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the flux configuration |
| `resourceGroupName` | string | The name of the resource group the flux configuration was deployed into |
| `resourceId` | string | The resource ID of the flux configuration |

## Template references

- [Fluxconfigurations](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations)
