# Key Vault Key `[Microsoft.KeyVault/vaults/keys]`

This module deploys a key vault key.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.KeyVault/vaults/keys` | 2019-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `attributesEnabled` | bool | `True` |  | Optional. Determines whether the object is enabled. |
| `attributesExp` | int | `-1` |  | Optional. Expiry date in seconds since 1970-01-01T00:00:00Z. |
| `attributesNbf` | int | `-1` |  | Optional. Not before date in seconds since 1970-01-01T00:00:00Z. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `curveName` | string | `P-256` | `[P-256, P-256K, P-384, P-521]` | Optional. The elliptic curve name. |
| `keyOps` | array | `[]` | `[decrypt, encrypt, import, sign, unwrapKey, verify, wrapKey]` | Optional. Array of JsonWebKeyOperation |
| `keySize` | int | `-1` |  | Optional. The key size in bits. For example: 2048, 3072, or 4096 for RSA. |
| `keyVaultName` | string |  |  | Required. The name of the key vault |
| `kty` | string | `EC` | `[EC, EC-HSM, RSA, RSA-HSM]` | Optional. The type of the key. |
| `name` | string |  |  | Required. The name of the key |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Resource tags. |

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

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `keyName` | string | The name of the key. |
| `keyResourceGroup` | string | The name of the resource group the key was created in. |
| `keyResourceId` | string | The resource ID of the key. |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Vaults/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/keys)
