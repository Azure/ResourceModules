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

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `connectionStringPrimaryKey` | securestring | `''` | PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased". |
| `digitalTwinInstanceName` | string |  | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authenticationType` | string | `'IdentityBased'` | `[IdentityBased, KeyBased]` | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified. |
| `connectionStringSecondaryKey` | securestring | `''` |  | SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. |
| `deadLetterSecret` | securestring | `''` |  | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| `deadLetterUri` | string | `''` |  | Dead letter storage URL for identity-based authentication. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `endpointUri` | string | `''` |  | The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://'. |
| `entityPath` | string | `''` |  | The EventHub name in the EventHub namespace for identity-based authentication. |
| `name` | string | `'EventHubEndpoint'` |  | The name of the Digital Twin Endpoint. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `userAssignedIdentity` | string | `''` |  | The ID to assign to the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |

## Cross-referenced modules

_None_
