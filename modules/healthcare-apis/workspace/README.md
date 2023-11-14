# Healthcare API Workspaces `[Microsoft.HealthcareApis/workspaces]`

This module deploys a Healthcare API Workspace.

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
| `Microsoft.HealthcareApis/workspaces` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates) |
| `Microsoft.HealthcareApis/workspaces/dicomservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.HealthcareApis/workspaces/fhirservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/healthcare-apis.workspace:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br:bicep/modules/healthcare-apis.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-hawmin'
  params: {
    // Required parameters
    name: 'hawmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    publicNetworkAccess: 'Enabled'
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
      "value": "hawmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
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
module workspace 'br:bicep/modules/healthcare-apis.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-hawmax'
  params: {
    // Required parameters
    name: 'hawmax001'
    // Non-required parameters
    dicomservices: [
      {
        corsAllowCredentials: false
        corsHeaders: [
          '*'
        ]
        corsMaxAge: 600
        corsMethods: [
          'GET'
        ]
        corsOrigins: [
          '*'
        ]
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        location: '<location>'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'az-dicom-x-001'
        publicNetworkAccess: 'Enabled'
        workspaceName: 'hawmax001'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    fhirservices: [
      {
        corsAllowCredentials: false
        corsHeaders: [
          '*'
        ]
        corsMaxAge: 600
        corsMethods: [
          'GET'
        ]
        corsOrigins: [
          '*'
        ]
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        importEnabled: false
        initialImportMode: false
        kind: 'fhir-R4'
        location: '<location>'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'az-fhir-x-001'
        publicNetworkAccess: 'Enabled'
        resourceVersionPolicy: 'versioned'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        smartProxyEnabled: false
        workspaceName: 'hawmax001'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    publicNetworkAccess: 'Enabled'
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
      "value": "hawmax001"
    },
    // Non-required parameters
    "dicomservices": {
      "value": [
        {
          "corsAllowCredentials": false,
          "corsHeaders": [
            "*"
          ],
          "corsMaxAge": 600,
          "corsMethods": [
            "GET"
          ],
          "corsOrigins": [
            "*"
          ],
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "metricCategories": [
                {
                  "category": "AllMetrics"
                }
              ],
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "location": "<location>",
          "managedIdentities": {
            "systemAssigned": false,
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "az-dicom-x-001",
          "publicNetworkAccess": "Enabled",
          "workspaceName": "hawmax001"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "fhirservices": {
      "value": [
        {
          "corsAllowCredentials": false,
          "corsHeaders": [
            "*"
          ],
          "corsMaxAge": 600,
          "corsMethods": [
            "GET"
          ],
          "corsOrigins": [
            "*"
          ],
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "metricCategories": [
                {
                  "category": "AllMetrics"
                }
              ],
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "importEnabled": false,
          "initialImportMode": false,
          "kind": "fhir-R4",
          "location": "<location>",
          "managedIdentities": {
            "systemAssigned": false,
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "az-fhir-x-001",
          "publicNetworkAccess": "Enabled",
          "resourceVersionPolicy": "versioned",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "smartProxyEnabled": false,
          "workspaceName": "hawmax001"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "publicNetworkAccess": {
      "value": "Enabled"
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
module workspace 'br:bicep/modules/healthcare-apis.workspace:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-hawwaf'
  params: {
    // Required parameters
    name: 'hawwaf001'
    // Non-required parameters
    dicomservices: [
      {
        corsAllowCredentials: false
        corsHeaders: [
          '*'
        ]
        corsMaxAge: 600
        corsMethods: [
          'GET'
        ]
        corsOrigins: [
          '*'
        ]
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        location: '<location>'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'az-dicom-x-001'
        publicNetworkAccess: 'Enabled'
        workspaceName: 'hawwaf001'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    fhirservices: [
      {
        corsAllowCredentials: false
        corsHeaders: [
          '*'
        ]
        corsMaxAge: 600
        corsMethods: [
          'GET'
        ]
        corsOrigins: [
          '*'
        ]
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        importEnabled: false
        initialImportMode: false
        kind: 'fhir-R4'
        location: '<location>'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'az-fhir-x-001'
        publicNetworkAccess: 'Enabled'
        resourceVersionPolicy: 'versioned'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        smartProxyEnabled: false
        workspaceName: 'hawwaf001'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    publicNetworkAccess: 'Enabled'
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
      "value": "hawwaf001"
    },
    // Non-required parameters
    "dicomservices": {
      "value": [
        {
          "corsAllowCredentials": false,
          "corsHeaders": [
            "*"
          ],
          "corsMaxAge": 600,
          "corsMethods": [
            "GET"
          ],
          "corsOrigins": [
            "*"
          ],
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "metricCategories": [
                {
                  "category": "AllMetrics"
                }
              ],
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "location": "<location>",
          "managedIdentities": {
            "systemAssigned": false,
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "az-dicom-x-001",
          "publicNetworkAccess": "Enabled",
          "workspaceName": "hawwaf001"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "fhirservices": {
      "value": [
        {
          "corsAllowCredentials": false,
          "corsHeaders": [
            "*"
          ],
          "corsMaxAge": 600,
          "corsMethods": [
            "GET"
          ],
          "corsOrigins": [
            "*"
          ],
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "metricCategories": [
                {
                  "category": "AllMetrics"
                }
              ],
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "importEnabled": false,
          "initialImportMode": false,
          "kind": "fhir-R4",
          "location": "<location>",
          "managedIdentities": {
            "systemAssigned": false,
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "az-fhir-x-001",
          "publicNetworkAccess": "Enabled",
          "resourceVersionPolicy": "versioned",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "smartProxyEnabled": false,
          "workspaceName": "hawwaf001"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "publicNetworkAccess": {
      "value": "Enabled"
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
| [`name`](#parameter-name) | string | The name of the Health Data Services Workspace service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dicomservices`](#parameter-dicomservices) | array | Deploy DICOM services. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`fhirservices`](#parameter-fhirservices) | array | Deploy FHIR services. |
| [`iotconnectors`](#parameter-iotconnectors) | array | Deploy IOT connectors. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `dicomservices`

Deploy DICOM services.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `fhirservices`

Deploy FHIR services.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `iotconnectors`

Deploy IOT connectors.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
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

The name of the Health Data Services Workspace service.
- Required: Yes
- Type: string

### Parameter: `publicNetworkAccess`

Control permission for data plane traffic coming from public networks while private endpoint is enabled.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

Tags of the resource.
- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the health data services workspace. |
| `resourceGroupName` | string | The resource group where the workspace is deployed. |
| `resourceId` | string | The resource ID of the health data services workspace. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `iotconnectors`

Create an IOT Connector (MedTech) service with the workspace.

<details>

<summary>Parameter JSON format</summary>

```json
"iotConnectors": {
    "value": [
      {
        "name": "[[namePrefix]]-az-iomt-x-001",
        "workspaceName": "[[namePrefix]]001",
        "corsOrigins": [ "*" ],
        "corsHeaders": [ "*" ],
        "corsMethods": [ "GET" ],
        "corsMaxAge": 600,
        "corsAllowCredentials": false,
        "location": "[[location]]",
        "diagnosticStorageAccountId": "[[storageAccountResourceId]]",
        "diagnosticWorkspaceId": "[[logAnalyticsWorkspaceResourceId]]",
        "diagnosticEventHubAuthorizationRuleId": "[[eventHubAuthorizationRuleId]]",
        "diagnosticEventHubName": "[[eventHubNamespaceEventHubName]]",
        "publicNetworkAccess": "Enabled",
        "enableDefaultTelemetry": false,
        "systemAssignedIdentity": true,
        "userAssignedIdentities": {
          "[[managedIdentityResourceId]]": {}
        },
        "eventHubName": "[[eventHubName]]",
        "consumerGroup": "[[consumerGroup]]",
        "eventHubNamespaceName": "[[eventHubNamespaceName]]",
        "deviceMapping": "[[deviceMapping]]",
        "destinationMapping": "[[destinationMapping]]",
        "fhirServiceResourceId": "[[fhirServiceResourceId]]",
      }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
iotConnectors: [
    {
        name: '[[namePrefix]]-az-iomt-x-001'
        workspaceName: '[[namePrefix]]001'
        corsOrigins: [ '*' ]
        corsHeaders: [ '*' ]
        corsMethods: [ 'GET' ]
        corsMaxAge: 600
        corsAllowCredentials: false
        location: location
        diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
        diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
        publicNetworkAccess: 'Enabled'
        enableDefaultTelemetry: enableDefaultTelemetry
        systemAssignedIdentity: true
        userAssignedIdentities: {
          '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
        }
        eventHubName: '[[eventHubName]]'
        consumerGroup: '[[consumerGroup]]'
        eventHubNamespaceName: '[[eventHubNamespaceName]]'
        deviceMapping: '[[deviceMapping]]'
        destinationMapping: '[[destinationMapping]]'
        fhirServiceResourceId: '[[fhirServiceResourceId]]'
      }
]
```

</details>
<p>
