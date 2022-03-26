# API Management Service Named Values `[Microsoft.ApiManagement/service/namedValues]`

This module deploys API Management Service Named Values.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/namedValues` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `displayName` | string |  |  | Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `keyVault` | object | `{object}` |  | Optional. KeyVault location details of the namedValue.  |
| `name` | string |  |  | Required. Named value Name. |
| `namedValueTags` | array | `[]` |  | Optional. Tags that when provided can be used to filter the NamedValue list. - string |
| `secret` | bool | `False` |  | Optional. Determines whether the value is a secret and should be encrypted or not. Default value is false. |
| `value` | string | `[newGuid()]` |  | Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |

### Parameter Usage: `keyVault`

```json
"keyVault": {
    "value":{
        "secretIdentifier":"Key vault secret identifier for fetching secret.",
        "identityClientId":"SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret."
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the named value |
| `resourceGroupName` | string | The resource group the named value was deployed into |
| `resourceId` | string | The resource ID of the named value |

## Template references

- [Service/Namedvalues](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/namedValues)
