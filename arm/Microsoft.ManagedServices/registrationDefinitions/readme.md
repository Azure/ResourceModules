# Registration Definitions `[Microsoft.ManagedServices/registrationDefinitions]`

This module deploys `registrationDefinitions` and `registrationAssignments` (often refered to as 'Lighthouse' or 'resource delegation')
on subscription or resource group scopes. This type of delegation is very similar to role assignments but here the principal that is
assigned a role is in a remote/managing Azure Active Directory tenant. The templates are run towards the tenant where
the Azure resources you want to delegate access to are, providing 'authorizations' (aka. access delegation) to principals in a
remote/managing tenant.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ManagedServices/registrationAssignments` | 2019-09-01 |
| `Microsoft.ManagedServices/registrationDefinitions` | 2019-09-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `authorizations` | array | Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers. |
| `managedByTenantId` | string | Specify the tenant ID of the tenant which homes the principals you are delegating permissions to. |
| `name` | string | Specify a unique name for your offer/registration. i.e '<Managing Tenant> - <Remote Tenant> - <ResourceName>' |
| `registrationDescription` | string | Description of the offer/registration. i.e. 'Managed by <Managing Org Name>' |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `resourceGroupName` | string | `''` | Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription. |


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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `assignmentResourceId` | string | The registration assignment resource ID |
| `name` | string | The name of the registration definition |
| `resourceId` | string | The resource ID of the registration definition |
| `subscriptionName` | string | The subscription the registration definition was deployed into |

## Considerations

This module can be deployed both at subscription and resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter.
- To deploy the module at the subscription level, leave the `resourceGroupName` parameter empty.

### Permissions required to create delegations

This deployment must be done by a non-guest account in the customer's tenant which has a role with the `Microsoft.Authorization/roleAssignments/write` permission,
such as [`Owner`](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) for the subscription being onboarded (or which contains the resource groups that are being onboarded).

If the subscription was created through the Cloud Solution Provider (CSP) program, any user who has the AdminAgent role in your service provider tenant can perform the deployment.

**More info on this topic:**

- [Deploy the Azure Resource Manager templates - Onboard a customer to Azure Lighthouse | Microsoft Docs](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer#deploy-the-azure-resource-manager-templates)

### Permissions required to remove delegations

#### From customer side

Users in the customer's tenant who have a role with the `Microsoft.Authorization/roleAssignments/write` permission, such as
[`Owner`](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) can remove service provider
access to that subscription (or to resource groups in that subscription). To do so, the user can go to the Service providers
page of the Azure portal and delete the delegation.

#### From managing tenant side

Users in a managing tenant can remove access to delegated resources if they were granted the
[`Managed Services Registration Assignment Delete Role`](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#managed-services-registration-assignment-delete-role)
for the customer's resources. If this role was not assigned to any service provider users, the delegation can **only** be
removed by a user in the customer's tenant.

**More info on this topic:**

- [Service providers - Remove access to a delegation | Microsoft Docs](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/remove-delegation#service-providers)

### Limitations with Lighthouse and resource delegation

There are a couple of limitations that you should be aware of with Lighthouse:

- Only allows resource delegation within Azure Resource Manager. Excludes Azure Active Directory, Microsoft 365 and Dynamics 365.
- Only supports delegation of control plane permissions. Excludes data plane access.
- Only supports subscription and resource group scopes. Excludes tenant and management group delegations.
- Only supports built-in roles, with the exception of `Owner`. Excludes the use of custom roles.

**More info on this topic:**

- [Current limitations - Cross-tenant management experiences | Microsoft Docs](https://docs.microsoft.com/en-us/azure/lighthouse/concepts/cross-tenant-management-experience#current-limitations)
- [Troubleshooting - Onboard a customer to Azure Lighthouse | Microsoft Docs](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer#troubleshooting)

## Template references

- [Registrationassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2019-09-01/registrationAssignments)
- [Registrationdefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2019-09-01/registrationDefinitions)
