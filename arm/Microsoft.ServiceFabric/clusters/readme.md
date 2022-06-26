# Service Fabric Clusters `[Microsoft.ServiceFabric/clusters]`

This module deploys a Service Fabric Cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-04-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments) |
| `Microsoft.ServiceFabric/clusters` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters) |
| `Microsoft.ServiceFabric/clusters/applicationTypes` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applicationTypes) |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `managementEndpoint` | string |  | The http management endpoint of the cluster. |
| `maxUnusedVersionsToKeep` | int | `3` | Number of unused versions per application type to keep. |
| `name` | string | `''` | Name of the Service Fabric cluster. |
| `nodeTypes` | array | `[]` | The list of node types in the cluster. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addOnFeatures` | array | `[]` | `[BackupRestoreService, DnsService, RepairManager, ResourceMonitorService]` | The list of add-on features to enable in the cluster. |
| `applicationTypes` | _[applicationTypes](applicationTypes/readme.md)_ array | `[]` |  | Array of Service Fabric cluster application types. |
| `azureActiveDirectory` | object | `{object}` |  | The settings to enable AAD authentication on the cluster. |
| `certificate` | object | `{object}` |  | Describes the certificate details like thumbprint of the primary certificate, thumbprint of the secondary certificate and the local certificate store location. |
| `certificateCommonNames` | object | `{object}` |  | Describes a list of server certificates referenced by common name that are used to secure the cluster. |
| `clientCertificateCommonNames` | array | `[]` |  | The list of client certificates referenced by common name that are allowed to manage the cluster. |
| `clientCertificateThumbprints` | array | `[]` |  | The list of client certificates referenced by thumbprint that are allowed to manage the cluster. |
| `clusterCodeVersion` | string | `''` |  | The Service Fabric runtime version of the cluster. This property can only by set the user when upgradeMode is set to "Manual". To get list of available Service Fabric versions for new clusters use ClusterVersion API. To get the list of available version for existing clusters use availableClusterVersions. |
| `diagnosticsStorageAccountConfig` | object | `{object}` |  | The storage account information for storing Service Fabric diagnostic logs. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `eventStoreServiceEnabled` | bool | `False` |  | Indicates if the event store service is enabled. |
| `fabricSettings` | array | `[]` |  | The list of custom fabric settings to configure the cluster. |
| `infrastructureServiceManager` | bool | `False` |  | Indicates if infrastructure service manager is enabled. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `notifications` | array | `[]` |  | Indicates a list of notification channels for cluster events. |
| `reliabilityLevel` | string |  | `[Bronze, Gold, None, Platinum, Silver]` | The reliability level sets the replica set size of system services. Learn about ReliabilityLevel (https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-capacity). - None - Run the System services with a target replica set count of 1. This should only be used for test clusters. - Bronze - Run the System services with a target replica set count of 3. This should only be used for test clusters. - Silver - Run the System services with a target replica set count of 5. - Gold - Run the System services with a target replica set count of 7. - Platinum - Run the System services with a target replica set count of 9. |
| `reverseProxyCertificate` | object | `{object}` |  | Describes the certificate details. |
| `reverseProxyCertificateCommonNames` | object | `{object}` |  | Describes a list of server certificates referenced by common name that are used to secure the cluster. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sfZonalUpgradeMode` | string | `'Hierarchical'` | `[Hierarchical, Parallel]` | This property controls the logical grouping of VMs in upgrade domains (UDs). This property cannot be modified if a node type with multiple Availability Zones is already present in the cluster. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `upgradeDescription` | object | `{object}` |  | Describes the policy used when upgrading the cluster. |
| `upgradeMode` | string | `'Automatic'` | `[Automatic, Manual]` | The upgrade mode of the cluster when new Service Fabric runtime version is available. |
| `upgradePauseEndTimestampUtc` | string | `''` |  | Indicates the end date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC). |
| `upgradePauseStartTimestampUtc` | string | `''` |  | Indicates the start date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC). |
| `upgradeWave` | string | `'Wave0'` | `[Wave0, Wave1, Wave2]` | Indicates when new cluster runtime version upgrades will be applied after they are released. By default is Wave0. |
| `vmImage` | string | `''` |  | The VM image VMSS has been configured with. Generic names such as Windows or Linux can be used. |
| `vmssZonalUpgradeMode` | string | `'Hierarchical'` | `[Hierarchical, Parallel]` | This property defines the upgrade mode for the virtual machine scale set, it is mandatory if a node type with multiple Availability Zones is added. |
| `waveUpgradePaused` | bool | `False` |  | Boolean to pause automatic runtime version upgrades to the cluster. |


