# App Configuration Stores Key Values `[Microsoft.AppConfiguration/configurationStores/keyValues]`

This module deploys an App Configuration Store Key Value.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AppConfiguration/configurationStores/keyValues` | [2021-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2021-10-01-preview/configurationStores/keyValues) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the key. |
| `value` | string | Name of the value. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appConfigurationName` | string | The name of the parent app configuration store. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `contentType` | string | `''` | The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `tags` | object | `{object}` | Tags of the resource. |



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
| `name` | string | The name of the key values. |
| `resourceGroupName` | string | The resource group the batch account was deployed into. |
| `resourceId` | string | The resource ID of the key values. |

## Cross-referenced modules

_None_
