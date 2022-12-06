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
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.HealthcareApis/workspaces` | [2022-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces) |
| `Microsoft.HealthcareApis/workspaces/dicomservices` | [2022-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/dicomservices) |
| `Microsoft.HealthcareApis/workspaces/fhirservices` | [2022-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/fhirservices) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors` | [2022-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors/fhirdestinations) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Health Data Services Workspace service. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dicomServices` | _[dicomservices](dicomservices/readme.md)_ array | `[]` |  | Deploy DICOM services. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `fhirServices` | _[fhirservices](fhirservices/readme.md)_ array | `[]` |  | Deploy FHIR services. |
| `iotConnectors` | _[iotconnectors](iotconnectors/readme.md)_ array | `[]` |  | Deploy IOT connectors. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled]` | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


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
module workspaces './Microsoft.HealthcareApis/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-hwcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>hwcom001'
    // Non-required parameters
    publicNetworkAccess: 'Enabled'
    iotConnectors: [
      {
        workspaceName: '<<namePrefix>>hwcom001'
        eventHubNamespaceName: '<eventHubNamespaceName>'
        diagnosticLogsRetentionInDays: 7
        destinationMapping: {
          template: []
          templateType: 'CollectionFhir'
        }
        resourceIdentityResolutionType: 'Lookup'
        location: '<location>'
        systemAssignedIdentity: true
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        consumerGroup: '<<namePrefix>>-az-iomt-x-001'
        eventHubName: '<eventHubName>'
        name: '<<namePrefix>>-az-iomt-x-001'
        publicNetworkAccess: 'Enabled'
        resourceVersionPolicy: 'versioned'
        deviceMapping: {
          template: []
          templateType: 'CollectionContent'
        }
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    dicomServices: [
      {
        location: '<location>'
        corsHeaders: [
          '*'
        ]
        publicNetworkAccess: 'Enabled'
        workspaceName: '<<namePrefix>>hwcom001'
        corsMaxAge: 600
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        systemAssignedIdentity: true
        corsMethods: [
          'GET'
        ]
        name: '<<namePrefix>>-az-dicom-x-001'
        corsAllowCredentials: true
        corsOrigins: [
          '*'
        ]
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticLogsRetentionInDays: 7
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
      }
    ]
    location: '<location>'
    fhirServices: [
      {
        corsAllowCredentials: true
        corsMethods: [
          'GET'
        ]
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        corsMaxAge: 600
        publicNetworkAccess: 'Enabled'
        kind: 'fhir-R4'
        diagnosticLogsRetentionInDays: 7
        initialImportMode: false
        userAssignedIdentities: {
          '<managedIdentityResourceId>': {}
        }
        corsHeaders: [
          '*'
        ]
        roleAssignments: [
          {
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
          }
        ]
        systemAssignedIdentity: true
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        resourceVersionPolicy: 'versioned'
        corsOrigins: [
          '*'
        ]
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        location: '<location>'
        name: '<<namePrefix>>-az-fhir-x-001'
        workspaceName: '<<namePrefix>>hwcom001'
        importEnabled: false
        smartProxyEnabled: false
        diagnosticEventHubName: '<diagnosticEventHubName>'
      }
    ]
    lock: 'CanNotDelete'
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
      "value": "<<namePrefix>>hwcom001"
    },
    // Non-required parameters
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "iotConnectors": {
      "value": [
        {
          "workspaceName": "<<namePrefix>>hwcom001",
          "eventHubNamespaceName": "<eventHubNamespaceName>",
          "diagnosticLogsRetentionInDays": 7,
          "destinationMapping": {
            "template": [],
            "templateType": "CollectionFhir"
          },
          "resourceIdentityResolutionType": "Lookup",
          "location": "<location>",
          "systemAssignedIdentity": true,
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          },
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "consumerGroup": "<<namePrefix>>-az-iomt-x-001",
          "eventHubName": "<eventHubName>",
          "name": "<<namePrefix>>-az-iomt-x-001",
          "publicNetworkAccess": "Enabled",
          "resourceVersionPolicy": "versioned",
          "deviceMapping": {
            "template": [],
            "templateType": "CollectionContent"
          },
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "dicomServices": {
      "value": [
        {
          "location": "<location>",
          "corsHeaders": [
            "*"
          ],
          "publicNetworkAccess": "Enabled",
          "workspaceName": "<<namePrefix>>hwcom001",
          "corsMaxAge": 600,
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "systemAssignedIdentity": true,
          "corsMethods": [
            "GET"
          ],
          "name": "<<namePrefix>>-az-dicom-x-001",
          "corsAllowCredentials": true,
          "corsOrigins": [
            "*"
          ],
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticLogsRetentionInDays": 7,
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          }
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "fhirServices": {
      "value": [
        {
          "corsAllowCredentials": true,
          "corsMethods": [
            "GET"
          ],
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "corsMaxAge": 600,
          "publicNetworkAccess": "Enabled",
          "kind": "fhir-R4",
          "diagnosticLogsRetentionInDays": 7,
          "initialImportMode": false,
          "userAssignedIdentities": {
            "<managedIdentityResourceId>": {}
          },
          "corsHeaders": [
            "*"
          ],
          "roleAssignments": [
            {
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>",
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ]
            }
          ],
          "systemAssignedIdentity": true,
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "resourceVersionPolicy": "versioned",
          "corsOrigins": [
            "*"
          ],
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "location": "<location>",
          "name": "<<namePrefix>>-az-fhir-x-001",
          "workspaceName": "<<namePrefix>>hwcom001",
          "importEnabled": false,
          "smartProxyEnabled": false,
          "diagnosticEventHubName": "<diagnosticEventHubName>"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
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
module workspaces './Microsoft.HealthcareApis/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-hwmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>hwmin001'
    // Non-required parameters
    publicNetworkAccess: 'Enabled'
    location: '<location>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "<<namePrefix>>hwmin001"
    },
    // Non-required parameters
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>
