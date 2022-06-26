# Service Bus Namespaces `[Microsoft.ServiceBus/namespaces]`

This module deploys a service bus namespace resource.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.ServiceBus/namespaces` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces) |
| `Microsoft.ServiceBus/namespaces/AuthorizationRules` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/AuthorizationRules) |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/disasterRecoveryConfigs) |
| `Microsoft.ServiceBus/namespaces/ipfilterrules` | [2018-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/ipfilterrules) |
| `Microsoft.ServiceBus/namespaces/migrationConfigurations` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/migrationConfigurations) |
| `Microsoft.ServiceBus/namespaces/queues` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/queues) |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/queues/authorizationRules) |
| `Microsoft.ServiceBus/namespaces/topics` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics) |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics/authorizationRules) |
| `Microsoft.ServiceBus/namespaces/virtualnetworkrules` | [2018-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/virtualnetworkrules) |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `skuName` | string | `'Basic'` | `[Basic, Standard, Premium]` | Name of this SKU. - Basic, Standard, Premium. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | _[authorizationRules](authorizationRules/readme.md)_ array | `[System.Collections.Hashtable]` |  | Authorization Rules for the Service Bus namespace. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[OperationalLogs]` | `[OperationalLogs]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disasterRecoveryConfigs` | _[disasterRecoveryConfigs](disasterRecoveryConfigs/readme.md)_ object | `{object}` |  | The disaster recovery configuration. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ipFilterRules` | _[ipFilterRules](ipFilterRules/readme.md)_ array | `[]` |  | IP Filter Rules for the Service Bus namespace. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `migrationConfigurations` | _[migrationConfigurations](migrationConfigurations/readme.md)_ object | `{object}` |  | The migration configuration. |
| `name` | string | `''` |  | Name of the Service Bus Namespace. If no name is provided, then unique name will be created. |
| `privateEndpoints` | array | `[]` |  | Configuration Details for private endpoints. |
| `queues` | _[queues](queues/readme.md)_ array | `[]` |  | The queues to create in the service bus namespace. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `topics` | _[topics](topics/readme.md)_ array | `[]` |  | The topics to create in the service bus namespace. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkRules` | _[virtualNetworkRules](virtualNetworkRules/readme.md)_ array | `[]` |  | vNet Rules SubnetIds for the Service Bus namespace. |
| `zoneRedundant` | bool | `False` |  | Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones. |

**Generated parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Do not provide a value! This date value is used to generate a SAS token to access the modules. |


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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed service bus namespace. |
| `resourceGroupName` | string | The resource group of the deployed service bus namespace. |
| `resourceId` | string | The resource ID of the deployed service bus namespace. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {}
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module namespaces './Microsoft.ServiceBus/namespaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-namespaces'
  params: {

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
            "value": "<<namePrefix>>-az-sbn-x-002"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "skuName": {
            "value": "Premium"
        },
        "tags": {
            "value": {}
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
        "disasterRecoveryConfigs": {
            "value": {}
        },
        "migrationConfigurations": {
            "value": {}
        },
        "virtualNetworkRules": {
            "value": [
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-003"
            ]
        },
        "ipFilterRules": {
            "value": [
                {
                    "filterName": "ipFilter1",
                    "ipMask": "10.0.1.0/32",
                    "action": "Accept"
                },
                {
                    "filterName": "ipFilter2",
                    "ipMask": "10.0.2.0/32",
                    "action": "Accept"
                }
            ]
        },
        "authorizationRules": {
            "value": [
                {
                    "name": "RootManageSharedAccessKey",
                    "rights": [
                        "Listen",
                        "Manage",
                        "Send"
                    ]
                },
                {
                    "name": "AnotherKey",
                    "rights": [
                        "Listen",
                        "Send"
                    ]
                }
            ]
        },
        "queues": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-sbq-x-002",
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ],
                    "authorizationRules": [
                        {
                            "name": "RootManageSharedAccessKey",
                            "rights": [
                                "Listen",
                                "Manage",
                                "Send"
                            ]
                        },
                        {
                            "name": "AnotherKey",
                            "rights": [
                                "Listen",
                                "Send"
                            ]
                        }
                    ]
                }
            ]
        },
        "topics": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-sbt-x-001",
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ],
                    "authorizationRules": [
                        {
                            "name": "RootManageSharedAccessKey",
                            "rights": [
                                "Listen",
                                "Manage",
                                "Send"
                            ]
                        },
                        {
                            "name": "AnotherKey",
                            "rights": [
                                "Listen",
                                "Send"
                            ]
                        }
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "privateEndpoints": {
            "value": [
                {
                    "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints",
                    "service": "namespace"
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
module namespaces './Microsoft.ServiceBus/namespaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-namespaces'
  params: {
    name: '<<namePrefix>>-az-sbn-x-002'
    lock: 'CanNotDelete'
    skuName: 'Premium'
    tags: {}
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    disasterRecoveryConfigs: {}
    migrationConfigurations: {}
    virtualNetworkRules: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-003'
    ]
    ipFilterRules: [
      {
        filterName: 'ipFilter1'
        ipMask: '10.0.1.0/32'
        action: 'Accept'
      }
      {
        filterName: 'ipFilter2'
        ipMask: '10.0.2.0/32'
        action: 'Accept'
      }
    ]
    authorizationRules: [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'AnotherKey'
        rights: [
          'Listen'
          'Send'
        ]
      }
    ]
    queues: [
      {
        name: '<<namePrefix>>-az-sbq-x-002'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              '<<deploymentSpId>>'
            ]
          }
        ]
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
      }
    ]
    topics: [
      {
        name: '<<namePrefix>>-az-sbt-x-001'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              '<<deploymentSpId>>'
            ]
          }
        ]
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    privateEndpoints: [
      {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
        service: 'namespace'
      }
    ]
  }
}
```

</details>
<p>
