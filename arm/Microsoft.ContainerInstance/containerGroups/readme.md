# ContainerInstances `[Microsoft.ContainerInstance/containerGroups]`

### Container groups in Azure Container Instances

The top-level resource in Azure Container Instances is the container group. A container group is a collection of containers that get scheduled on the same host machine. The containers in a container group share a lifecycle, resources, local network, and storage volumes. It's similar in concept to a pod in Kubernetes.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.ContainerInstance/containerGroups` | 2021-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `containergroupname` | string |  |  | Required. Name for the container group. |
| `containername` | string |  |  | Required. Name for the container. |
| `cpuCores` | int | `2` |  | Optional. The number of CPU cores to allocate to the container. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `environmentVariables` | array | `[]` |  | Optional. Envrionment variables of the container group. |
| `image` | string |  |  | Required. Name of the image. |
| `imageRegistryCredentials` | array | `[]` |  | Optional. The image registry credentials by which the container group is created from. |
| `ipAddressType` | string | `Public` |  | Optional. Specifies if the IP is exposed to the public internet or private VNET. - Public or Private |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `memoryInGB` | int | `2` |  | Optional. The amount of memory to allocate to the container in gigabytes. |
| `osType` | string | `Linux` |  | Optional. The operating system type required by the containers in the container group. - Windows or Linux. |
| `ports` | array | `[System.Collections.Hashtable]` |  | Optional. Port to open on the container and the public IP address. |
| `restartPolicy` | string | `Always` |  | Optional. Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

### Parameter Usage: `imageRegistryCredentials`

The image registry credentials by which the container group is created from.

```json
    "imageRegistryCredentials": {
      "value": [
        {
          "server": "sxxazacrx001.azurecr.io",
          "username": "sxxazacrx001"
        }
      ]
    }
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type |
| :-- | :-- |
| `containerGroupIPv4Address` | string |
| `containerGroupName` | string |
| `containerGroupResourceGroup` | string |
| `containerGroupResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Containergroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2021-03-01/containerGroups)
