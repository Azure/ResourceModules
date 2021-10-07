# LogicApp

This module deploys Logic App resource.

## Resource types

| Resource Type    | Api Version        |
| -------------------------------------------------------- | ------------------ |
| `Microsoft.Logic/workflows`| 2019-05-01         |
| `Microsoft.Logic/workflows/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.Logic/workflows/providers/roleAssignments`    | 2020-04-01-preview |
| `Microsoft.Resources/deployments`    | 2020-06-01         |
| `providers/locks`| 2016-09-01         |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `actionsAccessControlConfiguration` | object | Optional. The access control configuration for workflow actions. |  |  |
| `connectorEndpointsConfiguration` | object | Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector. |  |  |
| `contentsAccessControlConfiguration` | object | Optional. The access control configuration for accessing workflow run contents. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |  |  |
| `definitionParameters` | object | Optional. Parameters for the definition template. |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `identity` | object | Optional. Type of managed identity for resource. SystemAssigned or UserAssigned. |  |  |
| `integrationAccount` | object | Optional. The integration account. |  |  |
| `integrationServiceEnvironment` | object | Optional. The integration service environment. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Flag indicating if resource is locked for deletion. | False |  |
| `logicAppName` | string | Required. The logic app workflow name. |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. | System.Object[] |  |
| `sku` | object | Optional. Sku of Logic App. Only to be set when integrating with ISE. |  |  |
| `state` | string | Optional. The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended. | Enabled | System.Object[] |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `triggersAccessControlConfiguration` | object | Optional. The access control configuration for invoking workflow triggers. |  |  |
| `workflowActions` | object | Optional. The definitions for one or more actions to execute at workflow runtime. |  |  |
| `workflowEndpointsConfiguration` | object | Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow. |  |  |
| `workflowManagementAccessControlConfiguration` | object | Optional. The access control configuration for workflow management. |  |  |
| `workflowOutputs` | object | Optional. The definitions for the outputs to return from a workflow run. |  |  |
| `workflowParameters` | object | Optional. The definitions for one or more parameters that pass the values to use at your logic app's runtime. |  |  |
| `workflowStaticResults` | object | Optional. The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults. |  |  |
| `workflowTriggers` | object | Optional. The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |

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

### Parameter Usage: `encryption`

## Outputs

| Output Name   | Type   | Description|
| ----------------------- | ------ | ------------------------------------------------------------ |
| `logicAppResourceId`    | string | The Resource Id of the Logic App.        |
| `logicAppResourceGroup` | string | The name of the Resource Group the Logic App was created in. |
| `logicAppName`| string | The Name of the Logic App.     |

## Considerations

_N/A_

## Additional resources

- [Microsoft.Logic workflows template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.logic/workflows?tabs=json)
- [What is Logic App?](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
