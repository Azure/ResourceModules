# LogicApp `[Microsoft.Logic/workflows]`

This module deploys Logic App resource.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Logic/workflows` | 2019-05-01 |
| `Microsoft.Logic/workflows/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actionsAccessControlConfiguration` | object | `{object}` |  | Optional. The access control configuration for workflow actions. |
| `connectorEndpointsConfiguration` | object | `{object}` |  | Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector. |
| `contentsAccessControlConfiguration` | object | `{object}` |  | Optional. The access control configuration for accessing workflow run contents. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |
| `definitionParameters` | object | `{object}` |  | Optional. Parameters for the definition template. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `identity` | object | `{object}` |  | Optional. Type of managed identity for resource. SystemAssigned or UserAssigned. |
| `integrationAccount` | object | `{object}` |  | Optional. The integration account. |
| `integrationServiceEnvironment` | object | `{object}` |  | Optional. The integration service environment. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logicAppName` | string |  |  | Required. The logic app workflow name. |
| `logsToEnable` | array | `[WorkflowRuntime]` | `[WorkflowRuntime]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | object | `{object}` |  | Optional. Sku of Logic App. Only to be set when integrating with ISE. |
| `state` | string | `Enabled` | `[NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended]` | Optional. The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `triggersAccessControlConfiguration` | object | `{object}` |  | Optional. The access control configuration for invoking workflow triggers. |
| `workflowActions` | object | `{object}` |  | Optional. The definitions for one or more actions to execute at workflow runtime. |
| `workflowEndpointsConfiguration` | object | `{object}` |  | Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow. |
| `workflowManagementAccessControlConfiguration` | object | `{object}` |  | Optional. The access control configuration for workflow management. |
| `workflowOutputs` | object | `{object}` |  | Optional. The definitions for the outputs to return from a workflow run. |
| `workflowParameters` | object | `{object}` |  | Optional. The definitions for one or more parameters that pass the values to use at your logic app's runtime. |
| `workflowStaticResults` | object | `{object}` |  | Optional. The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults. |
| `workflowTriggers` | object | `{object}` |  | Optional. The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `identity`

- System Assigned

```json
"identity": {
    "value":  {
        "type": "SystemAssigned"
    }
}
```

- User Assigned

```json
"identity": {
    "value":  {
        "type": "UserAssigned",
        "userAssignedIdentities": {
  "<userAssignedIdentities-resourceId>": {}
        }
    }
}
```

### Parameter Usage `<accessControl>AccessControlConfiguration`

- `actionsAccessControlConfiguration`
- `contentsAccessControlConfiguration`
- `triggersAccessControlConfiguration`
- `workflowManagementAccessControlConfiguration`

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

### Parameter Usage `<flow>EndpointsConfiguration`

- `connectorEndpointsConfiguration`
- `workflowEndpointsConfiguration`

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
```

### Parameter Usage `workflow*`

- To use the below parameters, see the following [documentation.](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-workflow-definition-language)
  - `workflowActions`
  - `workflowOutputs`
  - `workflowParameters`
  - `workflowStaticResults`
  - `workflowTriggers`

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
  "roleDefinitionIdOrName": "Desktop Virtualization User",
  "principalIds": [
      "12345678-1234-1234-1234-123456789012", // object 1
      "78945612-1234-1234-1234-123456789012" // object 2
  ]
        },
        {
  "roleDefinitionIdOrName": "Reader",
  "principalIds": [
      "12345678-1234-1234-1234-123456789012", // object 1
      "78945612-1234-1234-1234-123456789012" // object 2
  ]
        },
        {
  "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
  "principalIds": [
      "12345678-1234-1234-1234-123456789012" // object 1
  ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

## Outputs

| Output Name | Type |
| :-- | :-- |
| `logicAppName` | string |
| `logicAppResourceGroup` | string |
| `logicAppResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Workflows](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/workflows)
