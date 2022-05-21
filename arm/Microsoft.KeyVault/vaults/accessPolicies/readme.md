# Key Vault Access Policies `[Microsoft.KeyVault/vaults/accessPolicies]`

This module deploys key vault access policies.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies) |

## Parameters

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `keyVaultName` | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `accessPolicies` | array | `[]` | An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault's tenant ID. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'add'` | The access policy deployment. |


### Parameter Usage: `accessPolicies`

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
accessPolicies: [
    {
        tenantId: null // Optional
        applicationId: null // Optional
        objectId: null
        permissions: {
            certificates: [
                'All'
            ]
            keys: [
                'All'
            ]
            secrets: [
                'All'
            ]
        }
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policies assignment. |
| `resourceGroupName` | string | The name of the resource group the access policies assignment was created in. |
| `resourceId` | string | The resource ID of the access policies assignment. |
