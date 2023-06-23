# Healthcare API Workspace IoT Connector FHIR Destinations `[Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations]`

This module deploys a Healthcare API Workspace IoT Connector FHIR Destination.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors/fhirdestinations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `destinationMapping` | object | `{object}` | The mapping JSON that determines how normalized data is converted to FHIR Observations. |
| `fhirServiceResourceId` | string |  | The resource identifier of the FHIR Service to connect to. |
| `name` | string |  | The name of the FHIR destination. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `iotConnectorName` | string | The name of the MedTech service to add this destination to. Required if the template is used in a standalone deployment. |
| `workspaceName` | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `resourceIdentityResolutionType` | string | `'Lookup'` | `[Create, Lookup]` | Determines how resource identity is resolved on the destination. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `iotConnectorName` | string | The name of the medtech service. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the FHIR destination. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the FHIR destination. |

## Cross-referenced modules

_None_
