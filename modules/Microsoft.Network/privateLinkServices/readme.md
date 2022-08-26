# Network PrivateLinkServices `[Microsoft.Network/privateLinkServices]`

This module deploys Network PrivateLinkServices.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
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


### Parameter Usage: `ipConfigurations`

This property refers to the NAT (Network Address Translation) IP configuration for the Private Link service. The NAT IP can be chosen from any subnet in a service provider's virtual network. Private Link service performs destination side NAT-ing on the Private Link traffic. This ensures that there is no IP conflict between source (consumer side) and destination (service provider) address space. On the destination side (service provider side), the NAT IP address will show up as Source IP for all packets received by your service and destination IP for all packets sent by your service.

### Parameter Usage: `loadBalancerFrontendIpConfigurations`

Private Link service is tied to the frontend IP address of a Standard Load Balancer. All traffic destined for the service will reach the frontend of the SLB. You can configure SLB rules to direct this traffic to appropriate backend pools where your applications are running. Load balancer frontend IP configurations are different than NAT IP configurations.

### Parameter Usage: `extendedLocation`

This is the Edge Zone ID of the Edge Zone corresponding to the region in which the resource is deployed. More information is available here: [Azure Edge Zone ID](https://docs.microsoft.com/en-us/azure/public-multi-access-edge-compute-mec/key-concepts#azure-edge-zone-id). Note that this feature is in private preview at the time of publishing this module and hence, might not be available for all the users.

<details>

<summary>Parameter JSON format</summary>

```json
"extendedLocation": {
  "value": {
    "name": "attatlanta1", // Edge Zone ID for the parent East US 2 region is "attatlanta1"
    "type": "EdgeZone" // Fixed value
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extendedLocation: {
  name: 'attdallas1' // Edge Zone ID for the parent South Central US region is "attdallas1".
  type: 'EdgeZone'
}
```

</details>
<p>

### Parameter Usage: `autoApproval`

Auto-approval controls the automated access to the Private Link service. The subscriptions specified in the auto-approval list are approved automatically when a connection is requested from private endpoints in those subscriptions.

### Parameter Usage: `visibility`

Visibility is the property that controls the exposure settings for your Private Link service. Service providers can choose to limit the exposure to their service to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions.

### Parameter Usage: `enableProxyProtocol`

This property lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header.

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
