# Machine Learning Workspaces `[Microsoft.MachineLearningServices/workspaces]`

This module deploys a Machine Learning Services Workspace.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.MachineLearningServices/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.Network/privateEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `associatedApplicationInsightsResourceId` | string |  | The resource ID of the associated Application Insights. |
| `associatedKeyVaultResourceId` | string |  | The resource ID of the associated Key Vault. |
| `associatedStorageAccountResourceId` | string |  | The resource ID of the associated Storage Account. |
| `name` | string |  | The name of the machine learning workspace. |
| `sku` | string | `[Basic, Free, Premium, Standard]` | Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKKeyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| `primaryUserAssignedIdentity` | string | `''` | The user assigned identity resource ID that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled. |
| `systemAssignedIdentity` | bool | `False` | Enables system assigned managed identity on the resource. Required if `userAssignedIdentities` is not provided. |
| `userAssignedIdentities` | object | `{object}` | The ID(s) to assign to the resource. Required if `systemAssignedIdentity` is set to false. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowPublicAccessWhenBehindVnet` | bool | `False` |  | The flag to indicate whether to allow public access when behind VNet. |
| `associatedContainerRegistryResourceId` | string | `''` |  | The resource ID of the associated Container Registry. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `cMKUserAssignedIdentityResourceId` | string | `''` |  | User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first. |
| `computes` | _[computes](computes/README.md)_ array | `[]` |  | Computes to create respectively attach to the workspace. |
| `description` | string | `''` |  | The description of this workspace. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, AmlComputeClusterEvent, AmlComputeClusterNodeEvent, AmlComputeCpuGpuUtilization, AmlComputeJobEvent, AmlRunStatusChangedEvent]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `discoveryUrl` | string | `''` |  | URL for the discovery service to identify regional endpoints for machine learning experimentation services. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hbiWorkspace` | bool | `False` |  | The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. |
| `imageBuildCompute` | string | `''` |  | The compute name for image build. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serviceManagedResourcesSettings` | object | `{object}` |  | The service managed resource settings. |
| `sharedPrivateLinkResources` | array | `[]` |  | The list of shared private link resources in this workspace. |
| `tags` | object | `{object}` |  | Resource tags. |


### Parameter Usage: `computes`

Array to specify the compute resources to create respectively attach.
In case you provide a resource ID, it will attach the resource and ignore "properties". In this case "computeLocation", "sku", "systemAssignedIdentity", "userAssignedIdentities" as well as "tags" don't need to be provided respectively are being ignored.
Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML. I.e. for the first run set "deploy" to true, and after successful deployment to false.
For more information see https://learn.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep

<details>

<summary>Parameter JSON format</summary>

```json
"computes": {
    "value": [
        // Attach existing resources
        {
            "name": "DefaultAKS",
            "location": "westeurope",
            "description": "Default AKS Cluster",
            "disableLocalAuth": false,
            "deployCompute": true,
            "computeType": "AKS",
            "resourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx"
        },
        // Create new compute resource
        {
            "name": "DefaultCPU",
            "location": "westeurope",
            "computeLocation": "westeurope",
            "sku": "Basic",
            "systemAssignedIdentity": true,
            "userAssignedIdentities": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            },
            "description": "Default CPU Cluster",
            "disableLocalAuth": false,
            "computeType": "AmlCompute",
            "properties": {
                "enableNodePublicIp": true,
                "isolatedNetwork": false,
                "osType": "Linux",
                "remoteLoginPortPublicAccess": "Disabled",
                "scaleSettings": {
                    "maxNodeCount": 3,
                    "minNodeCount": 0,
                    "nodeIdleTimeBeforeScaleDown": "PT5M"
                },
                "vmPriority": "Dedicated",
                "vmSize": "STANDARD_DS11_V2"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
computes: [
    // Attach existing resources
    {
        name: 'DefaultAKS'
        location: 'westeurope'
        description: 'Default AKS Cluster'
        disableLocalAuth: false
        deployCompute: true
        computeType: 'AKS'
        resourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx'
    }
    // Create new compute resource
    {
        name: 'DefaultCPU'
        location: 'westeurope'
        computeLocation: 'westeurope'
        sku: 'Basic'
        systemAssignedIdentity: true
        userAssignedIdentities: {
            '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
        }
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        computeType: 'AmlCompute'
        properties: {
            enableNodePublicIp: true
            isolatedNetwork: false
            osType: 'Linux'
            remoteLoginPortPublicAccess: 'Disabled'
            scaleSettings: {
                maxNodeCount: 3
                minNodeCount: 0
                nodeIdleTimeBeforeScaleDown: 'PT5M'
            }
            vmPriority: 'Dedicated'
            vmSize: 'STANDARD_DS11_V2'
        }
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

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "ipConfigurations":[
                {
                    "name": "myIPconfigTest02",
                    "properties": {
                        "groupId": "blob",
                        "memberName": "blob",
                        "privateIPAddress": "10.0.0.30"
                    }
                }
            ],
            "customDnsConfigs": [
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
            "service": "<serviceName>" // e.g. vault, registry, blob
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
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroup: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
        ipConfigurations:[
          {
            name: 'myIPconfigTest02'
            properties: {
              groupId: 'blob'
              memberName: 'blob'
              privateIPAddress: '10.0.0.30'
            }
          }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
    }
]
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
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the machine learning service. |
| `principalId` | string | The principal ID of the system assigned identity. |
| `resourceGroupName` | string | The resource group the machine learning service was deployed into. |
| `resourceId` | string | The resource ID of the machine learning service. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './machine-learning-services/workspaces/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mlswcom'
  params: {
    // Required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    name: '<<namePrefix>>mlswcom001'
    sku: 'Premium'
    // Non-required parameters
    computes: [
      {
        computeLocation: 'westeurope'
        computeType: 'AmlCompute'
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        location: 'westeurope'
        name: 'DefaultCPU'
        properties: {
          enableNodePublicIp: true
          isolatedNetwork: false
          osType: 'Linux'
          remoteLoginPortPublicAccess: 'Disabled'
          scaleSettings: {
            maxNodeCount: 3
            minNodeCount: 0
            nodeIdleTimeBeforeScaleDown: 'PT5M'
          }
          vmPriority: 'Dedicated'
          vmSize: 'STANDARD_DS11_V2'
        }
        sku: 'Basic'
        systemAssignedIdentity: false
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
      }
    ]
    description: 'The cake is a lie.'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    discoveryUrl: 'http://example.com'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    imageBuildCompute: 'testcompute'
    lock: 'CanNotDelete'
    primaryUserAssignedIdentity: '<primaryUserAssignedIdentity>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'amlworkspace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: false
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "name": {
      "value": "<<namePrefix>>mlswcom001"
    },
    "sku": {
      "value": "Premium"
    },
    // Non-required parameters
    "computes": {
      "value": [
        {
          "computeLocation": "westeurope",
          "computeType": "AmlCompute",
          "description": "Default CPU Cluster",
          "disableLocalAuth": false,
          "location": "westeurope",
          "name": "DefaultCPU",
          "properties": {
            "enableNodePublicIp": true,
            "isolatedNetwork": false,
            "osType": "Linux",
            "remoteLoginPortPublicAccess": "Disabled",
            "scaleSettings": {
              "maxNodeCount": 3,
              "minNodeCount": 0,
              "nodeIdleTimeBeforeScaleDown": "PT5M"
            },
            "vmPriority": "Dedicated",
            "vmSize": "STANDARD_DS11_V2"
          },
          "sku": "Basic",
          "systemAssignedIdentity": false,
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          }
        }
      ]
    },
    "description": {
      "value": "The cake is a lie."
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "discoveryUrl": {
      "value": "http://example.com"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "imageBuildCompute": {
      "value": "testcompute"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "primaryUserAssignedIdentity": {
      "value": "<primaryUserAssignedIdentity>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "amlworkspace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": false
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Encr</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './machine-learning-services/workspaces/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mlswecr'
  params: {
    // Required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    name: '<<namePrefix>>mlswecr001'
    sku: 'Basic'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    primaryUserAssignedIdentity: '<primaryUserAssignedIdentity>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'amlworkspace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    systemAssignedIdentity: false
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "name": {
      "value": "<<namePrefix>>mlswecr001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "primaryUserAssignedIdentity": {
      "value": "<primaryUserAssignedIdentity>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "amlworkspace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": false
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './machine-learning-services/workspaces/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-mlswmin'
  params: {
    // Required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    name: '<<namePrefix>>mlswmin001'
    sku: 'Basic'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    systemAssignedIdentity: true
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
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "name": {
      "value": "<<namePrefix>>mlswmin001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "systemAssignedIdentity": {
      "value": true
    }
  }
}
```

</details>
<p>
