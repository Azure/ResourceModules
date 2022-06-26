# Image Templates `[Microsoft.VirtualMachineImages/imageTemplates]`

This module deploys an image template that can be consumed by the Azure Image Builder (AIB) service.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.VirtualMachineImages/imageTemplates` | [2020-02-14](https://docs.microsoft.com/en-us/azure/templates/Microsoft.VirtualMachineImages/2020-02-14/imageTemplates) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `customizationSteps` | array | Customization steps to be run when building the VM image. |
| `imageSource` | object | Image source definition in object format. |
| `name` | string | Name of the Image Template to be built by the Azure Image Builder service. |
| `userMsiName` | string | Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `buildTimeoutInMinutes` | int | `0` |  | Image build timeout in minutes. Allowed values: 0-960. 0 means the default 240 minutes. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `imageReplicationRegions` | array | `[]` |  | List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment's location will be taken as a default value. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedImageName` | string | `''` |  | Name of the managed image that will be created in the AIB resourcegroup. |
| `osDiskSizeGB` | int | `128` |  | Specifies the size of OS disk. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sigImageDefinitionId` | string | `''` |  | Resource ID of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>. |
| `subnetId` | string | `''` |  | Resource ID of an already existing subnet, e.g. '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>'. If no value is provided, a new VNET will be created in the target Resource Group. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `unManagedImageName` | string | `''` |  | Name of the unmanaged image that will be created in the AIB resourcegroup. |
| `userMsiResourceGroup` | string | `[resourceGroup().name]` |  | Resource group of the user assigned identity. |
| `vmSize` | string | `'Standard_D2s_v3'` |  | Specifies the size for the VM. |

**Generated parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('yyyy-MM-dd-HH-mm-ss')]` | Do not provide a value! This date value is used to generate a unique image template name. |


### Parameter Usage: `imageSource`

Tag names and tag values can be provided as needed. A tag can be left without a value.

#### Platform Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "PlatformImage",
    "publisher": "MicrosoftWindowsDesktop",
    "offer": "Windows-10",
    "sku": "19h2-evd",
    "version": "latest"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'PlatformImage'
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'Windows-10'
    sku: '19h2-evd'
    version: 'latest'
}
```

</details>
<p>

#### Managed Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "ManagedImage",
    "imageId": "/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'ManagedImage'
    imageId: '/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>'
}
```

</details>
<p>

#### Shared Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "SharedImageVersion",
    "imageVersionID": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'SharedImageVersion'
    imageVersionID: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>'
}
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

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the image template. |
| `resourceGroupName` | string | The resource group the image template was deployed into. |
| `resourceId` | string | The resource ID of the image template. |
| `runThisCommand` | string | The command to run in order to trigger the image build. |

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
            "value": "<<namePrefix>>-az-imgt-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "userMsiName": {
            "value": "adp-<<namePrefix>>-az-msi-x-001"
        },
        "userMsiResourceGroup": {
            "value": "validation-rg"
        },
        "buildTimeoutInMinutes": {
            "value": 0
        },
        "vmSize": {
            "value": "Standard_D2s_v3"
        },
        "osDiskSizeGB": {
            "value": 127
        },
        "subnetId": {
            "value": ""
        },
        "imageSource": {
            "value": {
                "type": "PlatformImage",
                "publisher": "MicrosoftWindowsDesktop",
                "offer": "Windows-10",
                "sku": "19h2-evd",
                "version": "latest"
            }
        },
        "customizationSteps": {
            "value": [
                {
                    "type": "WindowsRestart",
                    "restartTimeout": "30m"
                }
            ]
        },
        "managedImageName": {
            "value": "<<namePrefix>>-az-mi-x-001"
        },
        "unManagedImageName": {
            "value": "<<namePrefix>>-az-umi-x-001"
        },
        "sigImageDefinitionId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Compute/galleries/adp<<namePrefix>>azsigweux001/images/adp-<<namePrefix>>-az-imgd-x-001"
        },
        "imageReplicationRegions": {
            "value": []
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module imageTemplates './Microsoft.VirtualMachineImages/imageTemplates/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-imageTemplates'
  params: {
    name: '<<namePrefix>>-az-imgt-x-001'
    lock: 'CanNotDelete'
    userMsiName: 'adp-<<namePrefix>>-az-msi-x-001'
    userMsiResourceGroup: 'validation-rg'
    buildTimeoutInMinutes: 0
    vmSize: 'Standard_D2s_v3'
    osDiskSizeGB: 127
    subnetId: ''
    imageSource: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsDesktop'
      offer: 'Windows-10'
      sku: '19h2-evd'
      version: 'latest'
    }
    customizationSteps: [
      {
        type: 'WindowsRestart'
        restartTimeout: '30m'
      }
    ]
    managedImageName: '<<namePrefix>>-az-mi-x-001'
    unManagedImageName: '<<namePrefix>>-az-umi-x-001'
    sigImageDefinitionId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Compute/galleries/adp<<namePrefix>>azsigweux001/images/adp-<<namePrefix>>-az-imgd-x-001'
    imageReplicationRegions: []
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>
