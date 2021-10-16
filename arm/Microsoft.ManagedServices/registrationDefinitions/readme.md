# registrationDefinitions

This module deploys `registrationDefinitions` and `registrationAssignments` (often refered to as 'Lighthouse' or 'resource delegation')
on subscription or resource group scopes. This type of delegation is very similar to role assignments but here the principal that is
assigned a role is in a remote/managing Azure Active Directory tenant. The templates are run towards the tenant where
the Azure resources you want to delegate access to are, providing 'authorizations' (aka. access delegation) to principals in a
remote/managing tenant.

## Resource types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ManagedServices/registrationAssignments` | 2019-09-01 |
| `Microsoft.ManagedServices/registrationDefinitions` | 2019-09-01 |

## Parameters
| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizations` | array |  |  | Required. Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers. |
| `managedByTenantId` | string |  |  | Required. Specify the tenant ID of the tenant which homes the principals you are delegating permissions to. |
| `registrationDefinitionName` | string |  |  | Required. Specify a unique name for your offer/registration. i.e '<Managing Tenant> - <Remote Tenant> - <ResourceName>' |
| `registrationDescription` | string |  |  | Required. Description of the offer/registration. i.e. 'Managed by <Managing Org Name>' |
| `resourceGroupName` | string |  |  | Optional. Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription. |

### Parameter Usage: `authorizations`

| Parameter Name           | Type   | Default Value | Possible values | Description                                                                                 |
| :----------------------- | :----- | :------------ | :-------------- | :------------------------------------------------------------------------------------------ |
| `principalId`            | string |               | GUID            | Required. The object ID of the principal in the managing tenant to delegate permissions to. |
| `principalIdDisplayName` | string | `principalId` |                 | Optional. A display name of the principal that is delegated permissions to.                 |
| `roleDefinitionId`       | string |               | GUID            | Required. The role definition ID to delegate to the principal in the managing tenant.       |

```json
"authorizations": {
    "value": [
        // Delegates 'Reader' to a group in managing tenant (managedByTenantId)
        {
            "principalId": "9d949eef-00d5-45d9-8586-56be91a13398",
            "principalIdDisplayName": "Reader-Group",
            "roleDefinitionId": "acdd72a7-3385-48ef-bd42-f606fba81ae7"
        },
        // Delegates 'Contributor' to a group in managing tenant (managedByTenantId)
        {
            "principalId": "06eb144f-1a10-4935-881b-757efd1d0b58",
            "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        // Delegates 'Managed Services Registration assignment Delete Role' to a group in managing tenant (managedByTenantId)
        {
            "principalId": "9cd792b0-dc7c-4551-84f8-dd87388030fb",
            "principalIdDisplayName": "LighthouseManagement-Group",
            "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
    ]
}
```

## Outputs
| Output Name | Type |
| :-- | :-- |
| `registrationAssignmentId` | string |
| `registrationDefinitionId` | string |
| `registrationDefinitionName` | string |

## Template references
- [Registrationassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2019-09-01/registrationAssignments)
- [Registrationdefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2019-09-01/registrationDefinitions)
