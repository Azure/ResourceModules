# Key Vault Access Policies `[Microsoft.KeyVault/vaults/accessPolicies]`

This module deploys key vault access policies.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2021-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accessPolicies` | array | `[]` |  | Optional. An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault's tenant ID. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `keyVaultName` | string |  |  | Required. The name of the key vault |
| `name` | string | `add` |  | Optional. The access policy deployment |


### Parameter Usage: `accessPolicies`

```json
"accessPolicies": {
    "value": [
        {
            "tenantId": null, // Optional
            "applicationId": null, // Optional
            "objectId": null,
            "permissions": {
                "certificates": [
                    "All"
                ],
                "keys": [
                    "All"
                ],
                "secrets": [
                    "All"
                ]
            }
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `accessPolicyName` | string | The name of the access policies assignment |
| `accessPolicyResourceGroup` | string | The name of the resource group the access policies assignment was created in. |
| `accessPolicyResourceId` | string | The resource ID of the access policies assignment |

## Template references

- [Vaults/Accesspolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies)
