# Container Instances `[Microsoft.ContainerInstance/containerGroups]`

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

### Container groups in Azure Container Instances

The top-level resource in Azure Container Instances is the container group. A container group is a collection of containers that get scheduled on the same host machine. The containers in a container group share a lifecycle, resources, local network, and storage volumes. It's similar in concept to a pod in Kubernetes.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.ContainerInstance/containerGroups` | [2021-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2021-03-01/containerGroups) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `containername` | string | Name for the container. |
| `image` | string | Name of the image. |
| `name` | string | Name for the container group. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cpuCores` | int | `2` |  | The number of CPU cores to allocate to the container. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `environmentVariables` | array | `[]` |  | Environment variables of the container group. |
| `imageRegistryCredentials` | array | `[]` |  | The image registry credentials by which the container group is created from. |
| `ipAddressType` | string | `'Public'` |  | Specifies if the IP is exposed to the public internet or private VNET. - Public or Private. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `memoryInGB` | int | `2` |  | The amount of memory to allocate to the container in gigabytes. |
| `osType` | string | `'Linux'` |  | The operating system type required by the containers in the container group. - Windows or Linux. |
| `ports` | array | `[System.Collections.Hashtable]` |  | Port to open on the container and the public IP address. |
| `restartPolicy` | string | `'Always'` |  | Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `imageRegistryCredentials`

The image registry credentials by which the container group is created from.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
imageRegistryCredentials: [
    {
        server: 'sxxazacrx001.azurecr.io'
        username: 'sxxazacrx001'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

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
| `iPv4Address` | string | The IPv4 address of the container group. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the container group. |
| `resourceGroupName` | string | The resource group the container group was deployed into. |
| `resourceId` | string | The resource ID of the container group. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

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
            "value": "<<namePrefix>>-az-acg-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "containerName": {
            "value": "<<namePrefix>>-az-aci-x-001"
        },
        "image": {
            "value": "mcr.microsoft.com/azuredocs/aci-helloworld"
        },
        "ports": {
            "value": [
                {
                    "protocol": "Tcp",
                    "port": "80"
                },
                {
                    "protocol": "Tcp",
                    "port": "443"
                }
            ]
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module containerGroups './Microsoft.ContainerInstance/containerGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-containerGroups'
  params: {
    name: '<<namePrefix>>-az-acg-x-001'
    lock: 'CanNotDelete'
    containerName: '<<namePrefix>>-az-aci-x-001'
    image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
    ports: [
      {
        protocol: 'Tcp'
        port: '80'
      }
      {
        protocol: 'Tcp'
        port: '443'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
  }
}
```

</details>
<p>
