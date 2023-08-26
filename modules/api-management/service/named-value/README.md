# API Management Service Named Values `[Microsoft.ApiManagement/service/namedValues]`

This module deploys an API Management Service Named Value.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/namedValues` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/namedValues) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `displayName` | string | Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters. |
| `name` | string | Named value Name. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `keyVault` | object | `{object}` | KeyVault location details of the namedValue. |
| `secret` | bool | `False` | Determines whether the value is a secret and should be encrypted or not. Default value is false. |
| `tags` | array | `[]` | Tags that when provided can be used to filter the NamedValue list. - string. |
| `value` | string | `[newGuid()]` | Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |


### Parameter Usage: `keyVault`

<details>

<summary>Parameter JSON format</summary>

```json
"keyVault": {
    "value":{
        "secretIdentifier":"Key vault secret identifier for fetching secret.",
        "identityClientId":"SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret."
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
keyVault: {
    secretIdentifier:'Key vault secret identifier for fetching secret.'
    identityClientId:'SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret.'
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the named value. |
| `resourceGroupName` | string | The resource group the named value was deployed into. |
| `resourceId` | string | The resource ID of the named value. |

## Cross-referenced modules

_None_
