# SignalRService `[Microsoft.SignalRService/webPubSub]`

This module deploys a Web PubSub resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Network/privateEndpoints` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.SignalRService/webPubSub` | [2021-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.SignalRService/2021-10-01/webPubSub) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Web PubSub resource. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `capacity` | int | `1` |  | The unit count of the resource. 1 by default. |
| `clientCertEnabled` | bool | `False` |  | Request client certificate during TLS handshake if enabled. |
| `disableAadAuth` | bool | `False` |  | When set as true, connection with AuthType=aad won't work. |
| `disableLocalAuth` | bool | `True` |  | Disables all authentication methods other than AAD authentication. For security reasons, this value should be set to `true`. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | The location for all Web PubSub resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `networkAcls` | object | `{object}` |  | Networks ACLs, this value contains IPs to whitelist and/or Subnet information. Can only be set if the 'SKU' is not 'Free_F1'. For security reasons, it is recommended to set the DefaultAction Deny. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `''` | `[, Enabled, Disabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| `resourceLogConfigurationsToEnable` | array | `[ConnectivityLogs, MessagingLogs]` | `[ConnectivityLogs, MessagingLogs]` | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | string | `'Standard_S1'` | `[Free_F1, Standard_S1]` | Pricing tier of App Configuration. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>", // e.g. vault, registry, file, blob, queue, table etc.
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>" // e.g. vault, registry, file, blob, queue, table etc.
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
        privateDnsZoneResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
            '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
        ]
        // Optional
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
    }
]
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

### Parameter Usage: `networkAcls`

Using this object you can configure the service's firewall. Note, that the `defaultAction` either allows all / denies all communication via the `publicNetwork` and `privateEndpoints`. You can subsequently allow/deny individual actions using the corresponding arrays.

Either block supports any array of values:
- 'ClientConnection'
- 'RESTAPI'
- 'ServerConnection'
- 'Trace'

<details>

<summary>Parameter JSON format</summary>

```json
"networkAcls": {
  "value": {
    "defaultAction": "Deny",
    "privateEndpoints": [
      {
        "name": "pe-<<namePrefix>>-az-pubsub-x-001-webpubsub-0",
        "allow": [
          "ServerConnection",
          "Trace"
        ],
        "deny": []
      }
    ],
    "publicNetwork": {
      "allow": [
        "RESTAPI",
        "Trace"
      ],
      "deny": []
    }
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkAcls: {
  defaultAction: 'Deny'
  privateEndpoints: [
    {
      name: 'pe-<<namePrefix>>-az-pubsub-x-001-webpubsub-0'
      allow: [
        'ServerConnection'
        'Trace'
      ],
      deny: []
    }
  ]
  publicNetwork: {
    allow: [
      'RESTAPI'
      'Trace'
    ]
    deny: []
  }
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `externalIP` | string | The Web PubSub externalIP. |
| `hostName` | string | The Web PubSub hostName. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Web PubSub name. |
| `publicPort` | int | The Web PubSub publicPort. |
| `resourceGroupName` | string | The Web PubSub resource group. |
| `resourceId` | string | The Web PubSub resource ID. |
| `serverPort` | int | The Web PubSub serverPort. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "value": "westeurope"
    },
    "name": {
      "value": "<<namePrefix>>-az-pubsub-min-001"
    }
  }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module webPubSub './Microsoft.SignalRService/webPubSub/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-webPubSub'
  params: {
    location: 'westeurope'
    name: '<<namePrefix>>-az-pubsub-min-001'
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
    "location": {
      "value": "westeurope"
    },
    "name": {
      "value": "<<namePrefix>>-az-pubsub-x-001"
    },
    "capacity": {
      "value": 2
    },
    "clientCertEnabled": {
      "value": false
    },
    "disableAadAuth": {
      "value": false
    },
    "disableLocalAuth": {
      "value": true
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "sku": {
      "value": "Standard_S1"
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
    },
    "networkAcls": {
      "value": {
        "defaultAction": "Allow",
        "privateEndpoints": [
          {
            "name": "pe-<<namePrefix>>-az-pubsub-x-001-webpubsub-0",
            "allow": [],
            "deny": [
              "ServerConnection",
              "Trace"
            ]
          }
        ],
        "publicNetwork": {
          "allow": [],
          "deny": [
            "RESTAPI",
            "Trace"
          ]
        }
      }
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "purpose": "test"
      }
    },
    "resourceLogConfigurationsToEnable": {
      "value": [
        "ConnectivityLogs"
      ]
    },
    "privateEndpoints": {
      "value": [
        {
          "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints",
          "service": "webpubsub"
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
module webPubSub './Microsoft.SignalRService/webPubSub/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-webPubSub'
  params: {
    location: 'westeurope'
    name: '<<namePrefix>>-az-pubsub-x-001'
    capacity: 2
    clientCertEnabled: false
    disableAadAuth: false
    disableLocalAuth: true
    lock: 'CanNotDelete'
    sku: 'Standard_S1'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      privateEndpoints: [
        {
          name: 'pe-<<namePrefix>>-az-pubsub-x-001-webpubsub-0'
          allow: []
          deny: [
            'ServerConnection'
            'Trace'
          ]
        }
      ]
      publicNetwork: {
        allow: []
        deny: [
          'RESTAPI'
          'Trace'
        ]
      }
    }
    systemAssignedIdentity: true
    tags: {
      purpose: 'test'
    }
    resourceLogConfigurationsToEnable: [
      'ConnectivityLogs'
    ]
    privateEndpoints: [
      {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
        service: 'webpubsub'
      }
    ]
  }
}
```

</details>
<p>
