# Key Vault Key `[Microsoft.KeyVault/vaults/keys]`

This module deploys a key vault key.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults/keys` | 2019-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `attributesEnabled` | bool | `True` |  | Optional. Determines whether the object is enabled. |
| `attributesExp` | int | `-1` |  | Optional. Expiry date in seconds since 1970-01-01T00:00:00Z. |
| `attributesNbf` | int | `-1` |  | Optional. Not before date in seconds since 1970-01-01T00:00:00Z. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `curveName` | string | `P-256` | `[P-256, P-256K, P-384, P-521]` | Optional. The elliptic curve name. |
| `keyOps` | array | `[]` | `[decrypt, encrypt, import, sign, unwrapKey, verify, wrapKey]` | Optional. Array of JsonWebKeyOperation |
| `keySize` | int | `-1` |  | Optional. The key size in bits. For example: 2048, 3072, or 4096 for RSA. |
| `kty` | string | `EC` | `[EC, EC-HSM, RSA, RSA-HSM]` | Optional. The type of the key. |
| `name` | string |  |  | Required. The name of the key |
| `tags` | object | `{object}` |  | Optional. Resource tags. |
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
| `keyName` | string | The Name of the key. |
| `keyResourceGroup` | string | The name of the Resource Group the key was created in. |
| `keyResourceId` | string | The Resource Id of the key. |

## Template references

- [Vaults/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/keys)
