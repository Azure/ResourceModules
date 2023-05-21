# HealthcareApis Workspaces `[Microsoft.HealthcareApis/workspaces]`

This module deploys Healthcare Data Services workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.HealthcareApis/workspaces` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces) |
| `Microsoft.HealthcareApis/workspaces/dicomservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/dicomservices) |
| `Microsoft.HealthcareApis/workspaces/fhirservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/fhirservices) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors/fhirdestinations) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Health Data Services Workspace service. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dicomservices` | _[dicomservices](dicomservices/README.md)_ array | `[]` |  | Deploy DICOM services. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `fhirservices` | _[fhirservices](fhirservices/README.md)_ array | `[]` |  | Deploy FHIR services. |
| `iotconnectors` | _[iotconnectors](iotconnectors/README.md)_ array | `[]` |  | Deploy IOT connectors. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled]` | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `fhirservices`

Create a FHIR service with the workspace.

<details>

<summary>Parameter JSON format</summary>

```json
"fhirServices": {
    "value": [
      {
        "name": "<<namePrefix>>-az-fhir-x-001",
        "kind": "fhir-R4",
        "workspaceName": "<<namePrefix>>001",
        "corsOrigins": [ "*" ],
        "corsHeaders": [ "*" ],
        "corsMethods": [ "GET" ],
        "corsMaxAge": 600,
        "corsAllowCredentials": false,
        "location": "<<location>>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<<storageAccountResourceId>>",
        "diagnosticWorkspaceId": "<<logAnalyticsWorkspaceResourceId>>",
        "diagnosticEventHubAuthorizationRuleId": "<<eventHubAuthorizationRuleId>>",
        "diagnosticEventHubName": "<<eventHubNamespaceEventHubName>>",
        "publicNetworkAccess": "Enabled",
        "resourceVersionPolicy": "versioned",
        "smartProxyEnabled": false,
        "enableDefaultTelemetry": false,
        "systemAssignedIdentity": true,
        "importEnabled": false,
        "initialImportMode": false,
        "userAssignedIdentities": {
          "<<managedIdentityResourceId>>": {}
        },
        "roleAssignments": [
          {
            "roleDefinitionIdOrName": "Role Name",
            "principalIds": [
              "managedIdentityPrincipalId"
            ],
            "principalType": "ServicePrincipal"
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
fhirServices: [
    {
        name: '<<namePrefix>>-az-fhir-x-001'
        kind: 'fhir-R4'
        workspaceName: '<<namePrefix>>001'
        corsOrigins: [ '*' ]
        corsHeaders: [ '*' ]
        corsMethods: [ 'GET' ]
        corsMaxAge: 600
        corsAllowCredentials: false
        location: location
        diagnosticLogsRetentionInDays: 7
        diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
        diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
        publicNetworkAccess: 'Enabled'
        resourceVersionPolicy: 'versioned'
        smartProxyEnabled: false
        enableDefaultTelemetry: enableDefaultTelemetry
        systemAssignedIdentity: true
        importEnabled: false
        initialImportMode: false
        userAssignedIdentities: {
          '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
        }
        roleAssignments: [
          {
            roleDefinitionIdOrName: resourceId('Microsoft.Authorization/roleDefinitions', '5a1fc7df-4bf1-4951-a576-89034ee01acd')
            principalIds: [
              resourceGroupResources.outputs.managedIdentityPrincipalId
            ]
            principalType: 'ServicePrincipal'
          }
        ]
      }
]
```

</details>
<p>

### Parameter Usage: `dicomservices`

Create a DICOM service with the workspace.

<details>

<summary>Parameter JSON format</summary>

```json
"dicomServices": {
    "value": [
      {
        "name": "<<namePrefix>>-az-dicom-x-001",
        "workspaceName": "<<namePrefix>>001",
        "corsOrigins": [ "*" ],
        "corsHeaders": [ "*" ],
        "corsMethods": [ "GET" ],
        "corsMaxAge": 600,
        "corsAllowCredentials": false,
        "location": "<<location>>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<<storageAccountResourceId>>",
        "diagnosticWorkspaceId": "<<logAnalyticsWorkspaceResourceId>>",
        "diagnosticEventHubAuthorizationRuleId": "<<eventHubAuthorizationRuleId>>",
        "diagnosticEventHubName": "<<eventHubNamespaceEventHubName>>",
        "publicNetworkAccess": "Enabled",
        "enableDefaultTelemetry": false,
        "systemAssignedIdentity": true,
        "userAssignedIdentities": {
          "<<managedIdentityResourceId>>": {}
        }
      }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
dicomServices: [
    {
        name: '<<namePrefix>>-az-dicom-x-001'
        workspaceName: '<<namePrefix>>001'
        corsOrigins: [ '*' ]
        corsHeaders: [ '*' ]
        corsMethods: [ 'GET' ]
        corsMaxAge: 600
        corsAllowCredentials: false
        location: location
        diagnosticLogsRetentionInDays: 7
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
    }
]
```

</details>
<p>

### Parameter Usage: `iotconnectors`

Create an IOT Connector (MedTech) service with the workspace.

<details>

<summary>Parameter JSON format</summary>

```json
"iotConnectors": {
    "value": [
      {
        "name": "<<namePrefix>>-az-iomt-x-001",
        "workspaceName": "<<namePrefix>>001",
        "corsOrigins": [ "*" ],
        "corsHeaders": [ "*" ],
        "corsMethods": [ "GET" ],
        "corsMaxAge": 600,
        "corsAllowCredentials": false,
        "location": "<<location>>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<<storageAccountResourceId>>",
        "diagnosticWorkspaceId": "<<logAnalyticsWorkspaceResourceId>>",
        "diagnosticEventHubAuthorizationRuleId": "<<eventHubAuthorizationRuleId>>",
        "diagnosticEventHubName": "<<eventHubNamespaceEventHubName>>",
        "publicNetworkAccess": "Enabled",
        "enableDefaultTelemetry": false,
        "systemAssignedIdentity": true,
        "userAssignedIdentities": {
          "<<managedIdentityResourceId>>": {}
        },
        "eventHubName": "<<eventHubName>>",
        "consumerGroup": "<<consumerGroup>>",
        "eventHubNamespaceName": "<<eventHubNamespaceName>>",
        "deviceMapping": "<<deviceMapping>>",
        "destinationMapping": "<<destinationMapping>>",
        "fhirServiceResourceId": "<<fhirServiceResourceId>>",
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
        name: '<<namePrefix>>-az-iomt-x-001'
        workspaceName: '<<namePrefix>>001'
        corsOrigins: [ '*' ]
        corsHeaders: [ '*' ]
        corsMethods: [ 'GET' ]
        corsMaxAge: 600
        corsAllowCredentials: false
        location: location
        diagnosticLogsRetentionInDays: 7
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
        eventHubName: '<<eventHubName>>'
        consumerGroup: '<<consumerGroup>>'
        eventHubNamespaceName: '<<eventHubNamespaceName>>'
        deviceMapping: '<<deviceMapping>>'
        destinationMapping: '<<destinationMapping>>'
        fhirServiceResourceId: '<<fhirServiceResourceId>>'
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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the health data services workspace. |
| `resourceGroupName` | string | The resource group where the workspace is deployed. |
| `resourceId` | string | The resource ID of the health data services workspace. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './healthcare-apis/workspaces/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-hawcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>hawcom001'
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
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticLogsRetentionInDays: 7
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        location: '<location>'
        name: '<<namePrefix>>-az-dicom-x-001'
        publicNetworkAccess: 'Enabled'
        systemAssignedIdentity: false
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
        workspaceName: '<<namePrefix>>hawcom001'
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
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticLogsRetentionInDays: 7
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        importEnabled: false
        initialImportMode: false
        kind: 'fhir-R4'
        location: '<location>'
        name: '<<namePrefix>>-az-fhir-x-001'
        publicNetworkAccess: 'Enabled'
        resourceVersionPolicy: 'versioned'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        smartProxyEnabled: false
        systemAssignedIdentity: false
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
        workspaceName: '<<namePrefix>>hawcom001'
      }
    ]
    location: '<location>'
    lock: ''
    publicNetworkAccess: 'Enabled'
    tags: {
      Environment: 'Non-Prod'
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
      "value": "<<namePrefix>>hawcom001"
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
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticLogsRetentionInDays": 7,
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "location": "<location>",
          "name": "<<namePrefix>>-az-dicom-x-001",
          "publicNetworkAccess": "Enabled",
          "systemAssignedIdentity": false,
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          },
          "workspaceName": "<<namePrefix>>hawcom001"
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
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticLogsRetentionInDays": 7,
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "importEnabled": false,
          "initialImportMode": false,
          "kind": "fhir-R4",
          "location": "<location>",
          "name": "<<namePrefix>>-az-fhir-x-001",
          "publicNetworkAccess": "Enabled",
          "resourceVersionPolicy": "versioned",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "smartProxyEnabled": false,
          "systemAssignedIdentity": false,
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          },
          "workspaceName": "<<namePrefix>>hawcom001"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": ""
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './healthcare-apis/workspaces/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-hawmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>hawmin001'
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
      "value": "<<namePrefix>>hawmin001"
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
