# Network PrivateLinkServices `[Microsoft.Network/privateLinkServices]`

This module deploys Network PrivateLinkServices.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Network/privateLinkServices` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-01-01/privateLinkServices) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the private link service to create. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoApproval` | object | `{object}` |  | The auto-approval list of the private link service. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enableProxyProtocol` | bool | `False` |  | Whether the private link service is enabled for proxy protocol or not. |
| `extendedLocation` | object | `{object}` |  | The extended location of the load balancer. |
| `fqdns` | array | `[]` |  | The list of Fqdn. |
| `ipConfigurations` | array | `[]` |  | An array of private link service IP configurations. |
| `loadBalancerFrontendIpConfigurations` | array | `[]` |  | An array of references to the load balancer IP configurations. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags to be applied on all resources/resource groups in this deployment. |
| `visibility` | object | `{object}` |  | The visibility list of the private link service. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private link service. |
| `resourceGroupName` | string | The resource group the private link service was deployed into. |
| `resourceId` | string | The resource ID of the private link service. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.
   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkServices './Microsoft.Network/privateLinkServices/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-privateLinkServices'
  params: {
    // Required parameters
    name: '<<namePrefix>>-az-pls-min-001'
    // Non-required parameters
    ipConfigurations: [
      {
        name: 'minpls01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/frontendIPConfigurations/privateIPConfig1'
      }
    ]
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<<deploymentSpId>>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-az-pls-min-001"
    },
    // Non-required parameters
    "ipConfigurations": {
      "value": [
        {
          "name": "minpls01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/frontendIPConfigurations/privateIPConfig1"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<<deploymentSpId>>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 2: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkServices './Microsoft.Network/privateLinkServices/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-privateLinkServices'
  params: {
    // Required parameters
    name: '<<namePrefix>>-az-pls-001'
    // Non-required parameters
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    enableProxyProtocol: true
    fqdns: [
      '<<namePrefix>>.plsfqdn01.azure.privatelinkservice'
      '<<namePrefix>>.plsfqdn02.azure.privatelinkserivce'
    ]
    ipConfigurations: [
      {
        name: 'pls01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/frontendIPConfigurations/privateIPConfig2'
      }
    ]
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<<deploymentSpId>>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    visibility: {
      subscriptions: [
        '<<subscriptionId>>'
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-az-pls-001"
    },
    // Non-required parameters
    "autoApproval": {
      "value": {
        "subscriptions": [
          "*"
        ]
      }
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "<<namePrefix>>.plsfqdn01.azure.privatelinkservice",
        "<<namePrefix>>.plsfqdn02.azure.privatelinkserivce"
      ]
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "pls01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/frontendIPConfigurations/privateIPConfig2"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<<deploymentSpId>>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "visibility": {
      "value": {
        "subscriptions": [
          "<<subscriptionId>>"
        ]
      }
    }
  }
}
```

</details>
<p>
