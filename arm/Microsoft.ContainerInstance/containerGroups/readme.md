# ContainerInstances

### Container groups in Azure Container Instances

The top-level resource in Azure Container Instances is the container group. A container group is a collection of containers that get scheduled on the same host machine. The containers in a container group share a lifecycle, resources, local network, and storage volumes. It's similar in concept to a pod in Kubernetes.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments` | 2018-02-01 |
| `Microsoft.ContainerInstance/containerGroups` | 2019-12-01 |
| `providers/locks` | 2016-09-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Allowed Values |
| :-- | :-- | :-- | :-- | :-- |
| `containergroupname` | string | Required. Name for the container group. |  |  |
| `containername` | string | Required. Name for the container. |  |  |
| `cpuCores` | string | Optional. The number of CPU cores to allocate to the container. | 1.0 |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `environmentVariables` | array | Optional. Envrionment variables of the container group. | System.Object[] |  |
| `image` | string | Required. Name of the image. |  |  |
| `imageRegistryCredentials` | array | Optional. The image registry credentials by which the container group is created from. | System.Object[] |  |
| `ipAddressType` | string | Optional. Specifies if the IP is exposed to the public internet or private VNET. - Public or Private | Public |  |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock resource from deletion. | False |  |
| `memoryInGB` | string | Optional. The amount of memory to allocate to the container in gigabytes. | 1.5 |  |
| `osType` | string | Optional. The operating system type required by the containers in the container group. - Windows or Linux. | Linux |  |
| `ports` | array | Optional. Port to open on the container and the public IP address. | System.Object[] |  |
| `restartPolicy` | string | Optional. Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never | Always |  |
| `tags` | object | Optional. Tags of the resource. |  |  |

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `containerGroupIPv4Address` | string |  |
| `containerGroupName` | string | The Name of the resource |
| `containerGroupResourceGroup` | string | The name of the Resource Group the resource resides |
| `containerGroupResourceId` | string | The Resource Id of the resource |

### References

#### Template references

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [ContainerGroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2019-12-01/containerGroups)

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [ContainerGroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2019-12-01/containerGroups)
