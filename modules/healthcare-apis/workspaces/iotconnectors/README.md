# Healthcare API Workspace IoT Connectors `[Microsoft.HealthcareApis/workspaces/iotconnectors]`

This module deploys a Healthcare API Workspace IoT Connector.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors/fhirdestinations) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `deviceMapping` | object | `{object}` | The mapping JSON that determines how incoming device data is normalized. |
| `eventHubName` | string |  | Event Hub name to connect to. |
| `eventHubNamespaceName` | string |  | Namespace of the Event Hub to connect to. |
| `name` | string |  | The name of the MedTech service. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceName` | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `consumerGroup` | string | `[parameters('name')]` |  | Consumer group of the event hub to connected to. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[DiagnosticLogs]` | `[DiagnosticLogs]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `fhirdestination` | object | `{object}` |  | FHIR Destination. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `deviceMapping`

You can specify a collection of device mapping using the following format:

> NOTE: More detailed information on device mappings can be found [here](https://learn.microsoft.com/en-us/azure/healthcare-apis/iot/how-to-use-device-mappings).

<details>

<summary>Parameter JSON format</summary>

```json
"deviceMapping": {
    "value": {
        "templateType": "CollectionContent",
        "template": [
            {
                "templateType": "JsonPathContent",
                "template": {
                    "typeName": "heartrate",
                    "typeMatchExpression": "$..[?(@heartRate)]",
                    "deviceIdExpression": "$.deviceId",
                    "timestampExpression": "$.endDate",
                    "values": [
                        {
                            "required": "true",
                            "valueExpression": "$.heartRate",
                            "valueName": "hr"
                        }
                    ]
                }
            }
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
deviceMapping: {
    templateType: 'CollectionContent'
    template: [
    {
        templateType: 'JsonPathContent'
        template: {
            typeName: 'heartrate'
            typeMatchExpression: '$..[?(@heartRate)]'
            deviceIdExpression: '$.deviceId'
            timestampExpression: '$.endDate'
            values: [
                {
                    required: 'true'
                    valueExpression: '$.heartRat'
                    valueName: 'hr'
                }
            ]
        }
    }]
}
```

</details>

<p>

### Parameter Usage: `destinationMapping`

You can specify a collection of destination mapping using the following format:

> NOTE: More detailed information on destination mappings can be found [here](https://learn.microsoft.com/en-us/azure/healthcare-apis/iot/how-to-use-fhir-mappings).

<details>

<summary>Parameter JSON format</summary>

```json
"destinationMapping": {
    "value": {
        "templateType": "CodeValueFhir",
        "template": {
            "codes": [
                {
                    "code": "8867-4",
                    "system": "http://loinc.org",
                    "display": "Heart rate"
                }
            ],
            "periodInterval": 60,
            "typeName": "heartrate",
            "value": {
                "defaultPeriod": 5000,
                "unit": "count/min",
                "valueName": "hr",
                "valueType": "SampledData"
            }
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
destinationMapping: {
    templateType: 'CodeValueFhir'
    template: {
        codes: [
            {
                code: '8867-4'
                system: 'http://loinc.org'
                display: 'Heart rate'
            }
        ],
        periodInterval: 60,
        typeName: 'heartrate'
        value: {
            defaultPeriod: 5000
            unit: 'count/min'
            valueName: 'hr'
            valueType: 'SampledData'
        }
    }
}
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
| `name` | string | The name of the medtech service. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the medtech service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |
| `workspaceName` | string | The name of the medtech workspace. |

## Cross-referenced modules

_None_