### Parameter Usage: `notifications`

<details>

<summary>Parameter JSON format</summary>

```json
"notifications": {
    "value": [
        {
            "isEnabled": true, // Required. Indicates if the notification is enabled.
            "notificationCategory": "WaveProgress", // Required. The category of notification. Possible values include: "WaveProgress".
            "notificationLevel": "Critical", // Required. The level of notification. Possible values include: "Critical", "All".
            "notificationTargets": [
                {
                    "notificationChannel": "EmailUser", // Required. The notification channel indicates the type of receivers subscribed to the notification, either user or subscription. Possible values include: "EmailUser", "EmailSubscription".
                    "receivers": [
                        "SomeReceiver" // Required. List of targets that subscribe to the notification.
                    ]
                }
            ]
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
notifications: [
    {
        isEnabled: true // Required. Indicates if the notification is enabled.
        notificationCategory: 'WaveProgress' // Required. The category of notification. Possible values include: 'WaveProgress'.
        notificationLevel: 'Critical' // Required. The level of notification. Possible values include: 'Critical' 'All'.
        notificationTargets: [
            {
                notificationChannel: 'EmailUser' // Required. The notification channel indicates the type of receivers subscribed to the notification either user or subscription. Possible values include: 'EmailUser' 'EmailSubscription'.
                receivers: [
                    'SomeReceiver' // Required. List of targets that subscribe to the notification.
                ]
            }
        ]
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `endpoint` | string | The Service Fabric Cluster endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Service Fabric Cluster name. |
| `resourceGroupName` | string | The Service Fabric Cluster resource group. |
| `resourceId` | string | The Service Fabric Cluster resource ID. |

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
            "value": "<<namePrefix>>-az-sfc-cert-001"
        },
        "managementEndpoint": {
            "value": "https://<<namePrefix>>-az-sfc-cert-001.westeurope.cloudapp.azure.com:19080"
        },
        "reliabilityLevel": {
            "value": "None"
        },
        "certificate": {
            "value": {
                "thumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130", // Mutual exclusive with the other cert specs
                "x509StoreName": "My"
            }
        },
        "nodeTypes": {
            "value": [
                {
                    "applicationPorts": {
                        "endPort": 30000,
                        "startPort": 20000
                    },
                    "clientConnectionEndpointPort": 19000,
                    "durabilityLevel": "Bronze",
                    "ephemeralPorts": {
                        "endPort": 65534,
                        "startPort": 49152
                    },
                    "httpGatewayEndpointPort": 19080,
                    "isPrimary": true,
                    "name": "Node01"
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
module clusters './Microsoft.ServiceFabric/clusters/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-clusters'
  params: {
    name: '<<namePrefix>>-az-sfc-cert-001'
    managementEndpoint: 'https://<<namePrefix>>-az-sfc-cert-001.westeurope.cloudapp.azure.com:19080'
    reliabilityLevel: 'None'
    certificate: {
      thumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
      x509StoreName: 'My'
    }
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        name: 'Node01'
      }
    ]
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
            "value": "<<namePrefix>>-az-sfc-full-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "tags": {
            "value": {
                "resourceType": "Service Fabric",
                "clusterName": "<<namePrefix>>-az-sfc-full-001"
            }
        },
        "addOnFeatures": {
            "value": [
                "RepairManager",
                "DnsService",
                "BackupRestoreService",
                "ResourceMonitorService"
            ]
        },
        "maxUnusedVersionsToKeep": {
            "value": 2
        },
        "azureActiveDirectory": {
            "value": {
                "clientApplication": "<<deploymentSpId>>",
                "clusterApplication": "cf33fea8-b30f-424f-ab73-c48d99e0b222",
                "tenantId": "<<tenantId>>"
            }
        },
        "certificateCommonNames": {
            "value": {
                "commonNames": [
                    {
                        "certificateCommonName": "certcommon",
                        "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130"
                    }
                ],
                "x509StoreName": ""
            }
        },
        "clientCertificateCommonNames": {
            "value": [
                {
                    "certificateCommonName": "clientcommoncert1",
                    "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130",
                    "isAdmin": false
                },
                {
                    "certificateCommonName": "clientcommoncert2",
                    "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC131",
                    "isAdmin": false
                }
            ]
        },
        "clientCertificateThumbprints": {
            "value": [
                {
                    "certificateThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130",
                    "isAdmin": false
                },
                {
                    "certificateThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC131",
                    "isAdmin": false
                }
            ]
        },
        "diagnosticsStorageAccountConfig": {
            "value": {
                "blobEndpoint": "https://adp<<namePrefix>>azsaweux001.blob.core.windows.net/",
                "protectedAccountKeyName": "StorageAccountKey1",
                "queueEndpoint": "https://adp<<namePrefix>>azsaweux001.queue.core.windows.net/",
                "storageAccountName": "adp<<namePrefix>>azsaweux001",
                "tableEndpoint": "https://adp<<namePrefix>>azsaweux001.table.core.windows.net/"
            }
        },
        "fabricSettings": {
            "value": [
                {
                    "name": "Security",
                    "parameters": [
                        {
                            "name": "ClusterProtectionLevel",
                            "value": "EncryptAndSign"
                        }
                    ]
                },
                {
                    "name": "UpgradeService",
                    "parameters": [
                        {
                            "name": "AppPollIntervalInSeconds",
                            "value": "60"
                        }
                    ]
                }
            ]
        },
        "managementEndpoint": {
            "value": "https://<<namePrefix>>-az-sfc-full-001.westeurope.cloudapp.azure.com:19080"
        },
        "nodeTypes": {
            "value": [
                {
                    "applicationPorts": {
                        "endPort": 30000,
                        "startPort": 20000
                    },
                    "capacities": {},
                    "clientConnectionEndpointPort": 19000,
                    "durabilityLevel": "Silver",
                    "ephemeralPorts": {
                        "endPort": 65534,
                        "startPort": 49152
                    },
                    "httpGatewayEndpointPort": 19080,
                    "isPrimary": true,
                    "isStateless": false,
                    "multipleAvailabilityZones": false,
                    "name": "Node01",
                    "placementProperties": {},
                    "reverseProxyEndpointPort": "",
                    "vmInstanceCount": 5
                },
                {
                    "applicationPorts": {
                        "endPort": 30000,
                        "startPort": 20000
                    },
                    "clientConnectionEndpointPort": 19000,
                    "durabilityLevel": "Bronze",
                    "ephemeralPorts": {
                        "endPort": 64000,
                        "startPort": 49000
                    },
                    "httpGatewayEndpointPort": 19007,
                    "isPrimary": true,
                    "name": "Node02",
                    "vmInstanceCount": 5
                }
            ]
        },
        "notifications": {
            "value": [
                {
                    "isEnabled": true,
                    "notificationCategory": "WaveProgress",
                    "notificationLevel": "Critical",
                    "notificationTargets": [
                        {
                            "notificationChannel": "EmailUser",
                            "receivers": [
                                "SomeReceiver"
                            ]
                        }
                    ]
                }
            ]
        },
        "upgradeDescription": {
            "value": {
                "forceRestart": false,
                "upgradeReplicaSetCheckTimeout": "1.00:00:00",
                "healthCheckWaitDuration": "00:00:30",
                "healthCheckStableDuration": "00:01:00",
                "healthCheckRetryTimeout": "00:45:00",
                "upgradeTimeout": "02:00:00",
                "upgradeDomainTimeout": "02:00:00",
                "healthPolicy": {
                    "maxPercentUnhealthyNodes": 0,
                    "maxPercentUnhealthyApplications": 0
                },
                "deltaHealthPolicy": {
                    "maxPercentDeltaUnhealthyNodes": 0,
                    "maxPercentUpgradeDomainDeltaUnhealthyNodes": 0,
                    "maxPercentDeltaUnhealthyApplications": 0
                }
            }
        },
        "reliabilityLevel": {
            "value": "Silver"
        },
        "vmImage": {
            "value": "Linux"
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
        "applicationTypes": {
            "value": [
                {
                    "name": "WordCount" // not idempotent
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
module clusters './Microsoft.ServiceFabric/clusters/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-clusters'
  params: {
    name: '<<namePrefix>>-az-sfc-full-001'
    lock: 'CanNotDelete'
    tags: {
      resourceType: 'Service Fabric'
      clusterName: '<<namePrefix>>-az-sfc-full-001'
    }
    addOnFeatures: [
      'RepairManager'
      'DnsService'
      'BackupRestoreService'
      'ResourceMonitorService'
    ]
    maxUnusedVersionsToKeep: 2
    azureActiveDirectory: {
      clientApplication: '<<deploymentSpId>>'
      clusterApplication: 'cf33fea8-b30f-424f-ab73-c48d99e0b222'
      tenantId: '<<tenantId>>'
    }
    certificateCommonNames: {
      commonNames: [
        {
          certificateCommonName: 'certcommon'
          certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        }
      ]
      x509StoreName: ''
    }
    clientCertificateCommonNames: [
      {
        certificateCommonName: 'clientcommoncert1'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        isAdmin: false
      }
      {
        certificateCommonName: 'clientcommoncert2'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC131'
        isAdmin: false
      }
    ]
    clientCertificateThumbprints: [
      {
        certificateThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        isAdmin: false
      }
      {
        certificateThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC131'
        isAdmin: false
      }
    ]
    diagnosticsStorageAccountConfig: {
      blobEndpoint: 'https://adp<<namePrefix>>azsaweux001.blob.core.windows.net/'
      protectedAccountKeyName: 'StorageAccountKey1'
      queueEndpoint: 'https://adp<<namePrefix>>azsaweux001.queue.core.windows.net/'
      storageAccountName: 'adp<<namePrefix>>azsaweux001'
      tableEndpoint: 'https://adp<<namePrefix>>azsaweux001.table.core.windows.net/'
    }
    fabricSettings: [
      {
        name: 'Security'
        parameters: [
          {
            name: 'ClusterProtectionLevel'
            value: 'EncryptAndSign'
          }
        ]
      }
      {
        name: 'UpgradeService'
        parameters: [
          {
            name: 'AppPollIntervalInSeconds'
            value: '60'
          }
        ]
      }
    ]
    managementEndpoint: 'https://<<namePrefix>>-az-sfc-full-001.westeurope.cloudapp.azure.com:19080'
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        capacities: {}
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Silver'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        isStateless: false
        multipleAvailabilityZones: false
        name: 'Node01'
        placementProperties: {}
        reverseProxyEndpointPort: ''
        vmInstanceCount: 5
      }
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 64000
          startPort: 49000
        }
        httpGatewayEndpointPort: 19007
        isPrimary: true
        name: 'Node02'
        vmInstanceCount: 5
      }
    ]
    notifications: [
      {
        isEnabled: true
        notificationCategory: 'WaveProgress'
        notificationLevel: 'Critical'
        notificationTargets: [
          {
            notificationChannel: 'EmailUser'
            receivers: [
              'SomeReceiver'
            ]
          }
        ]
      }
    ]
    upgradeDescription: {
      forceRestart: false
      upgradeReplicaSetCheckTimeout: '1.00:00:00'
      healthCheckWaitDuration: '00:00:30'
      healthCheckStableDuration: '00:01:00'
      healthCheckRetryTimeout: '00:45:00'
      upgradeTimeout: '02:00:00'
      upgradeDomainTimeout: '02:00:00'
      healthPolicy: {
        maxPercentUnhealthyNodes: 0
        maxPercentUnhealthyApplications: 0
      }
      deltaHealthPolicy: {
        maxPercentDeltaUnhealthyNodes: 0
        maxPercentUpgradeDomainDeltaUnhealthyNodes: 0
        maxPercentDeltaUnhealthyApplications: 0
      }
    }
    reliabilityLevel: 'Silver'
    vmImage: 'Linux'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    applicationTypes: [
      {
        name: 'WordCount'
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-sfc-min-001"
        },
        "managementEndpoint": {
            "value": "https://<<namePrefix>>-az-sfc-min-001.westeurope.cloudapp.azure.com:19080"
        },
        "reliabilityLevel": {
            "value": "None"
        },
        "nodeTypes": {
            "value": [
                {
                    "applicationPorts": {
                        "endPort": 30000,
                        "startPort": 20000
                    },
                    "clientConnectionEndpointPort": 19000,
                    "durabilityLevel": "Bronze",
                    "ephemeralPorts": {
                        "endPort": 65534,
                        "startPort": 49152
                    },
                    "httpGatewayEndpointPort": 19080,
                    "isPrimary": true,
                    "name": "Node01"
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
module clusters './Microsoft.ServiceFabric/clusters/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-clusters'
  params: {
    name: '<<namePrefix>>-az-sfc-min-001'
    managementEndpoint: 'https://<<namePrefix>>-az-sfc-min-001.westeurope.cloudapp.azure.com:19080'
    reliabilityLevel: 'None'
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        name: 'Node01'
      }
    ]
  }
}
```

</details>
<p>
