# Key Vault Secret `[Microsoft.KeyVault/vaults/secrets]`

This module deploys a key vault secret.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults/secrets` | 2019-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `attributesEnabled` | bool | `True` |  | Optional. Determines whether the object is enabled. |
| `attributesExp` | int | `-1` |  | Optional. Expiry date in seconds since 1970-01-01T00:00:00Z. |
| `attributesNbf` | int | `-1` |  | Optional. Not before date in seconds since 1970-01-01T00:00:00Z. |
| `contentType` | secureString |  |  | Optional. The content type of the secret. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. The name of the secret |
| `tags` | object | `{object}` |  | Optional. Resource tags. |
| `value` | secureString |  |  | Required. The value of the secret. NOTE: "value" will never be returned from the service, as APIs using this model are is intended for internal use in ARM deployments. Users should use the data-plane REST service for interaction with vault secrets. |
| `vaultName` | string |  |  | Required. The name of the key vault |

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `secretName` | string | The Name of the secret. |
| `secretResourceGroup` | string | The name of the Resource Group the secret was created in. |
| `secretResourceId` | string | The Resource Id of the secret. |

## Template references

- [Vaults/Secrets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/secrets)
