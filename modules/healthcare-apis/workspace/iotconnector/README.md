# Healthcare API Workspace IoT Connectors `[Microsoft.HealthcareApis/workspaces/iotconnectors]`

This module deploys a Healthcare API Workspace IoT Connector.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deviceMapping`](#parameter-devicemapping) | object | The mapping JSON that determines how incoming device data is normalized. |
| [`eventHubName`](#parameter-eventhubname) | string | Event Hub name to connect to. |
| [`eventHubNamespaceName`](#parameter-eventhubnamespacename) | string | Namespace of the Event Hub to connect to. |
| [`name`](#parameter-name) | string | The name of the MedTech service. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consumerGroup`](#parameter-consumergroup) | string | Consumer group of the event hub to connected to. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`fhirdestination`](#parameter-fhirdestination) | object | FHIR Destination. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `consumerGroup`

Consumer group of the event hub to connected to.
- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `deviceMapping`

The mapping JSON that determines how incoming device data is normalized.
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

The name of logs that will be streamed.
- Required: No
- Type: array
- Default: `[DiagnosticLogs]`
- Allowed: `[DiagnosticLogs]`

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

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventHubName`

Event Hub name to connect to.
- Required: Yes
- Type: string

### Parameter: `eventHubNamespaceName`

Namespace of the Event Hub to connect to.
- Required: Yes
- Type: string

### Parameter: `fhirdestination`

FHIR Destination.
- Required: No
- Type: object
- Default: `{object}`

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

The name of the MedTech service.
- Required: Yes
- Type: string

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

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workspaceName`

The name of the parent health data services workspace. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the medtech service. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the medtech service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |
| `workspaceName` | string | The name of the medtech workspace. |

## Cross-referenced modules

_None_

## Notes

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
