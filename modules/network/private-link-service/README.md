# Private Link Services `[Microsoft.Network/privateLinkServices]`

This module deploys a Private Link Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/privateLinkServices` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/privateLinkServices) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.private-link-service:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br:bicep/modules/network.private-link-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nplsmin'
  params: {
    // Required parameters
    name: 'nplsmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ipConfigurations: [
      {
        name: 'nplsmin01'
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
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
      "value": "nplsmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmin01",
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br:bicep/modules/network.private-link-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nplsmax'
  params: {
    // Required parameters
    name: 'nplsmax001'
    // Non-required parameters
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableProxyProtocol: true
    fqdns: [
      'nplsmax.plsfqdn01.azure.privatelinkservice'
      'nplsmax.plsfqdn02.azure.privatelinkservice'
    ]
    ipConfigurations: [
      {
        name: 'nplsmax01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    visibility: {
      subscriptions: [
        '<subscriptionId>'
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
      "value": "nplsmax001"
    },
    // Non-required parameters
    "autoApproval": {
      "value": {
        "subscriptions": [
          "*"
        ]
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplsmax.plsfqdn01.azure.privatelinkservice",
        "nplsmax.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmax01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "visibility": {
      "value": {
        "subscriptions": [
          "<subscriptionId>"
        ]
      }
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkService 'br:bicep/modules/network.private-link-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nplswaf'
  params: {
    // Required parameters
    name: 'nplswaf001'
    // Non-required parameters
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableProxyProtocol: true
    fqdns: [
      'nplswaf.plsfqdn01.azure.privatelinkservice'
      'nplswaf.plsfqdn02.azure.privatelinkservice'
    ]
    ipConfigurations: [
      {
        name: 'nplswaf01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    visibility: {
      subscriptions: [
        '<subscriptionId>'
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
      "value": "nplswaf001"
    },
    // Non-required parameters
    "autoApproval": {
      "value": {
        "subscriptions": [
          "*"
        ]
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplswaf.plsfqdn01.azure.privatelinkservice",
        "nplswaf.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplswaf01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "visibility": {
      "value": {
        "subscriptions": [
          "<subscriptionId>"
        ]
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the private link service to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoApproval`](#parameter-autoapproval) | object | The auto-approval list of the private link service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableProxyProtocol`](#parameter-enableproxyprotocol) | bool | Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header. |
| [`extendedLocation`](#parameter-extendedlocation) | object | The extended location of the load balancer. |
| [`fqdns`](#parameter-fqdns) | array | The list of Fqdn. |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | An array of private link service IP configurations. |
| [`loadBalancerFrontendIpConfigurations`](#parameter-loadbalancerfrontendipconfigurations) | array | An array of references to the load balancer IP configurations. The Private Link service is tied to the frontend IP address of a Standard Load Balancer. All traffic destined for the service will reach the frontend of the SLB. You can configure SLB rules to direct this traffic to appropriate backend pools where your applications are running. Load balancer frontend IP configurations are different than NAT IP configurations. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags to be applied on all resources/resource groups in this deployment. |
| [`visibility`](#parameter-visibility) | object | Controls the exposure settings for your Private Link service. Service providers can choose to limit the exposure to their service to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions. |

### Parameter: `autoApproval`

The auto-approval list of the private link service.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableProxyProtocol`

Lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `extendedLocation`

The extended location of the load balancer.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `fqdns`

The list of Fqdn.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `ipConfigurations`

An array of private link service IP configurations.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `loadBalancerFrontendIpConfigurations`

An array of references to the load balancer IP configurations. The Private Link service is tied to the frontend IP address of a Standard Load Balancer. All traffic destined for the service will reach the frontend of the SLB. You can configure SLB rules to direct this traffic to appropriate backend pools where your applications are running. Load balancer frontend IP configurations are different than NAT IP configurations.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all Resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `name`

Name of the private link service to create.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags to be applied on all resources/resource groups in this deployment.
- Required: No
- Type: object

### Parameter: `visibility`

Controls the exposure settings for your Private Link service. Service providers can choose to limit the exposure to their service to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions.
- Required: No
- Type: object
- Default: `{}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private link service. |
| `resourceGroupName` | string | The resource group the private link service was deployed into. |
| `resourceId` | string | The resource ID of the private link service. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `ipConfigurations`

This property refers to the NAT (Network Address Translation) IP configuration for the Private Link service. The NAT IP can be chosen from any subnet in a service provider's virtual network. Private Link service performs destination side NAT-ing on the Private Link traffic. This ensures that there is no IP conflict between source (consumer side) and destination (service provider) address space. On the destination side (service provider side), the NAT IP address will show up as Source IP for all packets received by your service and destination IP for all packets sent by your service.

<details>

<summary>Parameter JSON format</summary>

```json
"ipConfigurations": {
  "value": [
    // Example showing only mandatory fields
    {
      "name": "minpls01", // Name of the IP configuration
      "properties": {
        "subnet": {
          "id": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-[[namePrefix]]-az-vnet-x-001/subnets/[[namePrefix]]-az-subnet-x-001" // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
        }
      }
    },
    // Example showing commonly used fields
    {
      "name": "pls01", // Name of the IP configuration
      "properties": {
        "primary": false, // Whether the ip configuration is primary or not
        "privateIPAddressVersion": "IPv4", // Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4
        "privateIPAllocationMethod": "Static", // The private IP address allocation method
        "privateIPAddress": "10.0.1.10", // If "privateIPAllocationMethod" is set to "Static" then this needs to be supplied
        "subnet": {
          "id": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-[[namePrefix]]-az-vnet-x-001/subnets/[[namePrefix]]-az-subnet-x-001" // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
        }
      }
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
ipConfigurations: [
  // Example showing only mandatory fields
  {
    name: 'minpls01' // Name of the IP configuration
    properties: {
      subnet: {
        id: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-[[namePrefix]]-az-vnet-x-001/subnets/[[namePrefix]]-az-subnet-x-001' // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
      }
    }
  }
  // Example showing commonly used fields
  {
    name: 'pls01' // Name of the IP configuration
    properties: {
      primary: false // Whether the ip configuration is primary or not
      privateIPAddressVersion: 'IPv4' // Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4
      privateIPAllocationMethod: 'Static' // Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4
      privateIPAddress: '10.0.1.10' // If "privateIPAllocationMethod" is set to "Static" then this needs to be supplied
      subnet: {
        id: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-[[namePrefix]]-az-vnet-x-001/subnets/[[namePrefix]]-az-subnet-x-001' // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
      }
    }
  }
]
```

</details>
<p>

### Parameter Usage: `extendedLocation`

This is the Edge Zone ID of the Edge Zone corresponding to the region in which the resource is deployed. More information is available here: [Azure Edge Zone ID](https://learn.microsoft.com/en-us/azure/public-multi-access-edge-compute-mec/key-concepts#azure-edge-zone-id).

<details>

<summary>Parameter JSON format</summary>

```json
"extendedLocation": {
  // Example showing usage of the extendedLocation param
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
  // Example showing usage of the extendedLocation param
  name: 'attdallas1' // Edge Zone ID for the parent South Central US region is "attdallas1".
  type: 'EdgeZone' // Fixed value
}
```

</details>
<p>

### Parameter Usage: `autoApproval`

Auto-approval controls the automated access to the Private Link service. The subscriptions specified in the auto-approval list are approved automatically when a connection is requested from private endpoints in those subscriptions.

<details>

<summary>Parameter JSON format</summary>

```json
// Example to auto-approve for all the subscriptions present under the "visibility" param
"autoApproval": {
  "value": [
    "*"
  ]
}

// Example to auto-approve a specific set of subscriptions. This should always be a subset of the subscriptions provided under the "visibility" param
"autoApproval": {
  "value": [
    "12345678-1234-1234-1234-123456781234", // Subscription 1
    "87654321-1234-1234-1234-123456781234" // Subscription 2
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
// Example to auto-approve for all the subscriptions present under the "visibility" param
autoApproval: [
  "*"
]

// Example to auto-approve a specific set of subscriptions. This should always be a subset of the subscriptions provided under "visibility"
autoApproval: [
  '12345678-1234-1234-1234-123456781234' // Subscription 1
  '87654321-1234-1234-1234-123456781234' // Subscription 2
]
```

</details>
<p>
