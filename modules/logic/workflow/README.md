# Logic Apps (Workflows) `[Microsoft.Logic/workflows]`

This module deploys a Logic App (Workflow).

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Logic/workflows` | [2019-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/workflows) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/logic.workflow:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module workflow 'br:bicep/modules/logic.workflow:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-lwcom'
  params: {
    // Required parameters
    name: 'lwcom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    workflowActions: {
      HTTP: {
        inputs: {
          body: {
            BeginPeakTime: '<BeginPeakTime>'
            EndPeakTime: '<EndPeakTime>'
            HostPoolName: '<HostPoolName>'
            LAWorkspaceName: '<LAWorkspaceName>'
            LimitSecondsToForceLogOffUser: '<LimitSecondsToForceLogOffUser>'
            LogOffMessageBody: '<LogOffMessageBody>'
            LogOffMessageTitle: '<LogOffMessageTitle>'
            MinimumNumberOfRDSH: 1
            ResourceGroupName: '<ResourceGroupName>'
            SessionThresholdPerCPU: 1
            UtcOffset: '<UtcOffset>'
          }
          method: 'POST'
          uri: 'https://testStringForValidation.com'
        }
        type: 'Http'
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
      "value": "lwcom001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "workflowActions": {
      "value": {
        "HTTP": {
          "inputs": {
            "body": {
              "BeginPeakTime": "<BeginPeakTime>",
              "EndPeakTime": "<EndPeakTime>",
              "HostPoolName": "<HostPoolName>",
              "LAWorkspaceName": "<LAWorkspaceName>",
              "LimitSecondsToForceLogOffUser": "<LimitSecondsToForceLogOffUser>",
              "LogOffMessageBody": "<LogOffMessageBody>",
              "LogOffMessageTitle": "<LogOffMessageTitle>",
              "MinimumNumberOfRDSH": 1,
              "ResourceGroupName": "<ResourceGroupName>",
              "SessionThresholdPerCPU": 1,
              "UtcOffset": "<UtcOffset>"
            },
            "method": "POST",
            "uri": "https://testStringForValidation.com"
          },
          "type": "Http"
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
| [`name`](#parameter-name) | string | The logic app workflow name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionsAccessControlConfiguration`](#parameter-actionsaccesscontrolconfiguration) | object | The access control configuration for workflow actions. |
| [`connectorEndpointsConfiguration`](#parameter-connectorendpointsconfiguration) | object | The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector. |
| [`contentsAccessControlConfiguration`](#parameter-contentsaccesscontrolconfiguration) | object | The access control configuration for accessing workflow run contents. |
| [`definitionParameters`](#parameter-definitionparameters) | object | Parameters for the definition template. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`integrationAccount`](#parameter-integrationaccount) | object | The integration account. |
| [`integrationServiceEnvironmentResourceId`](#parameter-integrationserviceenvironmentresourceid) | string | The integration service environment Id. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`state`](#parameter-state) | string | The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`triggersAccessControlConfiguration`](#parameter-triggersaccesscontrolconfiguration) | object | The access control configuration for invoking workflow triggers. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`workflowActions`](#parameter-workflowactions) | object | The definitions for one or more actions to execute at workflow runtime. |
| [`workflowEndpointsConfiguration`](#parameter-workflowendpointsconfiguration) | object | The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow. |
| [`workflowManagementAccessControlConfiguration`](#parameter-workflowmanagementaccesscontrolconfiguration) | object | The access control configuration for workflow management. |
| [`workflowOutputs`](#parameter-workflowoutputs) | object | The definitions for the outputs to return from a workflow run. |
| [`workflowParameters`](#parameter-workflowparameters) | object | The definitions for one or more parameters that pass the values to use at your logic app's runtime. |
| [`workflowStaticResults`](#parameter-workflowstaticresults) | object | The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults. |
| [`workflowTriggers`](#parameter-workflowtriggers) | object | The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer. |

### Parameter: `actionsAccessControlConfiguration`

The access control configuration for workflow actions.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `connectorEndpointsConfiguration`

The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `contentsAccessControlConfiguration`

The access control configuration for accessing workflow run contents.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `definitionParameters`

Parameters for the definition template.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, WorkflowRuntime]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `integrationAccount`

The integration account.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `integrationServiceEnvironmentResourceId`

The integration service environment Id.
- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The logic app workflow name.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `state`

The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended.
- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed: `[Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `triggersAccessControlConfiguration`

The access control configuration for invoking workflow triggers.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowActions`

The definitions for one or more actions to execute at workflow runtime.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowEndpointsConfiguration`

The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowManagementAccessControlConfiguration`

The access control configuration for workflow management.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowOutputs`

The definitions for the outputs to return from a workflow run.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowParameters`

The definitions for one or more parameters that pass the values to use at your logic app's runtime.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowStaticResults`

The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workflowTriggers`

The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the logic app. |
| `resourceGroupName` | string | The resource group the logic app was deployed into. |
| `resourceId` | string | The resource ID of the logic app. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Notes

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
