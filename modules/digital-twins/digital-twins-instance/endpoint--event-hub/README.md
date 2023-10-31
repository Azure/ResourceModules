# Digital Twins Instance EventHub Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys a Digital Twins Instance EventHub Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances/endpoints) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionStringPrimaryKey`](#parameter-connectionstringprimarykey) | securestring | PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased". |
| [`digitalTwinInstanceName`](#parameter-digitaltwininstancename) | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authenticationType`](#parameter-authenticationtype) | string | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified. |
| [`connectionStringSecondaryKey`](#parameter-connectionstringsecondarykey) | securestring | SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Only used if the `authenticationType` is "KeyBased". |
| [`deadLetterSecret`](#parameter-deadlettersecret) | securestring | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| [`deadLetterUri`](#parameter-deadletteruri) | string | Dead letter storage URL for identity-based authentication. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`endpointUri`](#parameter-endpointuri) | string | The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://' (i.e. sb://xyz.servicebus.windows.net). |
| [`entityPath`](#parameter-entitypath) | string | The EventHub name in the EventHub namespace for identity-based authentication. |
| [`name`](#parameter-name) | string | The name of the Digital Twin Endpoint. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedIdentity`](#parameter-userassignedidentity) | string | The ID to assign to the resource. |

### Parameter: `authenticationType`

Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified.
- Required: No
- Type: string
- Default: `'IdentityBased'`
- Allowed:
  ```Bicep
  [
    'IdentityBased'
    'KeyBased'
  ]
  ```

### Parameter: `connectionStringPrimaryKey`

PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased".
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `connectionStringSecondaryKey`

SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Only used if the `authenticationType` is "KeyBased".
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `deadLetterUri`

Dead letter storage URL for identity-based authentication.
- Required: No
- Type: string
- Default: `''`

### Parameter: `digitalTwinInstanceName`

The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `endpointUri`

The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://' (i.e. sb://xyz.servicebus.windows.net).
- Required: No
- Type: string
- Default: `''`

### Parameter: `entityPath`

The EventHub name in the EventHub namespace for identity-based authentication.
- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the Digital Twin Endpoint.
- Required: No
- Type: string
- Default: `'EventHubEndpoint'`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `userAssignedIdentity`

The ID to assign to the resource.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |

## Cross-referenced modules

_None_
