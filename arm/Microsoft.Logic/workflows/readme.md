# Logic Apps `[Microsoft.Logic/workflows]`

This module deploys a Logic App resource.

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
| `Microsoft.Logic/workflows` | [2019-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/workflows) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The logic app workflow name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actionsAccessControlConfiguration` | object | `{object}` |  | The access control configuration for workflow actions. |
| `connectorEndpointsConfiguration` | object | `{object}` |  | The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector. |
| `contentsAccessControlConfiguration` | object | `{object}` |  | The access control configuration for accessing workflow run contents. |
| `definitionParameters` | object | `{object}` |  | Parameters for the definition template. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[WorkflowRuntime]` | `[WorkflowRuntime]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `integrationAccount` | object | `{object}` |  | The integration account. |
| `integrationServiceEnvironment` | object | `{object}` |  | The integration service environment. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `state` | string | `'Enabled'` | `[NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended]` | The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `triggersAccessControlConfiguration` | object | `{object}` |  | The access control configuration for invoking workflow triggers. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `workflowActions` | object | `{object}` |  | The definitions for one or more actions to execute at workflow runtime. |
| `workflowEndpointsConfiguration` | object | `{object}` |  | The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow. |
| `workflowManagementAccessControlConfiguration` | object | `{object}` |  | The access control configuration for workflow management. |
| `workflowOutputs` | object | `{object}` |  | The definitions for the outputs to return from a workflow run. |
| `workflowParameters` | object | `{object}` |  | The definitions for one or more parameters that pass the values to use at your logic app's runtime. |
| `workflowStaticResults` | object | `{object}` |  | The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults. |
| `workflowTriggers` | object | `{object}` |  | The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer. |


### Parameter Usage `<accessControl>AccessControlConfiguration`

- `actionsAccessControlConfiguration`
- `contentsAccessControlConfiguration`
- `triggersAccessControlConfiguration`
- `workflowManagementAccessControlConfiguration`

<details>

<summary>Parameter JSON format</summary>

```json
"<accessControl>AccessControlConfiguration": {
    "value": {
        "allowedCallerIpAddresses": [
            {
                "addressRange": "string"
            }
        ],
        "openAuthenticationPolicies": {
            "policies": {}
        }
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
'<accessControl>AccessControlConfiguration': {
    allowedCallerIpAddresses: [
        {
            addressRange: 'string'
        }
    ]
    openAuthenticationPolicies: {
        policies: {}
    }
}
```

</details>
<p>

### Parameter Usage `<flow>EndpointsConfiguration`

- `connectorEndpointsConfiguration`
- `workflowEndpointsConfiguration`

<details>

<summary>Parameter JSON format</summary>

```json
"<flow>EndpointsConfiguration": {
    "value": {
        "outgoingIpAddresses": [
            {
                "address": "string"
            }
        ],
            "accessEndpointIpAddresses": [
            {
                "address": "string"
            }
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'<flow>EndpointsConfiguration': {
    outgoingIpAddresses: [
        {
            address: 'string'
        }
    ]
    accessEndpointIpAddresses: [
        {
            address: 'string'
        }
    ]
}
```

</details>
<p>

### Parameter Usage `workflow*`

- To use the below parameters, see the following [documentation.](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-workflow-definition-language)
  - `workflowActions`
  - `workflowOutputs`
  - `workflowParameters`
  - `workflowStaticResults`
  - `workflowTriggers`

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the logic app. |
| `resourceGroupName` | string | The resource group the logic app was deployed into. |
| `resourceId` | string | The resource ID of the logic app. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

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
            "value": "<<namePrefix>>-az-lga-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "tags": {
            "value": {}
        },
        "workflowActions": {
            "value": {
                "HTTP": {
                    "type": "Http",
                    "inputs": {
                        "method": "POST",
                        "uri": "https://testStringForValidation.com",
                        "body": {
                            "HostPoolName": "[HostPoolName]",
                            "LAWorkspaceName": "[LAWorkspaceName]",
                            "LimitSecondsToForceLogOffUser": "[LimitSecondsToForceLogOffUser]",
                            "EndPeakTime": "[EndPeakTime]",
                            "BeginPeakTime": "[BeginPeakTime]",
                            "UtcOffset": "[UtcOffset]",
                            "LogOffMessageBody": "[LogOffMessageBody]",
                            "LogOffMessageTitle": "[LogOffMessageTitle]",
                            "MinimumNumberOfRDSH": 1,
                            "SessionThresholdPerCPU": 1,
                            "ResourceGroupName": "[ResourceGroupName]"
                        }
                    }
                }
            }
        },
        "workflowTriggers": {
            "value": {
                "Recurrence": {
                    "recurrence": {
                        "frequency": "Minute",
                        "interval": 15
                    },
                    "type": "Recurrence"
                }
            }
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
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module workflows './Microsoft.Logic/workflows/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-workflows'
  params: {
    name: '<<namePrefix>>-az-lga-x-001'
    lock: 'CanNotDelete'
    tags: {}
    workflowActions: {
      HTTP: {
        type: 'Http'
        inputs: {
          method: 'POST'
          uri: 'https://testStringForValidation.com'
          body: {
            HostPoolName: '[HostPoolName]'
            LAWorkspaceName: '[LAWorkspaceName]'
            LimitSecondsToForceLogOffUser: '[LimitSecondsToForceLogOffUser]'
            EndPeakTime: '[EndPeakTime]'
            BeginPeakTime: '[BeginPeakTime]'
            UtcOffset: '[UtcOffset]'
            LogOffMessageBody: '[LogOffMessageBody]'
            LogOffMessageTitle: '[LogOffMessageTitle]'
            MinimumNumberOfRDSH: 1
            SessionThresholdPerCPU: 1
            ResourceGroupName: '[ResourceGroupName]'
          }
        }
      }
    }
    workflowTriggers: {
      Recurrence: {
        recurrence: {
          frequency: 'Minute'
          interval: 15
        }
        type: 'Recurrence'
      }
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    systemAssignedIdentity: true
  }
}
```

</details>
<p>
