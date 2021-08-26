# DiskEncryptionSet

This template deploys a Disk Encryption Set


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.KeyVault/vaults/accessPolicies`|2019-09-01|
|`Microsoft.Compute/diskEncryptionSets`|2019-11-01|
|`Microsoft.Compute/diskEncryptionSets/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diskEncryptionSetName` | string | Required. The name of the disk encryption set that is being created. |  |  |
| `keyUrl` | string | Required. Key Url (with version) pointing to a key or secret in KeyVault. |  |  |
| `keyVaultId` | string | Required. Resource id of the KeyVault containing the key or secret. |  |  |
| `location` | string | Optional. Resource location. | [resourceGroup().location] |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the Automation Account resource. |  |  |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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
| `diskEncryptionResourceGroup` | string | Name of the Resource Group. |
| `diskEncryptionSetResourceId` | string | Resourece ID of the resource. |
| `keyVaultName` | string | Name of the KeyVault. |
| `principalId` | string | Principal ID. |

## Considerations

N/A

## Additional resources

- [Microsoft.Compute diskEncryptionSets template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/diskencryptionsets)
